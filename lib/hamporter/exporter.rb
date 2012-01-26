module Exporter
  class Base
    def initialize
    end
    #config = YAML::load(File.open("~/.hamster"))

    #DB = Sequel.connect("sqlite://#{ENV['HOME']}/.local/share/hamster-applet/hamster.db")

    #session = GoogleSpreadsheet.login(config['google-docs']['login'], config['google-docs']['password'])

    #ws = session.spreadsheet_by_key(config['google-docs']['document-key']).worksheets[0]

    #facts = Fact.filter(:start_time => Date.parse('2011-11-01')..Date.parse('2011-11-30'))
    #fields = ['date', 'begin_time', 'finish_time', 'task', 'project']
    #facts.each_with_index do |fact, i|
      #fields.each_with_index do |field, index|
        #ws[i + config['START_ROW'], index + 1] = fact.send field
      #end
      #ws.save
    #end
  end
end
