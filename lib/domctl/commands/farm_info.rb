module Domctl
  ################
  # farm_info
  # ##############
  FarmInfoCommand = Proc.new do
    puts "Gathering Info..."
    Domctl::Config.each_host do |h|
      puts h.label
      puts "-------"
      metrics = h.metrics
      mfree = Pangea::Util.humanize_bytes(metrics.memory_free)
      mtotal = Pangea::Util.humanize_bytes(metrics.memory_total)
      puts "Resident VMs: #{h.resident_vms.size}"
      puts "Mem Free: #{mfree}  Mem Total: #{mtotal}"
      cpus = h.cpus.sort { |a,b| a.number <=> b.number }
      print "CPUs: "
      cpus.each do |c|
        print "%.2f  " % (c.utilisation * 100)
      end
      puts
      puts
    end
  end
end
