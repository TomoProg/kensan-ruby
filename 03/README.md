# 今週のテーマ
変数を適切に使う

# 読んで理解したこと
## 3.1 ローカル変数:Ruby で大活躍の変数
ローカル変数を使うことで実行性能の向上につながるようなことが書いてある。  

何度も呼び出さずにローカル変数にキャッシュしてそれを使いまわせばいいということ。

スコープゲートや命名についても記載がある。

- attr_readerによるアクセスを何回も行わず、一度ローカル変数にキャッシュしてそれを使う

ここまでパフォーマンス必要なときはほぼないのでは？

- procはクロージャなので、ブロックの外側の変数をブロック内に閉じ込められる

ブロック内で何度もメソッドを呼ぶのではなく、ブロックの外でローカル変数にキャッシュしておく
```rb
class Sample
  def to_proc
    # こう書いてしまうと重い処理が毎回呼ばれてしまう
    #proc {|v| v + heavy_method }

    # こう書けば一回だけ重い処理が呼ばれるため、早く済む
    a = heavy_method
    proc {|v| v + a }
  end

  def heavy_method
    # 重い処理
    sleep 3
    10
  end
end

p [1, 2, 3].map(&Sample.new) #=> [11, 12, 13]

```

- 定数をローカル変数に受け取ることでわずかに計算量があがる

考えたことなかった。認知負荷が増えるので、ほぼ使わないと思う

- スコープゲートについて

def、class、moduleキーワードのたびにスコープが変わる（スコープゲート）

define_method、Class.new、Module.newはスコープゲートを作らない

- 命名について

ローカル変数命名の一般原則は、「変数名の長さを、その変数のスコープの広さに比例させる」というものです。 

なるほどと感じた。スコープが小さければ短い変数名でも理解に苦しまないけど、長いと苦しむ


## 3.2 インスタンス変数を活用する
ざっと流し読み

インスタンス変数でキャッシュしておくような話はわかったが、それ以外はなんかピンとこなかった。

## 3.3 定数も単なる変数である
private_constantで定数を隠すことができるのは知らなかった。

## 3.4 クラス変数を置き換える
TODO

# 試したこと、コードサンプル
特になし

# 疑問、質問