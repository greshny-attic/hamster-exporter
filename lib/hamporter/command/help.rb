require "hamporter/command/base"
class Hamporter::Command::Help < Hamporter::Command::Base

  PRIMARY_NAMESPACES = %w( googledocs hamster )

  # help [COMMAND]
  #
  # list available commands or display help for a specific command
  #
  def index
    if command = args.shift
      help_for_command(command)
    else
      help_for_root
    end
  end

  alias_command "-h", "help"
  alias_command "--help", "help"

  def self.usage_for_command(command)
    command = new.send(:commands)[command]
    "Usage: hamporter #{command[:banner]}" if command
  end

private

  def commands_for_namespace(name)
    Hamporter::Command.commands.values.select do |command|
      command[:namespace] == name && command[:command] != name
    end
  end

  def namespaces
    namespaces = Hamporter::Command.namespaces
    namespaces.delete("app")
    namespaces
  end

  def commands
    commands = Hamporter::Command.commands
    Hamporter::Command.command_aliases.each do |new,old|
      commands[new] = commands[old].dup
      commands[new][:command] = new
      commands[new][:namespace] = nil
      commands[new][:alias_for] = old
    end
    commands
  end

  def primary_namespaces
    PRIMARY_NAMESPACES.map { |name| namespaces[name] }.compact
  end

  def additional_namespaces
    (namespaces.values - primary_namespaces)
  end

  def summary_for_namespaces(namespaces)
    size = longest(namespaces.map { |n| n[:name] })
    namespaces.sort_by { |namespace| namespace[:name] }.each do |namespace|
      name = namespace[:name]
      puts "  %-#{size}s # %s" % [name, namespace[:description]]
    end
  end

  def help_for_root
    puts "Usage: hamporter COMMAND [command-specific-options]"
    puts
    puts "Primary help topics, type \"hamporter help TOPIC\" for more details:"
    puts
    summary_for_namespaces(primary_namespaces)
    puts
    puts "Additional topics:"
    puts
    summary_for_namespaces(additional_namespaces)
    puts
  end

  def help_for_namespace(name)
    namespace_commands = commands_for_namespace(name)
    unless namespace_commands.empty?
      size = longest(namespace_commands.map { |c| c[:banner] })
      namespace_commands.sort_by { |c| c[:banner].to_s }.each do |command|
        puts "  %-#{size}s  # %s" % [command[:banner], command[:summary]]
      end
    end
  end

  def help_for_command(name)
    command = commands[name]

    if command
      puts "Usage: hamporter #{command[:banner]}"
      if command[:help]
        puts command[:help].split("\n")[1..-1].join("\n")
      end
      puts
    end

    if commands_for_namespace(name).size > 0
      puts "Additional commands, type \"hamporter help COMMAND\" for more details:"
      puts
      help_for_namespace(name)
      puts
    elsif command.nil?
      error "#{name} is not a hamporter command. See 'hamporter help'."
    end
  end
end
