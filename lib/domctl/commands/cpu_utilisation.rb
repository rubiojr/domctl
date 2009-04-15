module Domctl
CpuUtilisationHelp = <<-HERE

domctl cpu_utilisation

Print the CPUs/Cores utilisation in every node

HERE

  CpuUtilisationCommand = Proc.new do
    puts "Gathering info..."
    table = {}
    threads = []
    Domctl::Config.each_host do |h|
      threads << Thread.new do
        table[h.label] = h.cpus.sort { |a,b| a.number <=> b.number }
      end
    end
    threads.each { |t| t.join }
    cols = 0
    rows = []
    rc = 0
    table = table.sort { |a,b| a[0] <=> b[0] }
    table.each do |l,cpus|
      cols = cpus.size if cpus.size > cols
      r = Term::ANSIColor.bold("\n[#{l}]") + "\n"
      cpus.each do |c|
        r += ("%.2f" % (c.utilisation * 100)).ljust(8)
      end
      rows << r
    end
    header = ''
    0.upto(cols - 1) do |i| 
      header += "CPU#{i}".ljust(8)
    end
    puts header
    puts "-" * header.size
    rows.each do |r|
      puts r
    end
  end
end
