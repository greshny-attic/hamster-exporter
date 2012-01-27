require 'sequel'
module Hamster

  DB = Sequel.connect(Hamporter::Configuration.instance.database_path)

  class Category < Sequel::Model
  end

  class Activity < Sequel::Model
    many_to_one :category, :key => :category_id
  end

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
end
