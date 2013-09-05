class Record < ActiveRecord::Base
  belongs_to :student

  def week
    start_time.strftime('%W')
  end

  def duration
    end_time - start_time
  end
end
