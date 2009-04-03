Gem::Specification.new do |s|
  s.name = %q{domctl}
  s.version = "0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sergio RubioSergio Rubio"]
  s.date = %q{2009-04-03}
  s.default_executable = %q{domctl}
  s.description = %q{Xen Cluster Management Tool}
  s.email = %q{sergio@rubio.namesergio@rubio.name}
  s.executables = ["domctl"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "bin/domctl", "lib/domctl.rb", "lib/domctl/commands.rb", "lib/domctl/config.rb", "test/test_domctl.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/rubiojr/domctl}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{domctl}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Manage a cluster of Xen hosts}
  s.test_files = ["test/test_domctl.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 1.12.1"])
    else
      s.add_dependency(%q<hoe>, [">= 1.12.1"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.12.1"])
  end
end
