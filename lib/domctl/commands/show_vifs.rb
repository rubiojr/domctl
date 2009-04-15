module Domctl
  ################
  # show_vifs
  # ##############
  ShowVifsCommand = Proc.new do
    def print_vifs(h, vm_label)
      buffer = ''
      h.resident_vms.each do |vm|
        if vm.label =~ /^.*#{vm_label}.*$/
          header = "\n\n[#{vm.label}]\n"
          buffer << header
          buffer << ("-" * header.size)
          vm.vifs.each do |vif|
            buffer << "\nDevice:      #{vif.device} **\n"
            buffer << "MAC Address: #{vif.mac}\n"
            metrics = vif.metrics
            buffer << "KBits/s IN:  #{metrics.io_read_kbs}\n"
            buffer << "KBits/s OUT: #{metrics.io_write_kbs}"
          end
        end
      end
      buffer
    end
    domu_name = DOMCTL_COMMANDS[:show_vifs][:args][0]
    if domu_name.nil?
      $stderr.puts DOMCTL_COMMANDS[:show_vifs][:help]
      exit 1
    end
    if domu_name =~ /^.*:.*$/
      host, domu = domu_name.split(':')
      Domctl::Config.exit_if_not_defined(host)
      settings = Domctl::Config.cluster_nodes[host]
      h = Pangea::Host.connect(settings['url'], settings['username'], settings['password'])
      print_vifs(h, domu)
    else
      threads = []
      print "Searching"
      buffer = ''
      Domctl::Config.each_host do |h|
        print '.'
        threads << Thread.new do
          buffer << print_vifs(h, domu_name)
        end
      end
      threads.each { |t| t.join }
      puts ' done.'
      puts buffer if not buffer.empty?
    end
  end
end
