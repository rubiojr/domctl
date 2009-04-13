module Domctl
  ################
  # locate_domu 
  # ##############
  LocateDomuCommand = Proc.new do
    domus = []
    args = DOMCTL_COMMANDS[:locate_domu][:args]
    if args.nil?
      $stderr.puts DOMCTL_COMMANDS[:locate_domu][:help]
      exit 1
    end
    print "Searching"
    Domctl::Config.cluster_nodes.sort.each do |node, settings|
      begin
        h = Pangea::Host.connect(settings['url'], settings['username'], settings['password'])
      rescue Exception
        puts "Error connecting to host #{node}. Skipping."
      end
      h.resident_vms.each do |vm|
        if vm.label =~ /^.*#{args}.*$/
          domus << "#{node}: #{vm.label}" 
        end
      end
      print '.'
    end
    puts
    puts " Not found." if domus.empty?
    domus.each { |d| puts d }
  end
end
