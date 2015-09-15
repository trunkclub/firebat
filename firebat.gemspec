Gem::Specification.new do |s|
  s.name        = 'firebat'
  s.version     = '0.0.1'
  s.summary     = "Firebat is a utility for setting up smoke tests for distributed systems."
  s.description = "Firebat is a utility for setting up smoke tests for distributed systems."
  s.authors     = ["Jeff Meyers"]
  s.email       = 'jeff@trunkclub.com'
  s.homepage    = 'http://trunkclub.com/engineering'
  s.files       = ["lib/firebat.rb"]

  s.add_dependency "httparty"
  s.add_dependency "dotenv"
  s.add_dependency "rake"
end
