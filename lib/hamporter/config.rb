module Hamporter
  class Configuration
    def initialize
      config = YAML::load(File.open("~/.hamster"))
    end
  end
end
