module Api
  module V1i
    class TicketsController < ::Api::V1i::ApplicationController
      def votes
        client = Slack::Web::Client.new
        date = race_params.fetch(:date).to_date
        stadium_tel_code = race_params.fetch(:stadium_tel_code)
        race_number = race_params.fetch(:number)
        odds = odds_params[:odds]

        text = "[Voting]\n"
        # TODO:
        # production 環境だったら投票を行うとかそういう制御を入れたい
        if date == Time.zone.today
          # TODO:
          # シリアルで処理する必要あるか？
          # 投票終わるまで待って投票が完了したことをレスポンスするよりは、投票処理の委譲を受け付けたかだけすぐレスポンスした方がいいのでは？
          # （投票のエラーは別途通知するとして）
          VoteTicketsService.call(stadium_tel_code: stadium_tel_code, race_number: race_number, odds: odds)
          text += "⚠️ this is not simulation. actually having betting. \n\n"
        else
          text += "ℹ️ this is simulation(did not bet actually) \n"
        end

        text += "SP: https://www.boatrace.jp/owsp/sp/race/raceindex?hd=#{date.strftime('%Y%m%d')}&jcd=#{format('%02d', stadium_tel_code)}##{race_number}\n"
        text += "PC: https://boatrace.jp/owpc/pc/race/racelist?rno=#{race_number}&jcd=#{format('%02d', stadium_tel_code)}&hd=#{date.strftime('%Y%m%d')}\n"
        text += "\n"
        text += "Vote below odds \n"
        odds.each do |odds|
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
