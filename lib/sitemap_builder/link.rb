module SitemapBuilder
  class Link
    class << self
      def generate(path, host, options={})
        options = { 
          :path => path,
          :priority => 0.5,
          :changefreq => 'weekly',
          :lastmod => Time.now,
          :host => host,
          :loc => URI.join(host, path).to_s
        }.merge options
      end
    end
  end
end