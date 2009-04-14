module Domctl
  CpuUtilisationCommand = Proc.new do
    puts "Gathering info..."
    table = {}
    Domctl::Config.each_host do |h|
      table[h.label] = h.cpus.sort { |a,b| a.number <=> b.number }
    end
    cols = 0
    rows = []
    rc = 0
    table = table.sort { |a,b| a[0] <=> b[0] }
    table.each do |l,cpus|
      cols = cpus.size if cpus.size > cols
      r = Term::ANSIColor.bold("[#{l}]") + "\n"
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
