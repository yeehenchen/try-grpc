require 'json'
require 'faker'

arr = []

10.times do
  tempHash = {
    name: Faker::Name.name,
    email: Faker::Internet.email,
  }
  arr << tempHash
end
File.write("db/database.json", JSON.pretty_generate(arr), mode: "a")
