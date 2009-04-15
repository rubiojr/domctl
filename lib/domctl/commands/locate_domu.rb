module Domctl
  ################
  # locate_domu 
  # ##############
LocateDomuHelp = <<-HERE

domctl locate_domu <domU name>

Find the domUs matching <domU name>

EXAMPLES

domctl locate_domu test-vm

"Locates a DomU named test-vm."

HERE

  LocateDomuCommand = Proc.new do
    domus = []
    threads = []
    arg = DOMCTL_COMMANDS[:locate_domu][:args][0]
    if arg.nil?
      $stderr.puts DOMCTL_COMMANDS[:locate_domu][:help]
      exit 1
    end
    print "Searching"
    Domctl::Config.each_host do |h|
      print '.'
      threads << Thread.new do 
        h.resident_vms.each do |vm|
          if vm.label =~ /^.*#{arg}.*$/
            domus << "#{h.label}: #{vm.label}" 
          end
        end
      end
    end
    threads.each { |t| t.join }
    puts
    puts "DomU matching '#{arg}' not found." if domus.empty?
    domus.each { |d| puts d }
  end
end
