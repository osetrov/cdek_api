# frozen_string_literal: true
#
module CdekApi
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def generate_install
      copy_file 'cdek_api.yml', 'config/cdek_api.yml'
      copy_file 'cdek_api.rb', 'config/initializers/cdek_api.rb'
    end
  end
end

