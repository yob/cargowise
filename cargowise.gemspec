Gem::Specification.new do |s|
  s.name              = "cargowise"
  s.version           = "0.10.2"
  s.summary           = "client library for the ediEnterprise SOAP API by cargowise"
  s.description       = "Retrieve tracking and status information on your shipments from ediEnterprise"
  s.authors           = ["James Healy"]
  s.email             = ["james@yob.id.au"]
  s.homepage          = "http://github.com/yob/cargowise"
  s.has_rdoc          = true
  s.rdoc_options      << "--title" << "Cargowise" << "--line-numbers"
  s.files             = Dir.glob("lib/**/*.rb") + Dir.glob("lib/**/*.xml") + Dir.glob("examples/**/*.rb") + ["README.markdown", "CHANGELOG", "TODO", "COPYING", "MIT-LICENSE"]
  s.license           = "mit"
  s.add_dependency("andand")
  s.add_dependency("savon", "~>2.2.0")
  s.add_dependency("nokogiri", "~>1.4")
  s.add_dependency("mechanize", "~>2.0")
end
