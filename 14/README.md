# 今週のテーマ
ライブラリを最適化する

# 方針
最適化の具体的な方法がどういったものなのか知りたい。  
Rubyではどのようにやるのが、一般的なのか。  

## 14.1 最適化の必要がなさそうなコードを把握する
> 「単純だけど遅くなる気がする」方式を見送って「速くなる気がするけど複雑になる」方式を採用してはいけません。

早そう、でも複雑よりは遅いかもしれないけど単純でメンテナンスがしやすいコードを心がける。  
必要に迫られるまで実行性能については気にしない。


## 14.2 プロファイリングが先、最適化は後

流れとしては
- プロファイリング（監視）をして、どこで時間が使われているのかを確認  
  ruby-prof を使ってどのメソッドが遅いのかを監視
- ベンチマーク（指標）を取る  
  最適化する前と後での比較用、Benchmarkモジュールやbenchmark-ipsを使う
- 最適化する
- ベンチマークと比較して性能が向上しているか確かめる

自分がRailsでやるなら
- 遅いという連絡が入る
- 遅い箇所のログを確認し、どこで時間がかかっているか確認
- 該当箇所のコードを読んで、最適化する
- 実行してみて早くなっているか確認する

というやり方。  
この書籍でやるようなやり方は踏んでいない。  
ただ、ログにすべて出てるわけではないので、この章で使われていたgemを使うと場所の特定はしやすくなるかもしれない。

Ruby でライブラリのプロファイリングに使える代表的な gem は 

- ruby-prof 
- stackprof

他にも

- rack-mini-profiler
- rbspy

がある

> 「このプロファイルでは MultiplyProf の integer、float、rational メ ソッドのうちどれが最速かがわかる」と思い込んでいませんでしたか?

完全にそう思っていた。  
サンプルで示されたコードをみたとき、integer、float、rationalのどれが遅いのかを計測して、どれに対して最適化を行うのか決めるのだろうと思った。  
メソッド呼び出しだけが遅いわけじゃない。  
全体に対して計測して結果を見るまでわからない。  

### ruby-prof
メソッドごとにどれくらいの時間がかかっているかを計測可能
実際にやってみた
```text
 %self      total      self      wait     child     calls  name                           location
 24.95      0.012     0.003     0.000     0.009        1   Integer#times                  
 19.89      0.004     0.002     0.000     0.001     3000   Array#map                      
 13.14      0.005     0.002     0.000     0.004     1000   MultiplyProf#initialize        ruby_prof_sample.rb:2
  5.69      0.001     0.001     0.000     0.001     1000   MultiplyProf#rational          ruby_prof_sample.rb:16
  5.49      0.001     0.001     0.000     0.000     1000   MultiplyProf#integer           ruby_prof_sample.rb:8
  5.43      0.001     0.001     0.000     0.000     1000   MultiplyProf#float             ruby_prof_sample.rb:12
  4.96      0.006     0.001     0.000     0.005     1000   Class#new                      
  4.92      0.001     0.001     0.000     0.000     1000   Rational#*                     
  4.25      0.000     0.000     0.000     0.000     2000   Rational#to_f                  
  3.64      0.000     0.000     0.000     0.000     2000   Rational#to_i                  
  3.28      0.000     0.000     0.000     0.000     2000   Rational#to_r                  
  2.20      0.000     0.000     0.000     0.000     1000   Float#*                        
  2.10      0.000     0.000     0.000     0.000     1000   Integer#*                      
  0.08      0.012     0.000     0.000     0.012        1   [global]#                      ruby_prof_sample.rb:24
```


### Benchmarkモジュール
ベンチマーク（指標）に使える。  
きちんとしたベンチマークを計測するには5秒間は繰り返すのが理想とのこと。
一回じゃダメ？とも思ったが、キャッシュしてるパターンとかもありそうだし、5秒間くらいは繰り返して呼ばないとベンチマークとして使えないということか。

以降は、実際に最適化させる話が続くので、割愛

## 14.3 存在しないコードより速いコードは存在しない

そりゃそうだ。  
と思ったが、書いてあることは何回呼んでも結果が変わらないのなら、インスタンス変数に入れておくとか、そういうテクニックの紹介  
みたいになってた。

## 14.4 何もかもが遅い場合の対処法
大量のオブジェクト生成が行われていないか。  
減らすべき箇所を見つけるのに memory_profiler gem を使える。  

こんな書き方初めて見た。
fooの引数を指定しない場合は:barが返るようになっている。

```rb
def foo(bar=(return :bar; nil))
  :foo
end
```