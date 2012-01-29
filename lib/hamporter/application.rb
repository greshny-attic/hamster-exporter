module Hamporter

  class Application

    def run(*args)
      command = args.shift.strip rescue "help"
      Hamporter::Command.load
      Hamporter::Command.exec(command, args)
      #Exporter::GoogleDocs.new.push
    end

  end

  class << self
    def application
      @application ||= Hamporter::Application.new
    end

    def application=(app)
      @application = app
    end
  end

end
