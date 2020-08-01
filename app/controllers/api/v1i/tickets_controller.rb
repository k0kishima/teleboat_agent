module Api
  module V1i
    class TicketsController < ::Api::V1i::ApplicationController
      def votes
        client = Slack::Web::Client.new

        text = "[Voting]\n"
        text += "SP: https://www.boatrace.jp/owsp/sp/race/raceindex?hd=#{race_params[:date].to_date.strftime('%Y%m%d')}&jcd=#{format('%02d', race_params[:stadium_tel_code])}##{race_params[:number]}\n"
        text += "PC: https://boatrace.jp/owpc/pc/race/racelist?rno=#{race_params[:number]}&jcd=#{format('%02d', race_params[:stadium_tel_code])}&hd=#{race_params[:date].to_date.strftime('%Y%m%d')}\n"
        text += "\n"
        text += "Vote below odds \n"
        odds_params[:odds].each do |odds|
          text += "#{odds[:number]} * #{odds[:quantity]}\n"
        end
        text += "\n"

        response = client.chat_postMessage(channel: '#voting', text: text)
        unless response.ok
          raise StandardError.new('Failed to post slack message.')
        end
        render json: { success: true }
      end

      private

        def race_params
          params
            .fetch(:race, {})
            .permit(:date, :number, :stadium_tel_code)
        end

        def odds_params
          params.permit(odds: [:number, :quantity])
        end
    end
  end
end
