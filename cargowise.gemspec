Gem::Specification.new do |s|
  s.name              = "cargowise"
  s.version           = "0.8.6"
  s.summary           = "Wrapper around entpriseEDI SOAP API by cargowise"
  s.description       = "Retrieve tracking and status information on your shipments from entpriseEDI"
  s.authors           = ["James Healy"]
  s.email             = ["james@yob.id.au"]
  s.homepage          = "http://github.com/yob/cargowise"
  s.has_rdoc          = true
  s.rdoc_options      << "--title" << "Cargowise" << "--line-numbers"
  s.files             = Dir.glob("lib/**/*.rb") + Dir.glob("examples/**/*.rb") + ["README.markdown", "CHANGELOG", "TODO", "COPYING", "MIT-LICENSE"]
  s.license           = "mit"
  s.add_dependency("curb")
  s.add_dependency("andand")
  s.add_dependency("handsoap", "~>1.1.7")
  s.add_dependency("nokogiri", "~>1.4")
  s.add_dependency("mechanize", "~>2.0")
end
