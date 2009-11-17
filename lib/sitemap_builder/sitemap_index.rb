module SitemapBuilder  
  class SitemapIndex
    attr_accessor :sitemaps
    
    def initialize(options={})
      options = { 
        :filename => 'sitemap_index.xml',
      }.merge options
      @filename = options[:filename]
      @sitemaps = []
    end
    
    def generate
      puts "GENERATING XML INDEX FILE ..." if @debug
    	xml_str = ""
    	xml = Builder::XmlMarkup.new(:target => xml_str, :indent=>2)

    	xml.instruct!
      xml.sitemapindex "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
        @sitemaps.each do |s|
          xml.sitemap do
            xml.loc s.loc
            xml.lastmod w3c_date(Time.now)
          end
        end
      end
    	save_file(xml_str)
    end
    
    def save_file(xml)
  		File.open(RAILS_ROOT + fullpath, "w+") do |f|
  			f.write(xml)
  		end		
  	end
  	
  	def fullpath
  	  "/public/" + @filename
	  end
    
  end
end