require 'gnuplot'
require 'csv'


# csvファイルからxデータ/yデータを読み込むメソッド
# @param
# filename csvファイル名 2列 1列目x 2列目y
# @return
# [xs, ys] xデータとyデータを格納した配列
def load_xy_from_csv(filename)
  xs, ys = [], []
  CSV.open(filename, "r") do |csv|
    csv.each do |x, y|
      xs << x.to_f
      ys << y.to_f
    end
  end
  [xs, ys]
end


# Gnuplotで散布データを表示するメソッド
# @param
# xs xデータを格納した配列
# ys yデータを格納した配列
# title 系列のタイトル 凡例に使われる
# @return
# nil
def plot_scatter_chart(xs, ys, title="default title")
  Gnuplot.open do |gp|
    Gnuplot::Plot.new(gp) do |plot|
      plot.data << Gnuplot::DataSet.new([xs, ys]) { |ds|
        ds.title = title
      }
    end
  end
  nil
end


# メイン関数
# csv ファイルからデータを取得して gnuplotで散布図として表示する
if __FILE__ == $0
  xs, ys = load_xy_from_csv("g04_dat.csv")
  p xs, ys
  plot_scatter_chart(xs, ys, "row data")
end
