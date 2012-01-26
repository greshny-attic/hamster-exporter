module Hamporter

  class Application
    def run
      puts "hello here"
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
