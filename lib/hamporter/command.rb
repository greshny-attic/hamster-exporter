require 'hamporter/helpers'
require 'optparse'

module Hamporter
  module Command
    extend Hamporter::Helpers

    def self.load
      Dir[File.join(File.dirname(__FILE__),"command","*.rb")].each { |f| require f }
    end

    def self.commands
      @@commands ||= {}
    end

    def self.command_aliases
      @@command_aliases ||= {}
    end

    def self.current_command
      @current_command
    end

    def self.namespaces
      @@namespaces ||= {}
    end

    def self.register_command(command)
      commands[command[:command]] = command
    end

    def self.register_namespace(namespace)
      namspaces[namespace[:name]] = namespace
    end

    def self.global_options
      @global_options ||= []
    end

    def self.global_option(name, *args)
      global_options << { :name => name, :args => args }
    end

    global_option :help, "--help", "-h"

    def self.prepare_run(cmd, args=[])
      command = parse(cmd)

      unless command
        output_with_bang("`#{cmd}` is not hamporter command")
        output_with_bang("See `hamporter help` for additional details")
        exit(1)
      end

      @current_command = cmd

      opts = {}
      invalid_options = []

      parser = OptionParser.new do |parser|
        global_options.each do |global_option|
          parser.on(*global_option[:args]) do |value|
            opts[name.gsub("-","_").to_sym] = value
          end
        end
        command[:options].each do |name,option|
          parser.on("-#{option[:short]}", "--#{option[:long]}", option[:desc]) do |value|
            opts[name.gsub("-","_").to_sym] = value
          end
        end
      end

      begin
        parser.order!(args) do |nonopt|
          invalid_options << nonopt
        end
      rescue OptionParser::InvalidOption => ex
        invalid_options << ex.args.first
        retry
      end

      raise OptionParser::ParseError if opts[:help]

      args.concat(invalid_options)

      @current_args = args
      @current_options = opts

      [ command[:klass].new(args.dup, opts.dup), command[:method] ]
    end

    def self.run(cmd, arguments=[])
      object, method = prepare_run(cmd, arguments.dup)
      object.send(method)
    end

    def self.parse(cmd)
      commands[cmd] || commands[command_aliases[cmd]]
    end
  end
end
