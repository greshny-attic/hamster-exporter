module Exporter
  class GoogleDocs < Base
    def initialize
      # FIXME: add configuration
      @session = GoogleSpreadsheet.login(config['google-docs']['login'], config['google-docs']['password'])
      add_worksheet
    end

    def push
      facts = Fact.filter(:start_time => Date.parse('2011-11-01')..Date.parse('2011-11-30'))
      fields = ['date', 'begin_time', 'finish_time', 'task', 'project']
      facts.each_with_index do |fact, i|
        fields.each_with_index do |field, index|
          @ws[i + config['START_ROW'], index + 1] = fact.send field
        end
        @ws.save
      end
    end

    private
    def add_worksheet
      @ws = session.spreadsheet_by_key(config['google-docs']['document-key']).worksheets[0]
    end


  end
end
