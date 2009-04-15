module Domctl
  ################
  # mem_info
  # ##############

MemInfoHelp = <<-HERE

Usage: domctl mem_info [dom0_name]

dom0_name is optional. If dom0_name is supplied, it only prints the memory info from the given host.

EXAMPLES

1. domctl mem_info xen0

"Print the memory info from xen0"

2. domctl mem_info

"Print the memory info from all the hosts defined in domctl config file"
HERE

  MemInfoCommand = Proc.new do
    node = DOMCTL_COMMANDS[:mem_info][:args][0]
    threads = []
    buffer = ""
    if node.nil?
      print 'Working'
      Domctl::Config.each_host do |h|
        print '.'
        threads << Thread.new do
          mfree = Pangea::Util.humanize_bytes(h.metrics.memory_free)
          mtotal = Pangea::Util.humanize_bytes(h.metrics.memory_total)
          buffer << "#{h.label.ljust(30)} #{(mfree + ' free').ljust(15)} #{mtotal} available\n"
        end
      end
      threads.each { |t| t.join }
      puts
      puts buffer
    else
      Domctl::Config.exit_if_not_defined(node)
      settings = Domctl::Config.cluster_nodes[node]
      begin
        h = Pangea::Host.connect(settings['url'], settings['username'], settings['password'])
        mfree = Pangea::Util.humanize_bytes(h.metrics.memory_free)
        mtotal = Pangea::Util.humanize_bytes(h.metrics.memory_total)
        print "#{h.label}".ljust(30)
        print "#{mfree} free".ljust(15)
        puts "#{mtotal} available"
      rescue Exception
        puts "Error connecting to host #{node}. Skipping."
      end
    end
  end
end
