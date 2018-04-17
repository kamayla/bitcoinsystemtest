require './method'
require './myMath'

# グローバル変数
price_array = []
price_array.push(get_price)
count_max = 60
term = 20
count = 0
ave = 0.0
std = 0.0
trade_flag = false
leave = term * count_max

while(1)
  # 現在の価格を取得
  current_price = get_price

  # 売買条件算出
  if price_array.size == term
    puts "■統計データ更新■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"
    ave = get_ave(price_array)
    std = get_std(price_array)
    data_print(ave,std,current_price,count_max,term)
    price_array.shift()
    trade_flag = true
  end

  # 売買条件指定
  buy_price = ave - ( std * 3 )
  sell_height_price = get_target * 1.10
  sell_low_price = get_target * 0.95

  puts "売り抜けポイント:#{sell_height_price}"
  puts "損切りポイント:#{sell_low_price}"

  if trade_flag
    # 売買アルゴリズム
    myjpy = get_balance('JPY')["available"]
    mybtc = get_balance('BTC')["available"]
    if ((current_price >= sell_height_price) && (mybtc * 0.9985 >= 0.001) && (sell_height_price != 0.0)) || ((current_price <= sell_low_price) && (mybtc * 0.9985 >= 0.001) && (sell_height_price != 0.0))
      puts "■売り■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"
      data_print(ave,std,current_price,count_max,term)
      # 売り注文を出す
      puts "#{current_price}円で売却指示"
      order(current_price.to_s ,dec_floor(mybtc * 0.9985, 3).to_s ,'SELL')
    elsif (current_price < buy_price) && ( (myjpy / current_price) * 0.9985 >= 0.001)
      puts "■買い■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"
      data_print(ave,std,current_price,count_max,term)
      # 買い注文を出す
      puts "#{current_price}円で購入指示"
      order(current_price.to_s, dec_floor( (myjpy / current_price) * 0.9985, 3).to_s,'BUY')
    else
      puts "■stay■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"
      data_print(ave,std,current_price,count_max,term)
    end
    puts ""
    puts "JPY:#{get_balance('JPY')["amount"]}"
    puts "BTC:#{get_balance('BTC')["amount"]}"
    puts "時価総額:#{(get_balance('BTC')["amount"] * current_price) + get_balance('JPY')["amount"]}"
    puts "■データend■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"
    
  else
    puts "Now Loading..."
    p price_array
    puts "#{leave}"
    leave -= 1
  end
  
  
  # count_maxに達したら現在価格を配列に入れる。
  if count >= count_max
    price_array.push(current_price)
    count = 0
  end

  count += 1
  sleep(1)
end