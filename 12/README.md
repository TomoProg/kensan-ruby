# 今週のテーマ
変更に対処する

# 方針
リファクタリングを実際にどうやってやるのかを知りたい。
具体例がある箇所については実際にやってみることで、理解を深めていく

## 12.1 リファクタリングする理由
- ライブラリをシンプルにするため。
  - 2つ以上の場所に対して、同じ理由で同じ変更を加えている
  - 全く使われない抽象化されたコードをインラインにする（メソッドを削除して、呼び出し元でそのまま書く）
- 実行性能の改善
- ライブラリへの拡張ポイントを追加する

シンプルというのを具体的にどういうことかが書いてあったのは助かった。
ライブラリへの拡張ポイントを追加するというのは、いまいちピンとこない。具体的な例がほしいところ。
→
クラス継承ようにメソッドを用意するなど。テンプレートメソッドパターン

## 12.2 リファクタリングの進め方
### 重要なポイント
- リファクタリングに取り掛かる前にリファクタリング中に混入するバグを検知できる程度のテストを書いておくこと
- コツは1箇所ずつテストしていくこと
  - 必要な箇所は全部修正してから全部のテストを流すというプロセスが直感的ではあるが、これだとどこでエラーが起きているのか突き止めるのに時間がかかる
  - 自分も直感的にそのようにやっている。確かにFAILを探す手間はあるけど、検索すればすぐ見つかるし、そんなに手間だと感じてはいない
- 本当にこのリファクタリングが必要なのか？と問いかけること
  - 単に気に入らないという理由からやってはいけない。
  - 理由が明確に説明できることが重要。

ついつい気になって、もっとこうしたら良いんじゃないかなーと考えがち。
プログラマーなのだからそこは仕方がない。
ただ、今それをやるべきかを考える方がもっと重要。

## 12.3 よく使われる Ruby のリファクタリング技法
### メソッド抽出
- 抽出したメソッドにどんな処理をさせたいのか
- 同じことを繰り返している処理がすべて抽出され、かつ簡単に使える

例では`checkout`する箇所と`execute`する箇所が同じことを繰り返しているため、それらを抽出している。

### クラスの抽出
Addressクラスに抽出したことで以下の恩恵を得られた
- コンストラクタ引数が少なくなり、コードが読みやすくなった（可読性向上）
- format_labelメソッドに応答するオブジェクトを外から渡せるため、別のAddressクラスを使うことで、表記を変更可能になった（拡張できるようになった）
- 住所表記を変更したい場合に1箇所で済むようになった(DRY)

こういう恩恵が得られるのであれば、クラス抽出する価値がある


## 12.4 機能追加のためのリファクタリング
リファクタリングのアプローチ方法
- カウボーイアプローチ
  - 新しい機能を実装し始めてから、機能を開発している間に必要なところだけ、既存のアプリケーションをリファクタリングする。
  - つまり、機能実装と同時にリファクタリングもやる
  - リファクタリングは中途半端になりがち
  - うまく行けば時間的には効率的
  - うまく行かない（テストが失敗する）場合は、リファクタリングが原因なのか、新機能が原因なのか切り分けが困難。
  - それによりデバッグ時間が増える

- 系統的アプローチ
  - リファクタリングフェーズと新機能の実装フェーズを分ける
  - リファクタリングは完全なものとなる
  - カウボーイアプローチでうまく行った場合よりは時間がかかる
  - しかし、うまく行かなかった（テストが失敗した）場合はリファクタリングが原因なのか新機能が原因なのか切り分けが容易
  - そのため、デバッグ時間が比較的短くすむ



## 12.5 機能を適切に削除する
ライブラリメンテナにとっては機能を削除する = 負債を減らすということ
しかし、ユーザとしてはコードが壊れるため、負担となる。

負担をなるべく軽減するために、非推奨を使う

warnメソッドを使う  
https://docs.ruby-lang.org/ja/latest/method/Kernel/m/warn.html  

- uplevelオプション
  - いくつ前の呼び出し元のファイル名と行番号を表示するかを決める。
  - 0の場合はwarnメソッドを呼び出したファイル名とその行番号になる

- categoryオプション
  - `:deprecated` もしくは `:experimental` を指定可能
  - 非推奨の場合は `:deprecated`
  - 実験的な機能の場合は `:experimental`
  - Warning.[]で出力するかどうかを決めている。
    - `Warning[:deprecated]` もしくは `Warning[:experimental]` がbool値を返す。

- vオプションを使って実行することで、`Warning[:deprecated]` が trueに設定されるようだ

### サンプルコード
```ruby:main.rb
require_relative './lib'
puts "Warning[:deprecated]: #{Warning[:deprecated]}"
Sample.deprecated_method

puts "-----------------------------"

puts "Warning[:experimental]: #{Warning[:experimental]}"
Sample.experimental_method

```

```ruby:lib.rb
class Sample
  def self.deprecated_method
    warn("#{__callee__} is deprecated", uplevel: 0, category: :deprecated)
    puts "Hello, deprecated method!"
  end

  def self.experimental_method
    warn("#{__callee__} is experimental", uplevel: 1, category: :experimental)
    puts "Hello, experimental method!"
  end
end
```

### 実行結果
- vオプションなし
```
$ ruby 12/app/warn_sample/main.rb
```

```
Warning[:deprecated]: false
Hello, deprecated method!
-----------------------------
Warning[:experimental]: true
12/app/warn_sample/main.rb:8: warning: experimental_method is experimental
Hello, experimental method!
```

- vオプションあり
```
$ ruby -v 12/app/warn_sample/main.rb
```

```
ruby 3.2.1 (2023-02-08 revision 31819e82c8) [x86_64-darwin21]
Warning[:deprecated]: true
/Users/tomoprog/neogenia/repos/kensan-ruby/12/app/warn_sample/lib.rb:3: warning: deprecated_method is deprecated
Hello, deprecated method!
-----------------------------
Warning[:experimental]: true
12/app/warn_sample/main.rb:8: warning: experimental_method is experimental
Hello, experimental method!
```
