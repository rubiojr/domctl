module Domctl
  ################
  # domu_status
  ################
  DomuStatusCommand = Proc.new do
    def print_vm_status(vm)
      puts "Dom ID:            #{vm.domid}"
      puts "Max Mem:           #{Pangea::Util::humanize_bytes(vm.dyn_max_mem)}"
      puts "Min Mem:           #{Pangea::Util::humanize_bytes(vm.dyn_min_mem)}"
      puts "Power State:       #{vm.power_state}"
      puts "Resident On:       #{vm.resident_on.label}"
      puts "Actions:"
      puts "  after crash:       #{vm.actions_after_crash}"
      puts "  after reboot:      #{vm.actions_after_reboot}"
      puts "  after shutdown:    #{vm.actions_after_shutdown}"
    end
    args = DOMCTL_COMMANDS[:domu_status][:args][0]
    if args.nil?
      $stderr.puts DOMCTL_COMMANDS[:domu_status][:help]
      exit 1
    end
    args.strip.chomp!
    found = false
    # dom0:domU notation
    if args =~ /^.*:.*$/
      host, domu = args.split(':')
      settings = Domctl::Config.cluster_nodes[host]
      h = Pangea::Host.connect(settings['url'], settings['username'], settings['password'])
      h.resident_vms.each do |vm|
        if vm.label == domu
          found = true
          print_vm_status(vm)
        end
      end
      puts "DomU #{domu} not found in #{host}" if not found
    else
      domu = args
      puts "Searching..."
      Domctl::Config.cluster_nodes.each do |node, settings|
        begin
          h = Pangea::Host.connect(settings['url'], settings['username'], settings['password'])
        rescue Exception
          puts "Error connecting to host #{node}. Skipping."
        end
        h.resident_vms.each do |vm|
          if vm.label == domu
            found = true
            print_vm_status(vm)
          end
        end
      end
      puts "DomU #{domu} not found" if not found
    end
  end
end
