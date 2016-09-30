Assist.setup do |config|
  config.login = "login"
  config.password = "password"
  config.mode = :test
  config.merchant_id = "111111"
  config.secret_word = "secret"
  config.success_url = "http://localhost:3000/payments/success"
  config.fail_url = "http://localhost:3000/payments/fail"
  config.payment_methods = {card: true, ym: true, wm: false, qiwi: {mts: true}}
end