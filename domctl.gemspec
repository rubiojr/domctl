Gem::Specification.new do |s|
  s.name = %q{domctl}
  s.version = "0.2.20090414130028"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sergio RubioSergio Rubio"]
  s.date = %q{2009-04-14}
  s.default_executable = %q{domctl}
  s.description = %q{Xen Cluster Management Tool}
  s.email = %q{sergio@rubio.namesergio@rubio.name}
  s.executables = ["domctl"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "bin/domctl", "domctl.gemspec", "lib/domctl.rb", "lib/domctl/commands.rb", "lib/domctl/commands/cluster_nodes.rb", "lib/domctl/commands/cpu_utilisation.rb", "lib/domctl/commands/dom0_info.rb", "lib/domctl/commands/domu_info.rb", "lib/domctl/commands/farm_info.rb", "lib/domctl/commands/help.rb", "lib/domctl/commands/list_running.rb", "lib/domctl/commands/locate_domu.rb", "lib/domctl/commands/mem_info.rb", "lib/domctl/commands/oldest_domus.rb", "lib/domctl/commands/recent_domus.rb", "lib/domctl/commands/show_vifs.rb", "lib/domctl/config.rb", "scripts/devrelease", "scripts/newrelease", "scripts/publish_release"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/rubiojr/domctl}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{domctl}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Manage a cluster of Xen hosts}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<pangea>, ["~> 0.1"])
      s.add_runtime_dependency(%q<term-ansicolor>, [">= 1.0"])
      s.add_development_dependency(%q<hoe>, [">= 1.12.1"])
    else
      s.add_dependency(%q<pangea>, ["~> 0.1"])
      s.add_dependency(%q<term-ansicolor>, [">= 1.0"])
      s.add_dependency(%q<hoe>, [">= 1.12.1"])
    end
  else
    s.add_dependency(%q<pangea>, ["~> 0.1"])
    s.add_dependency(%q<term-ansicolor>, [">= 1.0"])
    s.add_dependency(%q<hoe>, [">= 1.12.1"])
  end
end
