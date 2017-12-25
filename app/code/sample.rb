line_1 = gets
my_card = line_1.split(" ").map(&:to_i)

if my_card[0] == 0 then
  puts "1" # 賭けチップ数

else
  if my_card.inject(:+) < 10 then # ★カードを引く条件の合計値を変えてみよう！★
    puts "HIT" # カード引く
  else
    puts "STAND" # 勝負
  end
end