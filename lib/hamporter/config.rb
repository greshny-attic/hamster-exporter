module Hamporter
  class Configuration
    def initialize
      @config = YAML::load(File.open("~/.hamster"))
    end

    class << self
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
        @config['hamster']['db']
      end
    end

  end
end
