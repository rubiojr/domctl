module Domctl
  ################
  # dom0_info
  ################
  Dom0InfoCommand = Proc.new do
    def print_dom0_info(h)
      puts "Label:             #{h.label}"
      puts "Memory Free:       #{Pangea::Util.humanize_bytes(h.metrics.memory_free)}"
      puts "Resident VMs:      #{h.resident_vms.size}"
      puts "Scheduler Policy:  #{h.sched_policy}"
      puts "CPUs:              #{h.cpus.size}"
      puts "Xen Version:       #{h.software_version['Xen']}"
      puts "Arch:              #{h.software_version['machine']}"
      puts "Kernel Version:    #{h.software_version['release']}"
      puts "Networks:"
      h.networks.each do |n|
        print "  #{n.label}"
      end
      puts
    end
    dom0 = DOMCTL_COMMANDS[:dom0_info][:args][0]
    if dom0.nil?
      $stderr.puts DOMCTL_COMMANDS[:dom0_info][:help]
      exit 1
    end
    dom0.strip.chomp!
    settings = Domctl::Config.cluster_nodes[dom0] 
    begin
      h = Pangea::Host.connect(settings['url'], settings['username'], settings['password'])
      print_dom0_info(h)
    rescue Exception
      puts "Error connecting to host #{node}. Skipping."
    end
  end
end