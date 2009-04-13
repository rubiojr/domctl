module Domctl
  ################
  # help 
  # ##############
  HelpCommand = Proc.new do
  puts """
  domctl #{Domctl::VERSION}

  Usage: #{File.basename(__FILE__)} command [arguments...]

    Available commands:

    help                          print this help or the help associated
                                  to a command
    list_running                  list all running domUs in the specified dom0
    locate_domu                   find the dom0 hosting the specified domU
    show_vifs                     list the VIFs from a given domU
    domu_status                   print DomU info
    dom0_info                     print Dom0 info
    recent_domus                  print the last 10 domus created
    oldest_domus                  print the first 10 domus created

  Type domctl help <command> to get specific command help.

  """
  end
end
