module Api
  module V1i
    class ApplicationController < ActionController::API
      before_action :authenticate_application!

      rescue_from ActiveRecord::RecordNotFound do |e|
        render status: 404, json: { errors: [{ message: e.message }] }
      end

      rescue_from ActiveRecord::RecordInvalid  do |e|
        render status: 400, json: { errors: e.record&.errors }
      end

      rescue_from ::DataExceptions::DataFixed, DataExceptions::DataFetching do |e|
        render status: 400, json: { errors: e.message }
      end

      rescue_from ActionController::BadRequest do |e|
        render status: 400, json: { errors: [{ message: e.message }] }
      end

      private

        def authenticate_application!
          InternalApi::CheckApplicationTokenService.call(access_token: params[:access_token])
        end
    end
  end
end
