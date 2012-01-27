module Hamster
  class << self
    def database_connect
      DB = Sequel.connect(Configuration.database_path)
    end
  end
end
