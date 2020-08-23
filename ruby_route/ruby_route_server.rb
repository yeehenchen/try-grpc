this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(File.dirname(this_dir), 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'multi_json'
require 'ruby_route_services_pb'

include Rubyroute

class ServerImpl < RubyRoute::Service
  # @param [Hash] feature_db {location => name}
  def initialize(feature_db)
    @feature_db = feature_db
  end

  def get_person(request, _call)
    record = @feature_db.find{|db| db["name"] == request.name} || {"email" => ''}
    PersonResponse.new(email: record["email"])
  end
end

def main
  if ARGV.length == 0
    fail 'Please specify the path to the json database'
  end
  raw_data = []
  File.open(ARGV[0]) do |f|
    raw_data = MultiJson.load(f.read)
  end
  feature_db = raw_data
  port = '0.0.0.0:50051'
  s = GRPC::RpcServer.new
  s.add_http2_port(port, :this_port_is_insecure)
  GRPC.logger.info("... running insecurely on #{port}")
  s.handle(ServerImpl.new(feature_db))
  # Runs the server with SIGHUP, SIGINT and SIGQUIT signal handlers to 
  #   gracefully shutdown.
  # User could also choose to run server via call to run_till_terminated
  s.run_till_terminated_or_interrupted([1, 'int', 'SIGQUIT'])
end

main
