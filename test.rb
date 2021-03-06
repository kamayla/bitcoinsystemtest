require './method'
require './myMath'

# 資産
mymoney = 1000000.0
mybtc = 0.0

# グローバル変数
price_array = []
price_array.push(get_price)
count_max = 1
term = 5
count = 0
ave = 0.0
std = 0.0

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
  end

  # 売買条件指定
  buy_price = ave - std
  sell_price = ave

  
  # 売買アルゴリズム
  if (current_price > sell_price) && (mybtc >= 0.001)
    puts "■売り■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"
    data_print(ave,std,current_price,count_max,term)
    mymoney += mybtc * current_price
    mybtc = 0.0
  elsif (current_price < buy_price) && (mymoney / current_price >= 0.001)
    puts "■買い■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"
    data_print(ave,std,current_price,count_max,term)
    mybtc += dec_floor(mymoney / current_price, 3)
    mymoney -= mybtc * current_price
  else
    puts "■stay■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"
    data_print(ave,std,current_price,count_max,term)
  end
  puts ""
  puts "JPY:#{mymoney}"
  puts "BTC:#{mybtc}"
  puts "時価総額:#{(mybtc * current_price) + mymoney}"
  puts "■データend■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"
  
  # count_maxに達したら現在価格を配列に入れる。
  if count >= count_max
    price_array.push(current_price)
    count = 0
  end

  count += 1
  sleep(1)
end
