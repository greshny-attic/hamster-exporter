module Exporter
  class Base
    def initialize
      raise "not implemented"
    end

    def push
      raise "not implemented"
    end
    #config = YAML::load(File.open("~/.hamster"))

    #DB = Sequel.connect("sqlite://#{ENV['HOME']}/.local/share/hamster-applet/hamster.db")

  end
end
