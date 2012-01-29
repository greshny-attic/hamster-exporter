module Hamporter
  module Helpers
    def home_directory
      ENV['home']
    end

    def display(msg="", new_line=true)
      if new_line
        puts(msg)
      else
        print(msg)
        STDOUT.flush
      end
    end

    def error(msg)
      STDERR.puts(format_with_bang(msg))
    end

    def format_with_bang(message)
      return '' if message.to_s.strip.empty?
      " !    " + message.split("\n").join("\n !    ")
    end

    def ask
      STDIN.gets.strip
    end

    def confirm(message="Are you sure you wish to continue? (y/n)?")
      display("#{message} ", false)
      ask.downcase == 'y'
    end

    def format_date(date)
      date = Time.parse(date) if date.is_a? String
      format = Hamporter::Configuration.date_format || "%Y-%m-%d"
      date.strftime(format)
    end

    def format_time(time)
      time = Time.parse(time) if time.is_a? String
      format = Hamporter::Configuration.time_format || "%H:%M %Z"
      time.strftime(format)
    end

    def error_with_failure(message)
      display "failed"
      output_with_bang(message)
      exit 1
    end

  end
end
