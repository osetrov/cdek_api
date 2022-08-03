require 'cdek_api'

CdekApi.setup do |config|
  if File.exist?('config/cdek_api.yml')
    processed = YAML.load_file('config/cdek_api.yml')[Rails.env]

    processed.each do |k, v|
      config::register k.underscore.to_sym, v
    end

    config::Request.access_token = ENV['CDEK_ACCESS_TOKEN'] || CdekApi.generate_access_token.try(:dig, "access_token")
    config::Request.timeout = 15
    config::Request.open_timeout = 15
    config::Request.symbolize_keys = true
    config::Request.debug = false
  end
end