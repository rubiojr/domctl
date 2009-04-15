module Domctl
  RecentDomusCommand = Proc.new do
    recent = []
    t = []
    print 'Working '
    Domctl::Config.each_host do |h|
      t << Thread.new do
        print '.'
        h.resident_vms.each do |vm|
          recent << [vm.label, vm.metrics.start_time] if vm.label != 'Domain-0'
        end
      end
    end
    t.each { |thread| thread.join }
    puts ' done.'
    recent.sort { |a,b| a[1] <=> b[1] }[-10..-1].reverse.each do |label, date|
      puts "#{label}".ljust(30) + date.to_s
    end
  end
end
