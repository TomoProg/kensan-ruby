# 今週のテーマ
役に立つドメイン特化言語を設計する

# 方針
思ったことを率直に書いておくくらい。
自分が一番理解したと思うのは、実際にコードを書いて動かしてみることなので、理解できない箇所は動かしてみる

# 10.1 独自の DSL を設計する

## 10.1.1 設定用 DSL
RSpecの設定が例としてあげられている

```ruby
RSpec.configure do |c|
  c.drb = true
  c.drb_port = 24601
  c.around do |spec|
    DB.transaction(rollback: :always, &spec)
  end
end
```

特異メソッドでブロックを受け取り、ブロックの中で設定を行う方式。

Railsではどうなっているのか、application.rbを調べてみると以下のようになっており、ブロックは受け取らない方式になっていた。

```ruby
module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0
    
    #...
  end
end
```

`config`というのが特異メソッドになっていて、`Rails::Application::Configuration`クラスを返す

そこにセッターとなるメソッドが色々定義されているようだ。

```ruby
[4] pry(App::Application)> config.class
=> Rails::Application::Configuration
[5] pry(App::Application)> method(:config).source_location
=> ["/var/rails/vendor/bundle/ruby/2.7.0/gems/railties-5.2.8.1/lib/rails/railtie.rb", 127]
```


## 10.1.2 複雑な設定用の DSL

設定用のメソッドに配列やハッシュを大量に渡すのは使いにくいものになりがち。

指定しているものが適切な形式になっているか確かめるのが困難なため。

設定値を格納しておくためのクラスを用意するのがよく見られる手法。

ただ、Rubyではブロックを使った記述ができるため、こちらを使った方が冗長な記述を避けることができるうえに、ブロックパラメータのみを使えば良いため、定数を参照する必要がない

ただし、設定値を使い回す場合は設定値を格納しておくクラスを用意した方が便利


## 10.1.3 冗長なコードを削減する DSL
SequelというORマッパー？の例が挙げられている

内部的にinstance_execを使い、Sequelオブジェクトの中で実行させることで、毎回Sequelという記述がなくても動作させているようだ。

instance_execは与えられたブロックをレシーバのコンテキストで実行できる

https://docs.ruby-lang.org/ja/latest/method/BasicObject/i/instance_exec.html


## 10.1.4 DSL として提供されるライブラリ
`minitest/spec`、`Sinatra`が挙げられていた

`minitest/spec`では`describe`、`it`、`before`、`after`といったメソッドが提供されており、クラスをnewするようなことはせずに、記述できるようになっている

# 10.2 独自の DSL を実装する

読んでみた感じだと

- yieldを使ってブロック引数に設定用のクラスを渡す方式

- Kernelオブジェクトにメソッドを定義してトップレベルでメソッドを呼び出す方式

- トップレベルでextendしてメソッドを定義する方式

実際に実装してみないと理解できなさそう。