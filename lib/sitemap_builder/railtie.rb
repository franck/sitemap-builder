require 'sitemap_builder'
require 'rails'

module SitemapBuilder
  class Railtie < Rails::Railtie
    railtie_name :sitemap_builder
    
    rake_tasks do
      load "tasks/sitemap_builder_tasks.rake"
    end

  end
end
