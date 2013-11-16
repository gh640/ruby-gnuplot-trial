require 'gnuplot'
require 'csv'
require 'matrix'  # Vector を使うために require しておく


# CSVファイルからxデータ/yデータを読み込むメソッド
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
def plot_scatter_and_line_chart(xs, ys, fit_curve_xs, fit_curve_ys)
  Gnuplot.open do |gp|
    Gnuplot::Plot.new(gp) do |plot|
      plot.data = [
        Gnuplot::DataSet.new([xs, ys]) { |ds|
          ds.title = "row data"
        },
        Gnuplot::DataSet.new([fit_curve_xs, fit_curve_ys]) { |ds|
          ds.title = "fit curve"
          ds.with = "lines"
          ds.linewidth = 5
        }
      ]
    end
  end
  nil
end


# 最小2乗法で近似曲線の係数（直線なので傾きと切片）を求めるメソッド
# グラディエントディセントで theta を更新する
# 最大繰り返し回数は max_iter 回
# @param
# xs  Xデータを格納した配列
# ys  Yデータ
# alpha
# theta
# max_iter
# @retrun
# theta
def get_fit_curve(xs, ys, alpha=0.01, theta=[0, 0], max_iter=500)
  theta_next = []
  gap = [0, 0]
  m = xs.size

  max_iter.times do
    # グラディエントディセントで更新した theta を求める
    gap[0] = xs.zip(ys).map{ |x, y| get_gap(x, theta, y) }.sum
    gap[1] = xs.zip(ys).map{ |x, y| get_gap(x, theta, y) * x }.sum
    theta_next = (Vector[*theta] - Vector[*gap] * alpha / m).to_a

    # 更新しても値がそれほど変わらないようであればループを抜ける
    break if (Vector[*theta_next] - Vector[*theta]).abs < 0.01

    theta = theta_next
  end

  # 最終的に求まったthetaを返す
  theta
end


# 予測される y_i = theta[0] + theta[1] * x_i を計算するメソッド
def get_expected_y(x, theta)
  theta[0] + theta[1] * x
end


# 予実ギャップ x_i' * theta - y_i を計算するメソッド
def get_gap(x, theta, y)
  get_expected_y(x, theta) - y
end


# Array にメソッド追加
class Array
  # 要素の総和を求めるメソッド
  def sum
    self.inject(:+)
  end
end


# Vector にメソッド追加
class Vector
  # ベクトルの長さを求めるメソッド
  def abs
    Math.sqrt(inner_product(self))
  end
end


def get_endpoint_of_fit_curve(xs, theta)
  fit_curve_xs = xs.minmax
  fit_curve_ys = fit_curve_xs.map { |x| get_expected_y(x, theta) }

  [fit_curve_xs, fit_curve_ys]
end


# メイン関数
if __FILE__ == $0
  # データをCSVファイルから読み込み
  xs, ys = load_xy_from_csv("g05_dat.csv")
  puts "x and y: "
  p xs, ys

  # フィットカーブの計算
  theta = get_fit_curve(xs, ys)
  puts "theta: "
  p theta

  # 元データとフィットカーブをあわせてプロット
  fit_curve_xs, fit_curve_ys = get_endpoint_of_fit_curve(xs, theta)
  plot_scatter_and_line_chart(xs, ys, fit_curve_xs, fit_curve_ys)
end
