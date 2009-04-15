module Domctl
  ################
  # help 
  # ##############
  HelpCommand = Proc.new do
    cmd = DOMCTL_COMMANDS[:help][:args][0]
    if not cmd.nil? and not DOMCTL_COMMANDS[cmd.to_sym].nil?
      puts DOMCTL_COMMANDS[cmd.to_sym][:help]
    else
puts """
domctl #{Domctl::VERSION}

Usage: #{File.basename(__FILE__)} command [arguments...]

  Available commands:

  help                          print this help or the help associated
                                to a command
  list_running                  list all running domUs in the specified dom0
  locate_domu                   find the dom0 hosting the specified domU
  show_vifs                     list the VIFs from a given domU
  domu_info                     print DomU info
  dom0_info                     print Dom0 info
  recent_domus                  print the last 10 domus created
  oldest_domus                  print the first 10 domus created
  mem_info                      print the memory available in a host
  farm_info                     print statistics from all the Hosts 
  cpu_utilisation               CPU utilisation from all the Hosts 
  cluster_nodes                 print the cluster nodes defined in #{Domctl::Config.config_file} 

Type domctl help <command> to get specific command help.

"""
    end
  end
end
