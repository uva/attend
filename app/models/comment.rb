class Comment < ActiveRecord::Base
  belongs_to :author
  belongs_to :student

  validates :body, presence: true
end
