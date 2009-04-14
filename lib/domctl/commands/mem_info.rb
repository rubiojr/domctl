module Domctl
  ################
  # mem_info
  # ##############
  MemInfoCommand = Proc.new do
    node = DOMCTL_COMMANDS[:mem_info][:args][0]
    if node.nil?
      Domctl::Config.each_host do |h|
        mfree = Pangea::Util.humanize_bytes(h.metrics.memory_free)
        mtotal = Pangea::Util.humanize_bytes(h.metrics.memory_total)
        print "#{h.label}".ljust(30)
        print "#{mfree} free".ljust(15)
        puts "#{mtotal} available"
      end
    else
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
