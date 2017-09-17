+++
categories = ["Tech"]
date = "2017-09-17 16:36:18"
tags = ["Fintech","Ruby","API"]
title = "株価チャートからトレンドラインを引く 1"

+++

以前、[Google Finance APIにより株価を取得する方法](../google_finance_api/)を書いた。
このデータからトレンドラインを引くスクリプトを作ろうと思う。

まずは、トレンドラインを引くためのポイントを選択する。

<!--more-->

## 移動平均
取得した生データだと、エッジが立ちすぎていてトレンドラインのためのポイント選択には不向きなので、
とりあえず移動平均してみた。

```ruby
require 'net/http'
require 'numo/gnuplot'

class GoogleFinance

  BASE_URL = 'https://finance.google.com/finance/getprices?'

  def initialize(issue)
    @issue = issue
  end

  # 終値を取得する
  # param [String] 期間
  # param [String] 間隔 [秒]
  def fetch_close(period = '1Y', interval_sec = 86400)
    raw_data = Net::HTTP.get(URI.parse(BASE_URL + "p=#{period}&i=#{interval_sec}&x=TYO&q=#{@issue}"))
    @close = []
    raw_data.lines do |line|
      @close << line[/^[0-9]*,([0-9]*)/, 1]
    end
    @close.compact!.map!(&:to_i)
  end

  # 移動平均を求める
  # @param [Fixnum] 期間
  # @note 終値が取得できている前提
  def calc_move_average(term)
    # 移動平均のために端のデータを引き伸ばす
    tmp = @close[0..0] * (term / 2) + @close + @close[-1..-1] * (term / 2)

    @move_average =
      tmp.each_cons(term).map do |window|
        window.inject(:+) / term.to_f
      end
  end
end

ISSUE_TOYOTA = 7203 # TOYOTAの証券コード
MOVE_AVERAGE_TERM = 10 # 移動平均の期間

google_finance = GoogleFinance.new(ISSUE_TOYOTA)
close = google_finance.fetch_close
move_average_close = google_finance.calc_move_average(MOVE_AVERAGE_TERM)

Numo.gnuplot do
  set title: 'TOYOTA'
  plot [close, w: 'lines', t: 'close'],
       [move_average_close, w: 'lines', t: 'move\_average']
end
```

こんな感じ。前回の記事からメソッド名など少し変えているので注意。

移動平均を求める方法はググったらいくらでも出てくるのであまり書かないが、
データの端の扱いだけは注意が必要。今回は端のデータを引き伸ばすことにした。
0で埋めるとか色々あるが、簡単にできて誤差が少ないのが特徴。

移動平均の期間をどう決めるかが難しいところだが、いったん10日とした。あとで調整する。

![image](http://ift.tt/2jAdPbn)


## 極値
移動平均から極値を求める。
今回は、となりの値との差分を計算して、その差分の正負が入れ替わる瞬間を極値とする。
ただ、激しく値動きしていると、極値が多くなりすぎるので、少し計算期間を長くすることでフィルタする。
例えば計算期間を5とすると、その差分が正 => 正 => 負 => 負ならば極大値、負 => 負 => 正 => 正ならば極小値。

この期間も移動平均の期間同様、どうやって決めるかが難しい。今回は7とした。

```ruby 
require 'net/http'
require 'numo/gnuplot'

class GoogleFinance
  # 省略

  # 極値を求める
  # @param [Fixnum] 期間 大きいほど微小な変動を無視する
  # @note move_averageが求まっている前提
  # @note 定めた期間の中央まで単調増加し、残りが単調減少していれば極小値とする
  # @note 定めた期間の中央まで単調減少し、残りが単調増加していれば極大値とする
  def calc_extremum(term)
    local_min = { x: [], y: [] }
    local_max = { x: [], y: [] }
    @move_average.each_cons(term).with_index do |window, i|
      mid_index = i + term / 2 # windowの中央
      diff = window.each_cons(2).map { |arr| arr[1] - arr[0] }
      if diff[0..(term / 2 - 1)].all? { |elm| elm < 0 } and
         diff[(term / 2)..-1].all? { |elm| 0 < elm }
        # 負 => 正
        local_min[:x] << mid_index
        local_min[:y] << @close[mid_index]
      elsif diff[0..(term / 2 - 1)].all? { |elm| 0 < elm } and
         diff[(term / 2)..-1].all? { |elm| elm < 0 }
        # 正 => 負
        local_max[:x] << mid_index
        local_max[:y] << @close[mid_index]
      end
    end
    return local_min, local_max
  end
end

ISSUE_TOYOTA = 7203 # TOYOTAの証券コード
MOVE_AVERAGE_TERM = 10 # 移動平均の期間
LOCAL_SIZE = 7 # 極値計算の範囲

google_finance = GoogleFinance.new(ISSUE_TOYOTA)
close = google_finance.fetch_close
move_average_close = google_finance.calc_move_average(MOVE_AVERAGE_TERM)
local_min, local_max = google_finance.calc_extremum(LOCAL_SIZE)

Numo.gnuplot do
  set title: 'TOYOTA'
  plot [close, w: 'lines', t: 'close'],
       [move_average_close, w: 'lines', t: 'move\_average'],
       [local_min[:x], local_min[:y], w: 'points', t: 'local\_min'],
       [local_max[:x], local_max[:y], w: 'points', t: 'local\_max']
end
```

GoogleFinanceクラスはcalc_extremumメソッド以外は変わっていないので省略した。

![image](http://ift.tt/2wy0emn)

少し見にくいが、緑点が極小値、紫点が極大値。それなりにいい具合の場所を選んでいるように思える。
実際に線を引くのは次回。
