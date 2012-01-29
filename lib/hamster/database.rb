require 'sequel'
module Hamster
FIELDS = %w( activity category tag start_time end_time )

  DB = Sequel.connect(Hamporter::Configuration.instance.database_path)

  class Category < Sequel::Model
  end

  class Activity < Sequel::Model
    many_to_one :category, :key => :category_id
  end

  class Tag < Sequel::Model
  end

  class Fact < Sequel::Model
    many_to_one :activity, :key => :activity_id

    def begin_time
      DateTime.parse("#{self.start_time}").to_time.strftime(Hamporter::Configuration.instance.format_time)
    end

    def finish_time
      DateTime.parse("#{self.end_time}").to_time.strftime(Hamporter::Configuration.instance.format_time)
    end

    def date
      DateTime.parse("#{self.start_time}").to_time.strftime(Hamporter::Configuration.instance.format_date)
    end

    def task
      self.activity.name unless self.activity.name.nil?
    end

    def project
      self.activity.category.name unless self.activity.category.nil?
    end
  end

end
