class NotifyVotingService
  extend Memoist
  include ServiceBase

  def call
    # TODO:
    # メール送信のテンプレートみたいに文言を持ちたい（ここにベタ書きをしたくない）
    text = "😎 Voting information\n"
    # TODO:
    # proxyのURLに変える
    text += "SP: https://www.boatrace.jp/owsp/sp/race/raceindex?hd=#{date.strftime('%Y%m%d')}&jcd=#{format('%02d', stadium_tel_code)}##{race_number}\n"
    text += "PC: https://boatrace.jp/owpc/pc/race/racelist?rno=#{race_number}&jcd=#{format('%02d', stadium_tel_code)}&hd=#{date.strftime('%Y%m%d')}\n"
    text += "\n"
    text += "Vote below odds \n"
    odds.each do |odds|
      text += "#{odds[:number]} * #{odds[:quantity]}\n"
    end
    # TODO: チャンネル名は定数で持つ
    response = slack_client.chat_postMessage(channel: '#777_betting', text: text)
    unless response.ok
      raise StandardError.new('Failed to post slack message.')
    end
  end

  private

    attr_accessor :stadium_tel_code, :race_number, :odds

    def slack_client
      Slack::Web::Client.new
    end
    memoize :slack_client

    def date
      Time.zone.today
    end
    memoize :date
end
