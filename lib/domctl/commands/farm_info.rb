module Domctl
  ################
  # farm_info
  # ##############
  FarmInfoCommand = Proc.new do
    buffer = ""
    print "Gathering Info"
    farm_total_mem = 0
    farm_free_mem = 0
    farm_resident_vms = 0
    farm_cpus = 0
    farm_hosts = 0
    Domctl::Config.each_host do |h|
      print '.'
      farm_hosts += 1
      buffer += "[#{h.label}]\n"
      buffer += "-------\n"
      metrics = h.metrics
      mfree = Pangea::Util.humanize_bytes(metrics.memory_free)
      farm_free_mem += metrics.memory_free.to_i
      mtotal = Pangea::Util.humanize_bytes(metrics.memory_total)
      farm_total_mem += metrics.memory_total.to_i
      vms = h.resident_vms.size
      farm_resident_vms += vms
      buffer += "Resident VMs: #{h.resident_vms.size}\n"
      buffer += "Mem Free: #{mfree}  Mem Total: #{mtotal}\n"
      cpus = h.cpus.sort { |a,b| a.number <=> b.number }
      buffer += "CPUs: "
      cpus.each do |c|
        farm_cpus += 1
        buffer += "%.2f  " % (c.utilisation * 100)
      end
      buffer += "\n\n"
    end
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
