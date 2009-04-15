module Domctl
  ################
  # show_vifs
  # ##############
  ShowVifsCommand = Proc.new do
    found = false
    def print_vifs(h, vm_label)
      h.resident_vms.each do |vm|
        if vm.label =~ /^.*#{vm.label}.*$/
          found = true
          header = "[#{vm.label}]"
          puts
          puts header
          puts "-" * header.size
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
    domu_name = DOMCTL_COMMANDS[:show_vifs][:args][0]
    if domu_name.nil?
      $stderr.puts DOMCTL_COMMANDS[:show_vifs][:help]
      return
    end
    if domu_name =~ /^.*:.*$/
      host, domu = domu_name.split(':')
      Domctl::Config.exit_if_not_defined(host)
      settings = Domctl::Config.cluster_nodes[host]
      h = Pangea::Host.connect(settings['url'], settings['username'], settings['password'])
      print_vifs(h, domu)
      puts "DomU #{domu} not found in #{host}" if not found
    else
      puts "Searching..."
      Domctl::Config.each_host do |h|
        print_vifs(h, domu_name)
      end
      puts "#{args} not found." if not found
    end
  end
end
