module Domctl
  ################
  # cluster_nodes 
  # ##############
ClusterNodesHelp = <<-EOF

Usage: domctl cluster_nodes

Show the Xen hosts (dom0) defined in #{Domctl::Config.config_file}

EOF

  ClusterNodesCommand = Proc.new do
    Domctl::Config.cluster_nodes.keys.sort.each do |n|
      puts n
    end
  end
end
