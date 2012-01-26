class Activity < Sequel::Model
  many_to_one :category, :key => :category_id
end
