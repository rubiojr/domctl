module Domctl
  ################
  # cluster_nodes 
  # ##############
  ClusterNodesCommand = Proc.new do
    Domctl::Config.cluster_nodes.keys.sort.each do |n|
      puts n
    end
  end
end
