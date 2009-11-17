namespace :sitemapbuilder do
  
  desc 'create sitemap'
  task :create => [:clean, :environment] do
    include SitemapBuilder::Helper
    
    puts "CREATING SITEMAPS ..."
    generate_sitemap
  end
  
  desc 'delete all sitemaps'
  task :clean do
    puts "DELETING SITEMAPS ..."
    sitemap_files = Dir[File.join(RAILS_ROOT, 'public/sitemap*')]
    FileUtils.rm sitemap_files
  end
  
end