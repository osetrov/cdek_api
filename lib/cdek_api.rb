require 'faraday'
require 'multi_json'
require 'cdek_api/error'
require 'cdek_api/request'
require 'cdek_api/api_request'
require 'cdek_api/response'
require 'cdek_api/version'

module CdekApi
  class << self
    def generate_access_token(client_id=CdekApi.client_id, client_secret=CdekApi.client_secret, grant_type=CdekApi.grant_type)
      response = Faraday.post(CdekApi.url_token, "grant_type=#{grant_type}&client_id=#{client_id}&client_secret=#{client_secret}")
      JSON.parse(response.body)
    end

    def setup
      yield self
    end

    def register(name, value, type = nil)
      cattr_accessor "#{name}_setting".to_sym

      add_reader(name)
      add_writer(name, type)
      send "#{name}=", value
    end

    def add_reader(name)
      define_singleton_method(name) do |*args|
        send("#{name}_setting").value(*args)
      end
    end

    def add_writer(name, type)
      define_singleton_method("#{name}=") do |value|
        send("#{name}_setting=", DynamicSetting.build(value, type))
      end
    end
  end

  class DynamicSetting
    def self.build(setting, type)
      (type ? klass(type) : self).new(setting)
    end

    def self.klass(type)
      klass = "#{type.to_s.camelcase}Setting"
      raise ArgumentError, "Unknown type: #{type}" unless CdekApi.const_defined?(klass)
      CdekApi.const_get(klass)
    end

    def initialize(setting)
      @setting = setting
    end

    def value(*_args)
      @setting
    end
  end
end
