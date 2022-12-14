module CdekApi
  class APIRequest

    def initialize(builder: nil)
      @request_builder = builder
    end

    def post(params: nil, headers: nil, body: {}, first_time: true)
      validate_access_token

      begin
        response = self.rest_client.post do |request|
          configure_request(request: request, params: params, headers: headers, body: MultiJson.dump(body))
        end
        parse_response(response)
      rescue StandardError => e
        if e.response.try(:dig, :status) == 401 && first_time
          CdekApi::Request.access_token = CdekApi.generate_access_token.try(:dig, "access_token")
          self.post(params: params, headers: headers, body: body, first_time: false)
        else
          handle_error(e)
        end
      end
    end

    def patch(params: nil, headers: nil, body: {}, first_time: true)
      validate_access_token

      begin
        response = self.rest_client.patch do |request|
          body[:senderId] = CdekApi.senders.first["id"] if body[:senderId].nil?
          configure_request(request: request, params: params, headers: headers, body: MultiJson.dump(body))
        end
        parse_response(response)
      rescue StandardError => e
        if e.response.dig(:status) == 401 && first_time
          CdekApi::Request.access_token = CdekApi.generate_access_token.try(:dig, "access_token")
          self.patch(params: params, headers: headers, body: body, first_time: false)
        else
          handle_error(e)
        end
      end
    end

    def put(params: nil, headers: nil, body: {}, first_time: true)
      validate_access_token

      begin
        response = self.rest_client.put do |request|
          configure_request(request: request, params: params, headers: headers, body: MultiJson.dump(body))
        end
        parse_response(response)
      rescue StandardError => e
        if e.response.dig(:status) == 401 && first_time
          CdekApi::Request.access_token = CdekApi.generate_access_token.try(:dig, "access_token")
          self.put(params: params, headers: headers, body: body, first_time: false)
        else
          handle_error(e)
        end
      end
    end

    def get(params: nil, headers: nil, first_time: true)
      validate_access_token

      begin
        response = self.rest_client.get do |request|
          configure_request(request: request, params: params, headers: headers)
        end
        parse_response(response)
      rescue StandardError => e
        if e.response.dig(:status) == 401 && first_time
          CdekApi::Request.access_token = CdekApi.generate_access_token.try(:dig, "access_token")
          self.get(params: params, headers: headers, first_time: false)
        else
          handle_error(e)
        end
      end
    end

    def delete(params: nil, headers: nil, first_time: true)
      validate_access_token

      begin
        response = self.rest_client.delete do |request|
          configure_request(request: request, params: params, headers: headers)
        end
        parse_response(response)
      rescue StandardError => e
        if e.response.dig(:status) == 401 && first_time
          CdekApi::Request.access_token = CdekApi.generate_access_token.try(:dig, "access_token")
          self.delete(params: params, headers: headers, first_time: false)
        else
          handle_error(e)
        end
      end
    end

    protected

    # Convenience accessors

    def access_token
      @request_builder.access_token
    end

    def api_endpoint
      @request_builder.api_endpoint
    end

    def timeout
      @request_builder.timeout
    end

    def open_timeout
      @request_builder.open_timeout
    end

    def proxy
      @request_builder.proxy
    end

    def adapter
      @request_builder.faraday_adapter
    end

    def symbolize_keys
      @request_builder.symbolize_keys
    end

    # Helpers

    def handle_error(error)
      error_params = {}

      begin
        if error.is_a?(Faraday::ClientError) && error.response
          error_params[:status_code] = error.response[:status]
          error_params[:raw_body] = error.response[:body]

          parsed_response = MultiJson.load(error.response[:body], symbolize_keys: symbolize_keys)

          if parsed_response
            error_params[:body] = parsed_response

            title_key = symbolize_keys ? :title : "title"
            detail_key = symbolize_keys ? :detail : "detail"

            error_params[:title] = parsed_response[title_key] if parsed_response[title_key]
            error_params[:detail] = parsed_response[detail_key] if parsed_response[detail_key]
          end

        end
      rescue MultiJson::ParseError
      end

      error_to_raise = Error.new(error.message, error_params)

      raise error_to_raise
    end

    def configure_request(request: nil, params: nil, headers: nil, body: nil)
      if request
        request.params.merge!(params) if params
        request.headers['Content-Type'] = 'application/json'
        request.headers['Authorization'] = "Bearer #{CdekApi::Request.access_token}"
        request.headers['User-Agent'] = "CdekApi/#{CdekApi::VERSION} Ruby gem"
        request.headers.merge!(headers) if headers
        request.body = body if body
        request.options.timeout = self.timeout
        request.options.open_timeout = self.open_timeout
      end
    end

    def rest_client
      client = Faraday.new(self.api_url, proxy: self.proxy, ssl: { version: "TLSv1_2" }) do |faraday|
        faraday.response :raise_error
        faraday.adapter adapter
        if @request_builder.debug
          faraday.response :logger, @request_builder.logger, bodies: true
        end
      end
      client
    end

    def parse_response(response)
      parsed_response = nil

      if response.body && !response.body.empty?
        begin
          headers = response.headers
          body = MultiJson.load(response.body, symbolize_keys: symbolize_keys)
          parsed_response = Response.new(headers: headers, body: body)
        rescue MultiJson::ParseError
          error_params = { title: "UNPARSEABLE_RESPONSE", status_code: 500 }
          error = Error.new("Unparseable response: #{response.body}", error_params)
          raise error
        end
      end

      parsed_response
    end

    def validate_access_token
      unless self.access_token
        raise CdekApi::Error, "You must set an access_token prior to making a call"
      end
    end

    def api_url
      base_api_url + @request_builder.path
    end

    def base_api_url
      "#{CdekApi.host}/v2/"
    end
  end
end
