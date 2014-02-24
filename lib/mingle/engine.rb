begin
  require "sidekiq"
rescue LoadError
end

module Mingle
  class Engine < ::Rails::Engine
    isolate_namespace Mingle

    config.eager_load_paths.delete_if do |path|
      Pathname.new(path).split.last.to_s == 'jobs' && !defined? Sidekiq
    end

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end

    rake_tasks do
      load 'tasks/mingle_tasks.rake'
    end
  end
end
