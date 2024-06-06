# 今週のテーマ
代表的なデザインパターンを使う

# 方針
デザインパターンの復習  
Rubyの場合にどういった違いが出るのかを意識して読む  

## 13.1 Ruby に組み込まれているデザインパターン
- Object Pool パターン  
新しくオブジェクトを生成するためにメモリを確保せず、既存のオブジェクトを再利用する。  
GOFのデザインパターンではない。  
RubyのGCのの仕組みに使われている。  
この辺はRubyの内部実装であって、業務で意識するところではなさそう。  

- Prototype パターン  
クラスベースではクラスにどんな種類の値をインスタンスに持たせるか（どんなメソッドやプロパティを定義するか）という構造を定義する  
プロトタイプベースでは、クラスを定義するのではなく、既存のオブジェクトを複製し、それに修正を加えることで、新しいオブジェクトを生成する  
GOFのPrototypeパターンも、インスタンスを新たに作る場合に、既存のオブジェクトを複製する。  
プロトタイプベースの実装もRubyでは可能ということを言いたい。  

- Private Class Dataパターン
データの公開範囲を設定して、外部からのアクセスを制限する  
public protected privateでアクセス制限しているのをPrivate Class Dataパターンと呼んでる？  
そんな呼び方初めて聞いた。  
GOFのデザインパターンではない  

- Proxy パターン
オブジェクトをラップするオブジェクトを作成する。  
メトリクスやキャッシングといった有用な振る舞いを追加できるとのこと。  
デザインパターンの本では生成を遅延させるときに有効というのが主な説明だったが、こちらでは処理をラップするのが主な使い方として紹介されている  

forwardableは単純にメソッドを移譲することしかできないため、振る舞い追加できなさそう・・・。

キャッシングとかの振る舞いを追加したければ、新たにメソッド追加して、そのメソッドから元のメソッドを呼び出すという形になりそう

```rb
class Sample
  extend Forwardable

  def initialize(val)
    @val = val
  end
  
  # これでSample.new.upcase2と書けば、@val.upcaseと同じになる。
  def_delegator :@val, :upcase, :upcase2
  
  # ただ、これしかできないので、upcaseする前にログを書きたいとか
  # 振る舞いを追加したいのなら以下のようなメソッドを定義するしかなさそう
  def upcase2
    puts "upcase"
    @val.upcase
  end
end
```

DelegateClassしらなかった
継承すれば同じなのでは？とも思ったが、newするときに元となるオブジェクトを渡すところが違う

```rb
class HashProxy < DelegateClass(Hash)
  def size_squared
    size ** 2
  end
end
HashProxy.new({:a => 1, :b => 2}).size_squared

# これと違いがないのでは？と思ったが、これだとnewした時に元となるオブジェクトは渡せない
# あるオブジェクトに対して機能拡張ができない
class HashProxy < Hash
  def size_squared
    size ** 2
  end
end
a = HashProxy.new
a[:a] = 1
a[:b] = 2
a.size_squared
```
