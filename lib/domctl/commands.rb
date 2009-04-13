Dir["#{File.dirname(__FILE__)}/commands/*.rb"].each do |c|
  require c
end

module Domctl
  DestroyDomuCommand = Proc.new do
  end
  
  CreateDomuCommand = Proc.new do
  end
end # end Domctl module
