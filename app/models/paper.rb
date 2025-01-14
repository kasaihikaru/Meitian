class Paper < ApplicationRecord
  belongs_to :user
  has_many :sentences

  scope :active, -> { where(deleted_at: nil) }
  scope :recent, -> { order(modified_at: :desc).limit(4) }
  scope :order_mofified_at, -> { order(modified_at: :desc) }
  scope :not_sapmle, -> { where(sample: false) }
  scope :not_copied, -> { where(original_id: nil) }
  scope :not_mine, -> user_id { where.not(user_id: user_id) }
  # scope :not_zero, -> { all if joins(:sentences).count > 0 }

  enum status: { waiting: 0, working: 10, review_needed: 20, completed:30 }
end