module Domctl
  ################
  # list_running
  # ##############
  ListRunningCommand = Proc.new do
    node = DOMCTL_COMMANDS[:list_running][:args][0]
    if node.nil?
      $stderr.puts DOMCTL_COMMANDS[:list_running][:help]
      exit 1
    end
    if node == 'all'
      Domctl::Config.each_host do |h|
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
    else
      if not Domctl::Config.node_defined?(node)
        $stderr.puts "ERROR: Xen host not defined in #{Domctl::Config.config_file}"
        exit 1
      end
      settings = Domctl::Config.cluster_nodes[node]
      begin
        h = Pangea::Host.connect(settings['url'], settings['username'], settings['password'])
        header = 'label'.ljust(30) + 'memory'.ljust(15) + 'power state'.ljust(15) + 'cpus'
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
      rescue Exception => e
        puts e.message
        puts "Error connecting to host #{node}. Skipping."
      end
    end
  end
end
