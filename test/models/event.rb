class Event < ActiveRecord::Base
  views :starts_at, :as => CompositeDatetime.new(:start_date, :start_time)
end