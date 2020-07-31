module Api
  module V1i
    class TicketsController < ::Api::V1i::ApplicationController
      def votes
        render json: { success: true }
      end
    end
  end
end
