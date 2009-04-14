module Domctl
  ################
  # farm_info
  # ##############
  FarmInfoCommand = Proc.new do
    puts "Gathering Info..."
    Domctl::Config.each_host do |h|
      puts h.label
      puts "-------"
      mfree = Pangea::Util.humanize_bytes(h.metrics.memory_free)
      puts "Resident VMs: #{h.resident_vms.size}  Mem Free: #{mfree}"
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
