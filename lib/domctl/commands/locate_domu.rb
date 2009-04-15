module Domctl
  ################
  # locate_domu 
  # ##############
  LocateDomuCommand = Proc.new do
    domus = []
    arg = DOMCTL_COMMANDS[:locate_domu][:args][0]
    if arg.nil?
      $stderr.puts DOMCTL_COMMANDS[:locate_domu][:help]
      return
    end
    print "Searching"
    Domctl::Config.cluster_nodes.sort.each do |node, settings|
      begin
        h = Pangea::Host.connect(settings['url'], settings['username'], settings['password'])
      rescue Exception
        puts "Error connecting to host #{node}. Skipping."
      end
      h.resident_vms.each do |vm|
        if vm.label =~ /^.*#{arg}.*$/
          domus << "#{node}: #{vm.label}" 
        end
      end
      print '.'
    end
    puts
    puts "DomU matching '#{arg}' not found." if domus.empty?
    domus.each { |d| puts d }
  end
end
