require 'rake'
$:.unshift(File.dirname(__FILE__) + "/lib")
require 'domctl'
require 'hoe'

Hoe.new('domctl', Domctl::VERSION) do |p|
  p.name = "domctl"
  p.author = "Sergio Rubio"
  p.description = %q{Xen Cluster Management Tool}
  p.email = 'sergio@rubio.name'
  p.summary = "Manage a cluster of Xen hosts"
  p.url = "http://github.com/rubiojr/domctl"
  p.remote_rdoc_dir = '' # Release to root
  p.extra_deps << [ "pangea","~> 0.1" ]
  p.extra_deps << [ "term-ansicolor",">= 1.0" ]
  p.developer('Sergio Rubio', 'sergio@rubio.name')
end

task :publish_dev_gem do
  `scp pkg/*.gem xen-fu.org:~/dev.xen-fu.org/gems/`
  `ssh xen-fu.org gem generate_index -d /home/rubiojr/dev.xen-fu.org/`
end
task :publish_gem do
  `scp pkg/*.gem xen-fu.org:~/gems.xen-fu.org/gems/`
  `ssh xen-fu.org gem generate_index -d /home/rubiojr/gems.xen-fu.org/`
end
