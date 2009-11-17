module SitemapBuilder  
  class Sitemap  
    attr_accessor :links, :default_host
    
    def initialize(options={})
      options = { 
        :debug => false,
        :default_host => 'http://localhost:3000', 
        :filename => 'sitemap.xml',
        :sitemap_folder => '',
        :ping_search_engines => false
      }.merge options
      @debug = options[:debug]
      @default_host = options[:default_host]
      @filename =  options[:filename]
      @sitemap_folder = options[:sitemap_folder]
      
      @links = []
      
      deleting_previous_sitemap(fullpath)
      create_sitemap_folder(@sitemap_folder)
    end
    
    def add(link, options={})
      link = Link.generate(link, @default_host, options)
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
      sitemap_uri = self.loc
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
  	  fullpath = "/public/"
  	  fullpath << @sitemap_folder + '/' unless @sitemap_folder.blank?
  	  fullpath << @filename
	  end
	  
	  def loc
	    loc = @default_host + '/'
	    loc << @sitemap_folder + '/' unless @sitemap_folder.blank?
	    loc << @filename
    end
   
    def deleting_previous_sitemap(sitemap)
      sitemap_files = Dir[File.join(RAILS_ROOT, sitemap)]
      FileUtils.rm sitemap_files, :verbose => true
    end
    
    def create_sitemap_folder(sitemap_folder)
      return if sitemap_folder.blank?
      path = RAILS_ROOT + "/public/" + sitemap_folder
      unless File.exists?(path) && File.directory?(path)
        FileUtils.mkdir path, :mode => 0755, :verbose => true
      end
    end
  end
end