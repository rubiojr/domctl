module Domctl
  ################
  # domu_info
  ################

DomuInfoHelp = <<-HERE

domctl domu_info <domu_name>

Print some info from the given domU. domu_name can be the full name
or the partial name from a running domU.

EXAMPLES

1. domctl domu_info vm-test

"Print info from vm-test"

2. domctl domu_info xen0:vm-test

"Print info from vm-test, but match only domUs resident in xen0 host"

HERE

  DomuInfoCommand = Proc.new do
    def print_vm_status(h, vm_label)
      h.resident_vms.each do |vm|
        if vm.label =~ /^.*#{vm_label}.*$/
          puts
          header = "[#{vm.label}]"
          puts header
          puts "-" * header.size
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
      end
    end
    args = DOMCTL_COMMANDS[:domu_info][:args][0]
    if args.nil?
      $stderr.puts DOMCTL_COMMANDS[:domu_info][:help]
      exit 1
    end
    args.strip.chomp!
    # dom0:domU notation
    if args =~ /^.*:.*$/
      host, domu = args.split(':')
      settings = Domctl::Config.cluster_nodes[host]
      h = Pangea::Host.connect(settings['url'], settings['username'], settings['password'])
      print_vm_status(h, domu)
    else
      domu = args
      puts "Searching..."
      Domctl::Config.each_host do |h|
        print_vm_status(h, domu)
      end
    end
  end
end
