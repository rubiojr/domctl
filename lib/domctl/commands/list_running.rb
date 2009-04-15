module Domctl
  ################
  # list_running
  # ##############
ListRunningHelp = <<-HERE

Usage: domctl list_running <dom0_name|all>

Lists the running domUs in a given host (in every defined host if 'all' parameter is used instead of the dom0 name)

EXAMPLES

1. domctl list_running xen0

"List all the domUs running in xen0"

2. domctl list_running all

"List all the domUs in every host defined in #{Domctl::Config.config_file}"

HERE

  ListRunningCommand = Proc.new do
    def print_running(h)
      buffer = "\n"
      header = 'label'.ljust(30) + 'memory'.ljust(15) + 'power state'.ljust(15) + 'cpus'
      buffer << "[#{h.label}]".rjust(header.size) + "\n"
      buffer << header + "\n"
      buffer << ("-" * header.size) + "\n"
      h.resident_vms.each do |vm|
          label = vm.label
          next if vm.is_control_domain?
          buffer << "#{label}".ljust(30) 
          metrics = vm.metrics
          m = Pangea::Util.humanize_bytes(metrics.memory_actual)
          buffer << m.ljust(15) 
          buffer << vm.power_state.to_s.ljust(15) 
          buffer << metrics.vcpus_number + "\n"
      end
      buffer
    end
    node = DOMCTL_COMMANDS[:list_running][:args][0]
    if node.nil?
      $stderr.puts DOMCTL_COMMANDS[:list_running][:help]
      exit 1
    end
    threads = []
    buffer = ''
    if node == 'all'
      print "Working"
      Domctl::Config.each_host do |h|
        print '.'
        threads << Thread.new do
          buffer << print_running(h)
        end
      end
    else
      Domctl::Config.exit_if_not_defined(node)
      settings = Domctl::Config.cluster_nodes[node]
      begin
        puts 'Working...'
        h = Pangea::Host.connect(settings['url'], settings['username'], settings['password'])
        threads << Thread.new do
          buffer << print_running(h)
        end
      rescue Exception => e
        puts e.message
        puts "Error connecting to host #{node}. Skipping."
      end
    end
    threads.each { |t| t.join }
    puts buffer
  end
end
