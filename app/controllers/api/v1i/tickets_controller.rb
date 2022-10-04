module Api
  module V1i
    class TicketsController < ::Api::V1i::ApplicationController
      def votes
        # NOTE
        # 日付は規約で本日が適用される
        # 基本的には本日開催のレースにしか投票できないため
        # SGやPG1は前日発売されているが展示を見ないで買うことは少なくともこのプロダクトではないためそのケースは考慮しない
        stadium_tel_code = race_params.fetch(:stadium_tel_code)
        race_number = race_params.fetch(:number)
        odds = odds_params[:odds]

        VoteTicketsService.call(stadium_tel_code: stadium_tel_code, race_number: race_number, odds: odds)

        render json: { success: true }
      end

      private

        def race_params
          params
            .fetch(:race, {})
            .permit(:number, :stadium_tel_code)
        end

        def odds_params
          params.permit(odds: [:number, :quantity])
        end
    end
  end
end
