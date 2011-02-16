namespace :sitemapbuilder do
  
  desc 'create sitemap'
  task :create => :environment do
    include SitemapBuilder::Helper
    
    puts "CREATING SITEMAPS ..."
    generate_sitemap
  end
  
end