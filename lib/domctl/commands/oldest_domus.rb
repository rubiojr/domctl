module Domctl
  OldestDomusCommand = Proc.new do
    oldest = []
    print 'Working '
    Domctl::Config.each_host do |h|
      print '.'
      h.resident_vms.each do |vm|
        oldest << [vm.label, vm.metrics.start_time] if vm.label != 'Domain-0'
      end
    end
    puts ' done.'
    oldest.sort { |a,b| a[1] <=> b[1] }[0..9].each do |label, date|
      puts "#{label}".ljust(30) + date.to_s
    end
  end
end
