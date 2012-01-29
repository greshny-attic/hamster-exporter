require "singleton"
require "hamporter/helpers"
module Hamporter
  extend Hamporter::Helpers

  class Hamporter::Configuration
    include Singleton

    def initialize(file=default_configuration_path)
      @file = file
      load_config || initialize_configuration
    end

    def load_config
      @config = YAML::load(File.open @file) rescue nil
    end

    def default_configuration_path
      "#{Hamporter.home_directory}/.hamporter"
    end

    def default_google_login
      "your-login@googlemail.com"
    end

    def default_google_password
      "secret"
    end

    def default_google_key
      "your-very-very-very-long-google-document-key"
    end

    def google_login
      @config['google-docs']['login']
    end

    def google_password
      @config['google-docs']['password']
    end

    def google_key
      @config['google-docs']['document-key']
    end

    def default_google_start_row
      2
    end

    def google_start_row
      @config['START_ROW'] || default_google_start_row
    end

    def default_database_path
      "#{Hamporter.home_directory}/.local/share/hamster-applet/hamster.db"
    end

    def database_path
      path = @config['hamster']['db'] || default_database_path
      "sqlite://#{path}"
    end

    def default_format_date
      "%d.%m.%Y"
    end

    def default_format_time
      "%H:%M"
    end

    def format_date
      @config['format_date'] || default_format_date
    end

    def format_time
      @config['format_time'] || default_format_time
    end

  private
    def initialize_configuration
      configuration =<<-EOF
      START_ROW: #{default_google_start_row}
      format_time: #{default_format_time}
      format_date: #{default_format_date}
      hamster:
        db: #{default_database_path}
      google-docs:
        login: #{default_google_login}
        password: #{default_google_password}
        document-key: #{default_google_key}
      EOF
      File.open(default_configuration_path,'w') { |f| f.write configuration}
      load_config
    end
  end
end
