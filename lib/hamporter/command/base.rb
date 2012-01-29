class Hamporter::Command::Base
  include Hamporter::Helpers

  attr_reader :args
  attr_reader :options

  def initialize(args=[],options={})
    @args = args
    @options = options
  end

protected

  def self.method_added(method)
    return if self == Hamporter::Command::Base
    return if private_method_defined?(method)
    return if protected_method_defined?(method)

    help = extract_help_from_caller(caller.first)
    resolved_method = (method.to_s == "index") ? nil : method.to_s
    command = [ self.namespace, resolved_method ].compact.join(":")
    banner = extract_banner(help) || command
    permute = !banner.index("*")
    banner.gsub!("*", "")

    Hamporter::Command.register_command(
      :klass        => self,
      :method       => method,
      :namespace    => self.namespace,
      :command      => command,
      :banner       => banner,
      :help         => help,
      :summary      => extract_summary(help),
      :description  => extract_description(help),
      :options      => extract_options(help),
      :permute      => permute
    )
  end

  def self.extract_help_from_caller(line)
    if line =~ /^(.+?):(\d)/
      return extract_help($1,$2)
    end
    raise "unable to extract help from caller: #{line}"
  end

  def self.extract_help(file, line)
    buffer = []
    lines = File.read(file).split("\n")

    catch(:done) do
      (line.to_i-2).downto(0) do |i|
        case lines[i].strip[0..0]
          when "", "#" then buffer << lines[i]
          else throw(:done)
        end
      end
    end

    buffer.map! { |line| line.strip.gsub(/^#/,"") }
    buffer.reverse.join("\n").strip
  end

  def self.extract_banner(help)
    help.split("\n").first
  end

  def self.extract_summary(help)
    extract_description(help).split("\n").first
  end

  def self.extract_description(help)
    lines = help.split("\n").map(&:strip)
    lines.shift
    lines.reject do |line|
      line =~ /^-(.+)#(.+)$/
    end.join("\n").strip
  end

  def self.extract_options(help)
    help.split("\n").map { |l| l.strip }.select do |line|
      line =~ /^-(.+)#(.+)/
    end.inject({}) do |hash,line|
      description = line.split("#", 2).last.strip
      long = line.match(/--([A-Za-z\- ]+)/)[1].strip
      short = line.match(/-([A-Za-z ])/)[1].strip
      hash.update(long.split(" ").first => { :desc => description, :short => short, :long => long })
    end
  end

  def self.alias_command(new, old)
    raise "no such command: #{old}" unless Hamporter::Command.commands[old]
    Hamporter::Command.command_aliases[new] = old
  end

end
