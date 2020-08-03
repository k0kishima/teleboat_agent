# NOTE:
#
# 賭ける艇番のこと
# YAGNIに則って三連単のみ対応
class BettingNumber
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :number, :integer

  validates :number, presence: true, format: { with: /\A[1-6]{3}\z/ }
  validate :number_cannot_duplicate

  def to_i
    raise StandardError.new("#{number} is invalid number.") if invalid?
    number
  end

  private

  def number_cannot_duplicate
    if number.to_s.split('').uniq.count != number.to_s.length
      errors.add(:number, 'number duplicated.')
    end
  end
end