module Domctl
  ################
  # mem_status
  # ##############
  MemStatusCommand = Proc.new do
    node = DOMCTL_COMMANDS[:mem_status][:args][0]
    if node.nil?
      Domctl::Config.each_host do |h|
        puts "#{h.label}:".ljust(30) + "#{Pangea::Util.humanize_bytes(h.metrics.memory_free)} free"
      end
    else
      settings = Domctl::Config.cluster_nodes[node]
      begin
        h = Pangea::Host.connect(settings['url'], settings['username'], settings['password'])
        puts "#{h.label}: #{Pangea::Util.humanize_bytes(h.metrics.memory_free)} free"
      rescue Exception
        puts "Error connecting to host #{node}. Skipping."
      end
    end
  end
end
