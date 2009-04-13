module Domctl
  ################
  # show_vifs
  # ##############
  ShowVifsCommand = Proc.new do
    def print_vif(vif)
      puts "Device:      #{vif.device}"
      puts "MAC Address: #{vif.mac}"
      metrics = vif.metrics
      puts "KBits/s IN:  #{metrics.io_read_kbs}"
      puts "KBits/s OUT: #{metrics.io_write_kbs}"
    end
    found = false
    args = DOMCTL_COMMANDS[:show_vifs][:args][0]
    if args.nil?
      $stderr.puts DOMCTL_COMMANDS[:show_vifs][:help]
      exit 1
    end
    if args =~ /^.*:.*$/
      host, domu = args.split(':')
      Domctl::Config.exit_if_not_defined(host)
      settings = Domctl::Config.cluster_nodes[host]
      h = Pangea::Host.connect(settings['url'], settings['username'], settings['password'])
      h.resident_vms.each do |vm|
        if vm.label == domu
          found = true
          puts "#{vm.label}"
          puts "------------------"
          vm.vifs.each do |vif|
            print_vif(vif)
          end
        end
      end
      puts "DomU #{domu} not found in #{host}" if not found
    else
      puts "Searching..."
      Domctl::Config.cluster_nodes.each do |node, settings|
        begin
          h = Pangea::Host.connect(settings['url'], settings['username'], settings['password'])
        rescue Exception
          puts "Error connecting to host #{node}. Skipping."
        end
        h.resident_vms.each do |vm|
          if vm.label == args
            found = true
            puts "#{vm.label}"
            puts "------------------"
            vm.vifs.each do |vif|
              print_vif(vif)
            end
          end
        end
      end
    end
    puts "#{args} not found." if not found
  end
end
