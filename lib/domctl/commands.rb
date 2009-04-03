module Domctl
  ################
  # locate_domu 
  # ##############
  LocateDomuCommand = Proc.new do
    args = DOMCTL_COMMANDS[:locate_domu][:args]
    if args.nil?
      $stderr.puts DOMCTL_COMMANDS[:locate_domu][:help]
      exit 1
    end
    Domctl::Config.cluster_nodes.each do |node, settings|
      begin
        h = Pangea::Host.connect(settings['url'], settings['username'], settings['password'])
      rescue Exception
        puts "Error connecting to host #{node}. Skipping."
      end
      h.resident_vms.each do |vm|
        puts "#{node}: #{vm.label}" if vm.label =~ /^.*#{args}.*$/
      end
    end
  end


  ################
  # list_running
  # ##############
  ListRunningCommand = Proc.new do
    node = DOMCTL_COMMANDS[:list_running][:args][0]
    if node.nil?
      $stderr.puts DOMCTL_COMMANDS[:list_running][:help]
      exit 1
    end
    settings = Domctl::Config.cluster_nodes[node]
    if settings.nil?
      $stderr.puts "ERROR: Xen host not defined in #{Domctl::Config.config_file}"
      exit 1
    end
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
  
  
  ################
  # show_vifs
  # ##############
  ShowVifsCommand = Proc.new do
    args = DOMCTL_COMMANDS[:show_vifs][:args][0]
    if args.nil?
      $stderr.puts DOMCTL_COMMANDS[:show_vifs][:help]
      exit 1
    end
    Domctl::Config.cluster_nodes.each do |node, settings|
      begin
        h = Pangea::Host.connect(settings['url'], settings['username'], settings['password'])
      rescue Exception
        puts "Error connecting to host #{node}. Skipping."
      end
      h.resident_vms.each do |vm|
        if vm.label == args
          puts "#{vm.label}"
          puts "------------------"
          vm.vifs.each do |vif|
            puts "Device:      #{vif.device}"
            puts "MAC Address: #{vif.mac}"
            metrics = vif.metrics
            puts "KBits/s IN:  #{metrics.io_read_kbs}"
            puts "KBits/s OUT: #{metrics.io_write_kbs}"
          end
        end
      end
    end
  end


  ################
  # cluster_nodes 
  # ##############
  ClusterNodesCommand = Proc.new do
    Domctl::Config.cluster_nodes.keys.sort.each do |n|
      puts n
    end
  end


  ################
  # help 
  # ##############
  HelpCommand = Proc.new do
  puts """
  domctl #{Domctl::VERSION_STRING}

  Usage: #{File.basename(__FILE__)} command [arguments...]

    Available commands:

    help                          print this help or the help associated
                                  to a command
    list_running                  list all running domUs in all the dom0s
    locate_domu                   find the dom0 hosting the specified domU
    show_vifs                     list the VIFs from a given domU

  Type domctl help <command> to get specific command help.

  """
  end

  DestroyDomuCommand = Proc.new do
  end
  
  CreateDomuCommand = Proc.new do
  end
end # end Domctl module
