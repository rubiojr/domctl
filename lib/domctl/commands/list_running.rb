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
      Domctl::Config.cluster_nodes.sort.each do |node, settings|
        begin
          h = Pangea::Host.connect(settings['url'], settings['username'], settings['password'])
        rescue Exception
          puts "Error connecting to host #{node}. Skipping."
        end
        puts "#{node}"
        puts "---------"
        h.resident_vms.each do |vm|
          label = vm.label
          puts "#{label}" if label != 'Domain-0'
        end
        puts
      end
    else
      if not Domctl::Config.node_defined?(node)
        $stderr.puts "ERROR: Xen host not defined in #{Domctl::Config.config_file}"
        exit 1
      end
      settings = Domctl::Config.cluster_nodes[node]
      begin
        h = Pangea::Host.connect(settings['url'], settings['username'], settings['password'])
        puts "VM Label"
        puts "---------"
        h.resident_vms.each do |vm|
            label = vm.label
            puts "#{label}" if label != 'Domain-0'
        end
      rescue Exception
        puts "Error connecting to host #{node}. Skipping."
      end
    end
  end
end
