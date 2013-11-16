require "gnuplot"

# 1 Gnuplot.open do |gp|
# 2 Gnuplot::Plot(gp) do |plot|
# 3 plot.data << Gnuplot::Dataset.new("function")

Gnuplot.open do |gp|
    Gnuplot::Plot.new( gp ) do |plot|
        # 関数の設定
        equation = "sin(x)"

        # 各種オプションの設定
        plot.xrange "[-10:10]"
        plot.title  "Sin Wave Example"
        plot.ylabel "x"
        plot.xlabel equation

        # データのプロット
        plot.data << Gnuplot::DataSet.new( equation ) do |ds|
            # 各種オプションの設定
            ds.with = "lines"
            ds.linewidth = 4
        end
    end
end
