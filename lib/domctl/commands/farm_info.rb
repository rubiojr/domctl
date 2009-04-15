module Domctl
  ################
  # farm_info
  # ##############

FarmInfoHelp = <<-HELP

Usage: domctl farm_info

Print info from all the hosts defined in the config file:
- Memory Free
- Total Memory
- Number of CPUs
- Resident Virtual Machines (domUs)
- Number of CPUs/Cores
- CPUs/Cores utilisation

HELP

  FarmInfoCommand = Proc.new do
    buffer = ""
    print "Gathering Info"
    farm_total_mem = 0
    farm_free_mem = 0
    farm_resident_vms = 0
    farm_cpus = 0
    farm_hosts = 0
    threads = []
    Domctl::Config.each_host do |h|
      print '.'
      threads << Thread.new(buffer) do |bf|
        farm_hosts += 1
        buff = ''
        buff << "\n\n[#{h.label}]\n"
        buff << "-------\n"
        metrics = h.metrics
        mfree = Pangea::Util.humanize_bytes(metrics.memory_free)
        farm_free_mem += metrics.memory_free.to_i
        mtotal = Pangea::Util.humanize_bytes(metrics.memory_total)
        farm_total_mem += metrics.memory_total.to_i
        vms = h.resident_vms.size - 1
        farm_resident_vms += vms
        buff += "Resident VMs: #{vms}\n"
        buff += "Mem Free: #{mfree}  Mem Total: #{mtotal}\n"
        cpus = h.cpus.sort { |a,b| a.number <=> b.number }
        buff += "CPUs (#{cpus.size}): "
        cpus.each do |c|
          farm_cpus += 1
          buff += "%.2f  " % (c.utilisation * 100)
        end
        bf << buff
      end
    end
    threads.each { |t| t.join }
    buffer += "\n\n"
    puts buffer
    puts
    puts 'Global Info:'
    puts '-----------------------------------------------'
    puts "Farm Hosts:                #{farm_hosts}"
    puts "Farm Total Memory:         #{Pangea::Util.humanize_bytes(farm_total_mem)}"
    puts "Farm Free Memory:          #{Pangea::Util.humanize_bytes(farm_free_mem)}"
    puts "Farm Resident VMs:         #{farm_resident_vms}"
    puts "Farm CPUs:                 #{farm_cpus}"
    puts '-----------------------------------------------'
  end
end
