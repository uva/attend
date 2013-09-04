class Record < ActiveRecord::Base
  belongs_to :student

  def week
    start_time.strftime('%W')
  end
end
