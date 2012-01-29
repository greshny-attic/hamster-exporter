class Hamporter::Command::GoogleDocs < Hamporter::Command::Base
  def initialize
    @session = GoogleSpreadsheet.login(Hamporter::Configuration.instance.google_login,
                                       Hamporter::Configuration.instance.google_password)
    add_worksheet
  end

  def push
    Hamster::DB
    facts = Hamster::Fact.filter(:start_time => Date.parse('2011-11-01')..Date.parse('2011-11-30'))
    fields = ['date', 'begin_time', 'finish_time', 'task', 'project']
    facts.each_with_index do |fact, i|
      fields.each_with_index do |field, index|
        @ws[i + Hamporter::Configuration.instance.google_start_row, index + 1] = fact.send field
      end
      @ws.save
    end
  end

  def add_worksheet
    @ws = @session.spreadsheet_by_key(Hamporter::Configuration.instance.google_key).worksheets[0]
  end

end
