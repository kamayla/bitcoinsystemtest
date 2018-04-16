require './method'

mymoney = 1000000.0
mybtc = 0.0

while(1)
  puts "-----------------------------------------------------------------"
  puts get_price

  buy_price = 892000.0
  sell_price = 892500.0
  current_price = get_price
  if (current_price > sell_price) && (mybtc >= 0.001)
    puts "売ります"
    mymoney += mybtc * current_price
    mybtc = 0.0
  elsif (current_price < buy_price) && (mymoney / current_price >= 0.001)
    puts "買います"
    mybtc += mymoney / current_price
    mymoney -= mybtc * current_price
  else
    puts "ステイ"
  end

  puts "JPY:#{mymoney}"
  puts "BTC:#{mybtc}"
  puts "時価総額:#{(mybtc * current_price) + mymoney}"

  sleep(1)
end