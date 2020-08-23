this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(File.dirname(this_dir), 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'multi_json'
require 'ruby_route_services_pb'
require 'faker'

include Rubyroute

# runs a GetFeature rpc.
#
# - once with a point known to be present in the sample route database
# - once with a point that is not in the sample database
def run_get_person(stub: nil, request: nil)
  p 'GetPerson'
  p '----------'
  resp = stub.get_person(request)
  if resp.email != ''
    p "- found '#{request.name}', '#{resp.email}'"
  else
    p "- found nothing"
  end
end

def main
  stub = RubyRoute::Stub.new('localhost:50051', :this_channel_is_insecure)
  request = PersonRequest.new(name: 'Benedict Turner Ret.')
  run_get_person(stub: stub, request: request)
  request.name = ""
  run_get_person(stub: stub, request: request)
end

main
