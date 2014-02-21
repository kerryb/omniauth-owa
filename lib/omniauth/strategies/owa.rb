require "omniauth"
require "faraday"

module OmniAuth
  module Strategies
    class OWA
      include OmniAuth::Strategy
      OmniAuth.config.add_camelization "owa", "OWA"

      def request_phase
        form = OmniAuth::Form.new url: callback_path
        form.text_field "Username", :uid
        form.password_field "Password", :password
        form.button "Log in"
        form.to_response
      end

      def callback_phase
        uid, password = request.params.values_at "uid", "password"

        conn = Faraday.new url: options.base_url
        conn.basic_auth uid, password

        response = conn.get("/owa/?ae=Dialog&t=AddressBook&ctx=1&sch=#{uid}")
        return fail!(:invalid_credentials) unless response.success?
        search_results = response.body
        id = search_results.match(/<h1><a href="#" id="([^"]+)"/)[1]
        details = conn.get("/owa/?ae=Item&t=AD.RecipientType.User&id=#{CGI.escape id}").body

        @info = {}
        @info[:first_name] = details.match(/<td[^>]*>First name<\/td><td[^>]*>([^<]*)/)[1]
        @info[:last_name] = details.match(/<td[^>]*>Last name<\/td><td[^>]*>([^<]*)/)[1]
        @info[:email] = details.match(/<td[^>]*>E-mail<\/td><td[^>]*>([^<]*)/)[1]
        @info[:name] = "#{@info[:first_name]} #{@info[:last_name]}"
        super
      end

      uid do
        request.params.fetch "uid"
      end

      info do
        @info
      end
    end
  end
end
