require './method'
require './myMath'

# 資産
mymoney = 1000000.0
mybtc = 0.0

# グローバル変数
price_array = []
price_array.push(get_price)
count_max = 60
term = 5
count = 0
ave = 0.0
std = 0.0



# while(1)
#   puts "-----------------------------------------------------------------"
#   puts get_price

#   buy_price = 892000.0
#   sell_price = 892500.0
#   current_price = get_price
#   if (current_price > sell_price) && (mybtc >= 0.001)
#     puts "売ります"
#     mymoney += mybtc * current_price
#     mybtc = 0.0
#   elsif (current_price < buy_price) && (mymoney / current_price >= 0.001)
#     puts "買います"
#     mybtc += mymoney / current_price
#     mymoney -= mybtc * current_price
#   else
#     puts "ステイ"
#   end

#   puts "JPY:#{mymoney}"
#   puts "BTC:#{mybtc}"
#   puts "時価総額:#{(mybtc * current_price) + mymoney}"

#   sleep(1)
# end

while(1)
  # 現在の価格を取得
  current_price = get_price

  # 売買条件算出
  if price_array.size == term
    puts "■統計データ更新■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"
    ave = get_ave(price_array)
    std = get_std(price_array)
    puts "現在の価格：#{current_price}"
    puts "#{ count_max }秒の平均値：#{ ave }"
    puts "-1σ:#{ ave - std }"
    puts "+1σ:#{ ave + std }"
    puts "-2σ:#{ ave - (std * 2) }"
    puts "+2σ:#{ ave + (std * 2) }"
    puts "-3σ:#{ ave - (std * 3) }"
    puts "+3σ:#{ ave + (std * 3) }"
    price_array.shift()
  end

  # 売買条件指定
  buy_price = ave - std
  sell_price = ave

  
  
  if (current_price > sell_price) && (mybtc >= 0.001)
    puts "■売り■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"
    puts "現在の価格：#{current_price}"
    puts "#{ count_max }秒の平均値：#{ ave }"
    puts "-1σ:#{ ave - std }"
    puts "+1σ:#{ ave + std }"
    puts "-2σ:#{ ave - (std * 2) }"
    puts "+2σ:#{ ave + (std * 2) }"
    puts "-3σ:#{ ave - (std * 3) }"
    puts "+3σ:#{ ave + (std * 3) }"
    mymoney += mybtc * current_price
    mybtc = 0.0
  elsif (current_price < buy_price) && (mymoney / current_price >= 0.001)
    puts "■買い■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"
    puts "現在の価格：#{current_price}"
    puts "#{ count_max }秒の平均値：#{ ave }"
    puts "-1σ:#{ ave - std }"
    puts "+1σ:#{ ave + std }"
    puts "-2σ:#{ ave - (std * 2) }"
    puts "+2σ:#{ ave + (std * 2) }"
    puts "-3σ:#{ ave - (std * 3) }"
    puts "+3σ:#{ ave + (std * 3) }"
    mybtc += mymoney / current_price
    mymoney -= mybtc * current_price
  else
    puts "■stay■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"
    puts "現在の価格：#{current_price}"
    puts "#{ count_max }秒の平均値：#{ ave }"
    puts "-1σ:#{ ave - std }"
    puts "+1σ:#{ ave + std }"
    puts "-2σ:#{ ave - (std * 2) }"
    puts "+2σ:#{ ave + (std * 2) }"
    puts "-3σ:#{ ave - (std * 3) }"
    puts "+3σ:#{ ave + (std * 3) }"
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
