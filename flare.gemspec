Gem::Specification.new do |s|
  s.name        = 'flare'
  s.version     = '0.0.1'
  s.summary     = "Flare is a utility for setting up smoke tests for distributed systems."
  s.description = "Flare is a utility for setting up smoke tests for distributed systems."
  s.authors     = ["Jeff Meyers"]
  s.email       = 'jeff@trunkclub.com'
  s.homepage    = 'http://trunkclub.com/engineering'
  s.files       = ["lib/flare.rb"]

  s.add_dependency "httparty"
  s.add_dependency "dotenv"
end
