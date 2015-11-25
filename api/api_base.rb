# External dependencies
require 'active_record'
require 'grape'
require 'nokogiri'

# API Modules
require_relative 'api_ndc_endpoint'

module API

  class Base < Grape::API

    CONTENT_TYPE = "application/xml"
    RACK_CONTENT_TYPE_HEADER = {"content-type" => CONTENT_TYPE}
    HTTP_STATUS_CODES = Rack::Utils::HTTP_STATUS_CODES.invert

    format :xml
    content_type :xml, CONTENT_TYPE
    version 'v0', using: :path

    rescue_from Grape::Exceptions::Validation do |e|
      Rack::Response.new({ message: e.message }.to_json, 412, RACK_CONTENT_TYPE_HEADER).finish
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      Rack::Response.new({ message: "The item you are looking for does not exist."}.to_json, 404, RACK_CONTENT_TYPE_HEADER).finish
    end

    before do
      header['Access-Control-Allow-Origin'] = '*'
      header['Access-Control-Request-Method'] = '*'
      header['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS, PUT, PATCH, DELETE'
      header['Access-Control-Allow-Headers'] = 'true'
    end

    get '/', desc: "Lists API routes" do
      {
        routes: API::Base.routes.collect { |r| {
                                                route: {
                                                 version: r.instance_variable_get(:@options)[:version],
                                                 method: r.instance_variable_get(:@options)[:method],
                                                 path: r.instance_variable_get(:@options)[:path],
                                                }
                                               }
                                          }
      }
    end

    desc "Returns ok status if reached"
    get '/status' do
      {status: 'ok' }
    end

    # Mount other api modules here
    mount NDCEndpoint

  end

end
