# NOTE:
#
# 旧モバイル投票の簡易投票用のフォーマット
# 下記URL参照
# https://mb.brtb.jp/tohyo-ap-smtohyo/PWTCOM/pwtcomhelp_sm.jsp?rand=Pz5dtOkLFTtrNK9iajIX&screenId=pwtbetsimple_sm&r=5254809834661202391&cid=apA24&token=Sa11JSyyyP4YNP7KVecBO1lSeqjJGTg3
#
# YAGNIに則って三連単のみ対応
class SimpleBettingMethodNumber
  TRIFECTA_SIMPLE_BET_CODE = 31

  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :race_number, :integer
  attribute :quantity, :integer

  attr_accessor :betting_number

  validates :race_number, presence: true, inclusion: { in: 1..12 }
  validates :quantity, presence: true, inclusion: { in: 1..999 }

  def to_i
    raise StandardError.new("invalid number given.") if invalid?
    [
      format('%02d', race_number),
      TRIFECTA_SIMPLE_BET_CODE,
      betting_number.to_i,
      format('%03d', quantity)
    ].map(&:to_s).join
  end
end