# Example of config/sitemap.rb
# One sitemap = one Sitemap instance

# Example below generate two sitemaps. One per languages (FR and DE)
# and then generate a sitemap inde file with the location of these two sitemaps

sitemap_index = SitemapBuilder::SitemapIndex.new()

["fr", "de"].each do |locale|
  
  sitemap = SitemapBuilder::Sitemap.new(
    :debug => true,
    :host => "http://localhost:3000",
    :filename => "sitemap_#{locale}.yml",
    :ping_search_engines => true
  )
  
  
  sitemap.add "/#{locale}"
  
  sitemap.add articles_path(:locale => locale)
  Article.find(:all).each do |a|
    sitemap.add article_path(a, :locale => locale), :lastmod => a.updated_at
  end

  sitemap.generate
  sitemap.ping_search_engines
  sitemap_index.sitemaps << sitemap
end

sitemap_index.generate
