require 'net/http'
require 'uri'
require 'json'
require './key'
require "openssl"
require 'bigdecimal'
require 'bigdecimal/util'



def get_price
  uri = URI.parse("https://api.bitflyer.jp")
  uri.path = '/v1/getboard'
  uri.query = 'BTC/JPY'
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  response = https.get uri.request_uri
  response_hash = JSON.parse(response.body)
  response_hash["mid_price"]
end


def order(price,size,side)
  key = API_KEY
  secret = API_SECRET
  timestamp = Time.now.to_i.to_s
  method = "POST"
  uri = URI.parse("https://api.bitflyer.jp")
  uri.path = "/v1/me/sendchildorder"
  body = '{
    "product_code": "BTC_JPY",
    "child_order_type": "LIMIT",
    "side": "' + side + '",
    "price":' + price + ',
    "size":' + size + ',
    "minute_to_expire": 1,
    "time_in_force": "GTC"
  }'
  text = timestamp + method + uri.request_uri + body
  sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)
  options = Net::HTTP::Post.new(uri.request_uri, initheader = {
  "ACCESS-KEY" => key,
  "ACCESS-TIMESTAMP" => timestamp,
  "ACCESS-SIGN" => sign,
  "Content-Type" => "application/json"
  });
  options.body = body
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  response = https.request(options)
  puts response.body
end

def get_balance(coin_name)
  key = API_KEY
  secret = API_SECRET
  timestamp = Time.now.to_i.to_s
  method = "GET"
  uri = URI.parse("https://api.bitflyer.jp")
  uri.path = "/v1/me/getbalance"

  text = timestamp + method + uri.request_uri
  sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)
  options = Net::HTTP::Get.new(uri.request_uri, initheader = {
  "ACCESS-KEY" => key,
  "ACCESS-TIMESTAMP" => timestamp,
  "ACCESS-SIGN" => sign,
  });
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  response = https.request(options)
  response_hash = JSON.parse(response.body)
  response_hash.find {|n| n["currency_code"] == coin_name}
end


def ifdoneOCO
  key = API_KEY
  secret = API_SECRET
  timestamp = Time.now.to_i.to_s
  method = "POST"
  uri = URI.parse("https://api.bitflyer.jp")
  uri.path = "/v1/me/sendparentorder"
  body = '{
  "order_method": "IFDOCO",
  "minute_to_expire": 10000,
  "time_in_force": "GTC",
  "parameters": [{
    "product_code": "BTC_JPY",
    "condition_type": "LIMIT",
    "side": "BUY",
    "price": 890000,
    "size": 000.1
  },
  {
    "product_code": "BTC_JPY",
    "condition_type": "LIMIT",
    "side": "SELL",
    "price": 900000,
    "size": 000.1
  },
  {
    "product_code": "BTC_JPY",
    "condition_type": "STOP_LIMIT",
    "side": "SELL",
    "price": 28800,
    "trigger_price": 885000,
    "size": 000.1
  }]
}'
  text = timestamp + method + uri.request_uri + body
  sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)
  options = Net::HTTP::Post.new(uri.request_uri, initheader = {
  "ACCESS-KEY" => key,
  "ACCESS-TIMESTAMP" => timestamp,
  "ACCESS-SIGN" => sign,
  "Content-Type" => "application/json"
  });
  options.body = body
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  response = https.request(options)
  puts response.body
end

def data_print(ave,std,current_price,count_max,term)
    puts "現在の価格：#{current_price}"
    puts "#{ (count_max * term) / 60 }分の平均値：#{ ave }"
    puts "+3σ:#{ ave + (std * 3) }"
    puts "+2σ:#{ ave + (std * 2) }"
    puts "+1σ:#{ ave + std }"
    puts "-1σ:#{ ave - std }"
    puts "-2σ:#{ ave - (std * 2) }"
    puts "-3σ:#{ ave - (std * 3) }"
end

def dec_floor(num, n)
  BigDecimal.new(num.to_s).floor(n).to_f
end

def getget
  key = API_KEY
  secret = API_SECRET
  timestamp = Time.now.to_i.to_s
  method = "GET"
  uri = URI.parse("https://api.bitflyer.jp")
  uri.path = "/v1/me/getchildorders"
  body = '{
    "child_order_state": "COMPLETED",
    "side": "BUY"
  }'

  text = timestamp + method + uri.request_uri
  sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)
  options = Net::HTTP::Get.new(uri.request_uri, initheader = {
  "ACCESS-KEY" => key,
  "ACCESS-TIMESTAMP" => timestamp,
  "ACCESS-SIGN" => sign,
  });
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  response = https.request(options)
  response_hash = JSON.parse(response.body)
  response_hash = response_hash.find_all {|n| n["side"] == "BUY"}
  array = []
  for num in 0...1 do
    array.push(response_hash[num])
  end
  array
end




def get_target
  money = getget.reduce(0.0){|sum,n| sum += n["price"] * n["size"]}
  quantity = getget.reduce(0.0){|sum,n| sum += n["size"]}
  money / quantity
end

