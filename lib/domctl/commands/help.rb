module Domctl
  ################
  # help 
  # ##############
  HelpCommand = Proc.new do
  puts """
  domctl #{Domctl::VERSION_STRING}

  Usage: #{File.basename(__FILE__)} command [arguments...]

    Available commands:

    help                          print this help or the help associated
                                  to a command
    list_running                  list all running domUs in the specified dom0
    locate_domu                   find the dom0 hosting the specified domU
    show_vifs                     list the VIFs from a given domU
    domu_status                   print the DomU status

  Type domctl help <command> to get specific command help.

  """
  end
end
