# 標準偏差を求める関数
def get_std(array)
  # 平均
  ave = get_ave(array)

  # 分散
  dispersion = array.reduce(0.0){ |d , num| d += ( num - ave) ** 2 } / array.size

  # 標準偏差
  Math.sqrt(dispersion)
end

#平均を求める関数
def get_ave(array)
  # 平均
  ave = array.reduce(:+) / array.size
end









