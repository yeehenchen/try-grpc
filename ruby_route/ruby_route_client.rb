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

def run_get_people(stub: nil, requests: nil)
  p 'GetPeople'
  p '----------'
  people_request = PeopleEnumerator.new(requests, 1)
  stub.get_people(people_request.each_person).each {|r| p "received: #{r.inspect}"}
end

class PeopleEnumerator
  def initialize(people, delay)
    @people = people
    @delay = delay
  end

  def each_person
    return enum_for(:each_person) unless block_given?
    @people.each do |person|
      sleep @delay
      p "next person to send is #{person.inspect}"
      yield person
    end
  end
end

def main
  stub = RubyRoute::Stub.new('localhost:50051', :this_channel_is_insecure)
  # Unary
  p "Unary start"
  request = PersonRequest.new(name: 'Benedict Turner Ret.')
  run_get_person(stub: stub, request: request)
  request.name = ""
  run_get_person(stub: stub, request: request)
  p "Unary end"

  # Bidirectional
  p "Bidirectional start"
  requests = [
    PersonRequest.new(name: 'Benedict Turner Ret.'),
    PersonRequest.new(name: 'aaa'),
    PersonRequest.new(name: 'Tiffiny Crona II'),
    PersonRequest.new(name: 'Cornelius Hayes'),
    PersonRequest.new(name: 'Shiela Wuckert'),
    PersonRequest.new(name: 'Preston Fadel'),
  ]
  run_get_people(stub: stub, requests: requests)
  p "Bidirectional end"
end

main
