# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: ruby_route.proto for package 'rubyroute'

require 'grpc'
require 'ruby_route_pb'

module Rubyroute
  module RubyRoute
    # Interface exported by the server.
    class Service

      include GRPC::GenericService

      self.marshal_class_method = :encode
      self.unmarshal_class_method = :decode
      self.service_name = 'rubyroute.RubyRoute'

      rpc :getPerson, ::Rubyroute::PersonRequest, ::Rubyroute::PersonResponse
      rpc :getPeople, stream(::Rubyroute::PersonRequest), stream(::Rubyroute::PersonResponse)
    end

    Stub = Service.rpc_stub_class
  end
end
