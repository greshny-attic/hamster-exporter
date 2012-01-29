module Hamporter
  class Configuration
    include Singleton

    def initialize(file="#{ENV['HOME']}/.hamster")
      @file = file
      load_config
    end

    def file
      @file
    end

    def file=(file)
      @file = file
      load_config
    end

    def load_config
      @config = YAML::load(File.open @file)
    end

    def google_login
      @config['google-docs']['login']
    end

    def google_password
      @config['google-docs']['password']
    end

    def google_start_row
      @config['START_ROW']
    end

    def google_key
      @config['google-docs']['document-key']
    end

    def database_path
      "sqlite://#{@config['hamster']['db']}"
    end

    def format_date
      "%d.%m.%Y"
    end

    def format_time
    end
  end
end
