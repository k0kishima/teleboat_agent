class Stadium
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :tel_code, :integer

  validates :tel_code, presence: true, inclusion: { in: 1..24 }

  # NOTE:
  # string であることを明示した名前の方がいいのか？formal_tel_code_string とか
  def formal_tel_code
    format('%02d', tel_code)
  end
end