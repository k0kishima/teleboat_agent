class VoteTicketsService
  extend Memoist
  include ServiceBase

  TELEBOAT_BASE_URL = 'https://mb.brtb.jp/'
  TELEBOAT_MEMBER_NUMBER = Rails.application.config.x.teleboat_member_number
  TELEBOAT_PIN = Rails.application.config.x.teleboat_pin
  TELEBOAT_AUTHORIZATION_PASSWORD = Rails.application.config.x.teleboat_authorization_password
  TELEBOAT_AUTHORIZATION_NUMBER_OF_MOBILE = Rails.application.config.x.teleboat_authorization_number_of_mobile
  # スマホ版で操作するのでUAは偽装する
  USER_AGENT = 'Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/15E148 Safari/604.1'
  IMPLICIT_WAIT_SECONDS = 5
  # 簡易投票の場合一度に12点までしか投票できない
  BATCH_VOTING_SIZE = 10

  def call
    driver.navigate.to TELEBOAT_BASE_URL
    driver.manage.timeouts.implicit_wait = IMPLICIT_WAIT_SECONDS

    # アカウント入力
    driver.find_element(:xpath, '//*[@id="pwtautLoginDiv"]/section/div[1]/div/div/div[2]/div/input').send_keys(TELEBOAT_MEMBER_NUMBER)
    driver.find_element(:xpath, '//*[@id="pwtautLoginDiv"]/section/div[1]/div/div/div[3]/div/input').send_keys(TELEBOAT_PIN)
    driver.find_element(:xpath, '//*[@id="pwtautLoginDiv"]/section/div[1]/div/div/div[4]/div/input').send_keys(TELEBOAT_AUTHORIZATION_NUMBER_OF_MOBILE)
    driver.find_element(:xpath, '//*[@id="pwtautLoginDiv"]/section/div[1]/div/div/div[6]/div/div/input').click

    simple_betting_method_numbers.each_slice(BATCH_VOTING_SIZE) do |sliced_simple_betting_method_numbers|
      # 簡易投票へ
      driver.find_element(:xpath, '/html/body/div[1]/section/div[2]/div/div[1]/ul/li[1]').click

      # 場コード入力
      driver.
          find_element(:xpath, '//*[@id="one"]/div/form/div[1]/div[1]/div/input')
          .send_keys(stadium.formal_tel_code)

      # ベット入力
      sliced_simple_betting_method_numbers.each.with_index(2) do |simple_betting_method_number, i|
        driver
            .find_element(:xpath, "//*[@id='one']/div/form/div[#{i}]/div[1]/div/input")
            .send_keys(simple_betting_method_number.to_i)
      end

      # 確認画面へ
      driver.find_element(:xpath, '//*[@id="one"]/div/form/div[14]/div').click

      # 購入金額入力
      driver
          .find_element(:xpath, "/html/body/div[1]/form/section/div[1]/div/div/div[#{sliced_simple_betting_method_numbers.count + 2}]/div/div/div[1]/div/input")
          .send_keys(sliced_simple_betting_method_numbers.map(&:quantity).sum * 100)

      # ⚠️ これ押したら投票完了
      driver.find_element(:xpath, '//*[@id="btn-vote"]').click

      # トップに戻る
      driver.find_element(:xpath, '//*[@id="footer-link1"]/a').click

      sleep(1)
    end

    driver.quit
  end

  private

    attr_accessor :stadium_tel_code, :race_number, :odds

    def stadium
      stadium = Stadium.new(tel_code: stadium_tel_code)
      raise StandardError.new('stadium_tel_code is invalid.') if stadium.invalid?
      stadium
    end
    memoize :stadium

    def simple_betting_method_numbers
      odds.map do |odds_hash|
        SimpleBettingMethodNumber.new(race_number: race_number,
                                      quantity: odds_hash.fetch(:quantity),
                                      betting_number: BettingNumber.new(number: odds_hash.fetch(:number)))
      end
    end
    memoize :simple_betting_method_numbers

    def driver
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless')
      options.add_argument('--no-sandbox')
      options.add_argument('--disable-dev-shm-usage')
      options.add_argument('--disable-gpu')
      options.add_argument("--user-agent=#{USER_AGENT}")
      Selenium::WebDriver.for :chrome, options: options
    end
    memoize :driver
end