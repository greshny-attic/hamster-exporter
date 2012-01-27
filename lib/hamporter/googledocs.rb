module Exporter
  class GoogleDocs < Base
    def initialize
      @session = GoogleSpreadsheet.login(Hamporter::Configuration.google_login, Hamporter::Configuration.google_password)
      add_worksheet
    end

    def push
      facts = Fact.filter(:start_time => Date.parse('2011-11-01')..Date.parse('2011-11-30'))
      fields = ['date', 'begin_time', 'finish_time', 'task', 'project']
      facts.each_with_index do |fact, i|
        fields.each_with_index do |field, index|
          @ws[i + Hamporter::Configuration.google_start_row, index + 1] = fact.send field
        end
        @ws.save
      end
    end

    private
    def add_worksheet
      @ws = session.spreadsheet_by_key(Hamporter::Configuration.google_key).worksheets[0]
    end


  end
end
