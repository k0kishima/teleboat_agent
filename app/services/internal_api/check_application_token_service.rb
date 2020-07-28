module InternalApi
  class CheckApplicationTokenService
    include ServiceBase

    def call
      return true if access_token.in?(access_grants)
      raise ActionController::BadRequest
    end

    private

      attr_accessor :access_token

      def access_grants
        [Rails.application.config.x.application_token]
      end
  end
end
