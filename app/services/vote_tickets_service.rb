class VoteTicketsService
  TELEBOAT_BASE_URL = 'https://spweb.brtb.jp/'
  TELEBOAT_MEMBER_NUMBER = Rails.application.config.x.teleboat_member_number
  TELEBOAT_PIN = Rails.application.config.x.teleboat_pin
  TELEBOAT_AUTHORIZATION_PASSWORD = Rails.application.config.x.teleboat_authorization_password
  TELEBOAT_AUTHORIZATION_NUMBER_OF_MOBILE = Rails.application.config.x.teleboat_authorization_number_of_mobile
  # スマホ版で操作するのでUAは偽装する
  USER_AGENT = 'Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/15E148 Safari/604.1'
  IMPLICIT_WAIT_SECONDS = 3

  include ServiceBase

  def call
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument("--user-agent=#{USER_AGENT}")

    driver = Selenium::WebDriver.for :chrome, options: options

    driver.navigate.to TELEBOAT_BASE_URL
    driver.manage.timeouts.implicit_wait = IMPLICIT_WAIT_SECONDS
    driver.find_element(:xpath, '//*[@id="root"]/div/div/div[2]/ul/li').click
    driver.find_element(:xpath, '//*[@id="root"]/div/div/div[2]/table/tbody/tr[1]/td/input').send_keys(TELEBOAT_MEMBER_NUMBER)
    driver.find_element(:xpath, '//*[@id="root"]/div/div/div[2]/table/tbody/tr[2]/td/input').send_keys(TELEBOAT_PIN)
    driver.find_element(:xpath, '//*[@id="root"]/div/div/div[2]/table/tbody/tr[3]/td/input').send_keys(TELEBOAT_AUTHORIZATION_NUMBER_OF_MOBILE)
    driver.find_element(:xpath, '//*[@id="root"]/div/div/div[2]/ul/li').click
    driver.quit
  end

  private

    attr_accessor :stadium_tel_code, :race_opened_on, :number, :odds
end