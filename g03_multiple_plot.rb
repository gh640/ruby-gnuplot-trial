require "gnuplot"

# 1 File.open(filename, "w") do |gp|
# 2 Gnuplot::Plot(gp) do |plot|
# 3 plot.data << Gnuplot::Dataset.new([x, y])

# File.open( "g03_gnuplot.dat", "w") do |gp|
Gnuplot.open do |gp|
    Gnuplot::Plot.new( gp ) do |plot|
        # 各種オプションの設定
        plot.xrange "[-10:10]"
        plot.title  "Sin Wave Example"
        plot.ylabel "x"
        plot.xlabel "sin(x)"

        # データの生成
        x = (0..50).collect { |v| v.to_f }
        y = x.collect { |v| v ** 2 }

        # データのプロット
        # plot.data は単なる配列 シリーズをまとめて渡すことも可
        plot.data = [
            Gnuplot::DataSet.new( "sin(x)" ) { |ds|
                ds.with = "lines"
                ds.title = "String function"
                ds.linewidth = 4
            },

            Gnuplot::DataSet.new( [x, y] ) { |ds|
                ds.with = "linespoints"
                ds.title = "Array data"
            }
        ]

    end
end
