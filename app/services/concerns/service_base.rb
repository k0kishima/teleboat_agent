module ServiceBase
  extend ActiveSupport::Concern
  included do
    class << self
      protected :new
      def call(params = {})
        new(params).call
      end
    end
  end

  def initialize(params)
    params.each do |attr, value|
      send("#{attr}=", value)
    end if params
  end

  def call
    raise NotImplementedError
  end
end
