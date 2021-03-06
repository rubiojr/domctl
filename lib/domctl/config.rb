module Domctl
  class Config
    def self.cluster_nodes
      yaml = YAML.load_file(self.config_file)
      yaml['cluster']
    end

    def self.validate
      if not File.exist?(self.config_file)
        self.create_sample_config
        $stderr.puts
        $stderr.puts "domctl config file does not exist.\n"
        $stderr.puts "I have created an example one for you (#{config_file}). Configure it first."
        $stderr.puts
        exit 1
      end
      yaml = YAML.load_file(self.config_file)
      if not yaml or yaml['cluster'].nil? or not yaml['cluster'].is_a?(Hash)
        $stderr.puts
        $stderr.puts "Invalid config file found.\n"
        $stderr.puts
        exit 1
      end
    end

    def self.create_sample_config
      if not File.exist?(self.config_file)
        File.open(self.config_file, 'w') do |f|
          cfg = { 'cluster' => {
                    'xen0' => {
                      'url' => 'http://xen0.example.net:9363',
                      'username' => 'foo',
                      'password' => 'bar'
                    },
                    'xen1' => {
                      'url' => 'http://xen1.example.net:9363',
                      'username' => 'foo',
                      'password' => 'bar'
                    }
                  }
          }
          YAML.dump(cfg, f)
        end
      end
    end

    def self.each_host
      cluster_nodes.sort.each do |node, settings|
        begin
          h = Pangea::Host.connect(settings['url'], settings['username'], settings['password'])
          yield h
        rescue Pangea::LinkConnectError => e
          puts "Error connecting to host #{node}. Skipping."
        end
      end
    end

    def self.exit_if_not_defined(node)
      settings = Domctl::Config.cluster_nodes[node]
      if settings.nil?
        $stderr.puts "ERROR: Xen host #{node} not defined in #{Domctl::Config.config_file}"
        exit 1
      end
    end
    def self.node_defined?(node)
      settings = Domctl::Config.cluster_nodes[node]
      if settings.nil?
        return false
      end
      true
    end

    def self.config_file
      "#{ENV['HOME']}/.domctlrc"
    end

  end
end
