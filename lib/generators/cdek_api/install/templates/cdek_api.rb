require 'ozon-logistics'

OzonLogistics.setup do |config|
  if File.exist?('config/ozon_logistics.yml')
    processed = YAML.load_file('config/ozon_logistics.yml')[Rails.env]

    processed.each do |k, v|
      config::register k.underscore.to_sym, v
    end

    config::Request.access_token = ENV['OZON_LOGISTICS_ACCESS_TOKEN'] || OzonLogistics.generate_access_token.try(:dig, "access_token")
    config::Request.timeout = 15
    config::Request.open_timeout = 15
    config::Request.symbolize_keys = true
    config::Request.debug = false
  end
end