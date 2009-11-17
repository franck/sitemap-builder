require 'sitemap_builder/link'
require 'sitemap_builder/helper'

module SitemapBuilder  
  class Sitemap  
    attr_accessor :links
    
    def initialize(options={})
      options = { 
        :debug => false,
        :host => 'http://localhost:3000', 
        :filename => 'sitemap.xml',
        :path_to_sitemap => '/',
        :ping_search_engines => false
      }.merge options
      @debug = options[:debug]
      @host = options[:host]
      @filename =  options[:filename]
      @path_to_sitemap = options[:path_to_sitemap]
      @links = []
    end
    
    def add(link, options={})
      link = Link.generate(link, @host, options)
      p link[:loc] if @debug
      @links << link
    end
        
    def generate
      puts "GENERATING XML FILE ..." if @debug
    	xml_str = ""
    	xml = Builder::XmlMarkup.new(:target => xml_str, :indent=>2)

    	xml.instruct!
      xml.urlset "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", 
        "xsi:schemaLocation" => "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/siteindex.xsd", 
        "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do

        links.each do |link|
          xml.url do
            xml.loc        link[:loc]
            xml.lastmod    w3c_date(link[:lastmod]) if link[:lastmod]
            xml.changefreq link[:changefreq]        if link[:changefreq]
            xml.priority   link[:priority]          if link[:priority]
          end 
        end
      end
    	save_file(xml_str)
    	ping_search_engines if @ping_search_engines
    end
    
    def ping_search_engines
      puts "PINGING SEARCH ENGINES ..." if @debug
      sitemap_uri = @host + @path_to_sitemap + @filename
	    index_location = URI.escape(sitemap_uri)
      search_engines = {
        :google => "http://www.google.com/webmasters/sitemaps/ping?sitemap=#{index_location}",
        :yahoo => "http://search.yahooapis.com/SiteExplorerService/V1/ping?sitemap=#{index_location}",
        :ask => "http://submissions.ask.com/ping?sitemap=#{index_location}",
        :bing => "http://www.bing.com/webmaster/ping.aspx?siteMap=#{index_location}"
      }
      
      search_engines.each do |engine, link|
        begin
          if @debug
            puts "pinging #{engine.to_s.titleize} : #{link}"
          else
            open(link)
            puts "Successful ping of #{engine.to_s.titleize}"
          end
        rescue Timeout::Error, StandardError => e
          puts "Ping failed for #{engine.to_s.titleize}: #{e.inspect}"
        end
      end      
    end
        
    def save_file(xml)
  		File.open(RAILS_ROOT + fullpath, "w+") do |f|
  			f.write(xml)	
  		end		
  	end
  	
  	def fullpath
  	  '/public' + @path_to_sitemap + @filename
	  end
  end
end