require 'rubygems'
require 'sequel'
require 'google_spreadsheet'
require 'yaml'

config = YAML::load(File.open("config.yml"))

DB = Sequel.connect("sqlite://#{ENV['HOME']}/.local/share/hamster-applet/hamster.db")

session = GoogleSpreadsheet.login(config['google-docs']['login'], config['google-docs']['password'])

ws = session.spreadsheet_by_key(config['google-docs']['document-key']).worksheets[0]

class Fact < Sequel::Model
  many_to_one :activity, :key => :activity_id

  def begin_time
    DateTime.parse("#{self.start_time}").to_time.strftime("%H:%M")
  end

  def finish_time
    DateTime.parse("#{self.end_time}").to_time.strftime("%H:%M")
  end

  def date
    DateTime.parse("#{self.start_time}").to_time.strftime("%d.%m.%Y")
  end

  def task
    self.activity.name unless self.activity.name.nil?
  end

  def project
    self.activity.category.name unless self.activity.category.nil?
  end

end

class Activity < Sequel::Model
  many_to_one :category, :key => :category_id
end

class Category < Sequel::Model
end

facts = Fact.filter(:start_time => Date.parse('2011-11-01')..Date.parse('2011-11-30'))

fields = ['date', 'begin_time', 'finish_time', 'task', 'project']
facts.each_with_index do |fact, i|
  fields.each_with_index do |field, index|
    ws[i + config['START_ROW'], index + 1] = fact.send field
  end
  ws.save
end
