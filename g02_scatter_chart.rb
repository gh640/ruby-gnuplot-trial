require "gnuplot"

# 1 Gnuplot.open do |gp|
# 2 Gnuplot::Plot(gp) do |plot|
# 3 plot.data << Gnuplot::Dataset.new([x, y])

Gnuplot.open do |gp|
    Gnuplot::Plot.new( gp ) do |plot|
        # 各種オプションの設定
        # タイトル x軸ラベル y軸ラベル
        plot.title  "Array Plot Example"
        plot.xlabel "x"
        plot.ylabel "x^2"

        # 描画したいデータの生成
        x = (-50..50).collect { |v| v.to_f }
        y = x.collect { |v| v ** 2 }

        # データのプロット
        # xとyのデータを配列で渡す
        plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
            # 各種オプションの設定
            ds.with = "linespoints"
            ds.notitle
        end
    end
end


