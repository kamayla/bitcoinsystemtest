require './method'


while(1)
  puts get_price

  buy_price = 892500.0
  sell_price = 900000.0

  if (get_price > sell_price) && (get_balance('BTC')["amount"] >= 0.001)
    puts "売ります"
    order(get_price,0.001,'SELL')
  elsif (get_price < buy_price) && (get_balance('JPY')["amount"] >=  get_price * 0.001)
    puts "買います"
    order(get_price,0.001,'BUY')
  else
    puts "ステイ"
  end

  sleep(1)
end

# puts get_balance('JPY')["amount"]
# puts get_balance('BTC')["amount"]
# puts get_price * 0.001