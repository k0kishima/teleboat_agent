module Api
  module V1i
    class TicketsController < ::Api::V1i::ApplicationController
      def votes
        client = Slack::Web::Client.new
        date = race_params.symbolize_keys.fetch(:date).to_date
        stadium_tel_code = race_params.symbolize_keys.fetch(:stadium_tel_code)
        race_number = race_params.symbolize_keys.fetch(:number)

        if false && date == Date.today
          VoteTicketsService.call(stadium_tel_code: stadium_tel_code, race_number: race_number, odds: odds)
        end

        text = "[Voting]\n"
        text += "* this is simulation(did not bet actually) \n" if date != Date.today
        text += "SP: https://www.boatrace.jp/owsp/sp/race/raceindex?hd=#{date.strftime('%Y%m%d')}&jcd=#{format('%02d', stadium_tel_code)}##{race_number}\n"
        text += "PC: https://boatrace.jp/owpc/pc/race/racelist?rno=#{race_number}&jcd=#{format('%02d', stadium_tel_code)}&hd=#{date.to_date.strftime('%Y%m%d')}\n"
        text += "\n"
        text += "Vote below odds \n"
        odds_params.symbolize_keys[:odds].each do |odds|
          text += "#{odds.symbolize_keys[:number]} * #{odds[:quantity]}\n"
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
