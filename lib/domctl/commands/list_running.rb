module Domctl
  ################
  # list_running
  # ##############
  ListRunningCommand = Proc.new do
    def print_running(h)
      puts
      header = 'label'.ljust(30) + 'memory'.ljust(15) + 'power state'.ljust(15) + 'cpus'
      puts "[#{h.label}]".rjust(header.size)
      puts header
      puts "-" * header.size
      h.resident_vms.each do |vm|
          label = vm.label
          next if vm.is_control_domain?
          print "#{label}".ljust(30) 
          metrics = vm.metrics
          m = Pangea::Util.humanize_bytes(metrics.memory_actual)
          print m.ljust(15) 
          print vm.power_state.to_s.ljust(15) 
          print metrics.vcpus_number
          puts
      end
    end
    node = DOMCTL_COMMANDS[:list_running][:args][0]
    if node.nil?
      $stderr.puts DOMCTL_COMMANDS[:list_running][:help]
      return
    end
    if node == 'all'
      Domctl::Config.each_host do |h|
        print_running(h)
      end
    else
      Domctl::Config.exit_if_not_defined(node)
      settings = Domctl::Config.cluster_nodes[node]
      begin
        h = Pangea::Host.connect(settings['url'], settings['username'], settings['password'])
        print_running(h)
      rescue Exception => e
        puts e.message
        puts "Error connecting to host #{node}. Skipping."
      end
    end
  end
end
