module Hamster
  class << self
    def database_connect
      DB = Sequel.connect("sqlite://#{ENV['HOME']}/.local/share/hamster-applet/hamster.db")
    end
  end
end
