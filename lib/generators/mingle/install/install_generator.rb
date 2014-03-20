class Mingle::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def copy_config_file
    copy_file 'mingle_config.rb', 'config/initializers/mingle.rb'
  end
end
