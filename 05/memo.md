# 今週のテーマ
エラーに対処する

# 方針
読みながら知らなかった部分を書き出す
思ったことを率直に書いておくくらい。
実際に試したりするのは後回しにして、最後まで読み切る
時間測る 15m * 6 = 90m
時間をみつつ調整しながら進める

# 知らなかった部分

## 戻り値によるエラー処理
HashやArrayの添字に存在しない場所を指定した場合、nilが返る。
この原則が適用されるのは「もしレシーバーのデータ構成が 参照時点と異なっていれば、値を取得できる」と期待される場合
→なるほど。

OpenStructも同じ（OpenStructってどんなのだっけ？）

「レシーバーのデータ構成がどうあれ、データへの参照が必ず失敗する」場合は、例外を発生させる
→なるほど
Structが代表例

pkを渡すサンプル。
pkで探したいのにpkがnilの場合ってどんなときなんだろうか・・・。
nilが返ってくるメソッドの戻り値をそのまま渡すとかなんかな・・・。

> ここでの教訓は、「メソッドの呼び出し側が戻り値を使う必要がない状況で、エラー
の表現に戻り値を採用している場合には、特に用心が必要」ということです。そのよ
うなケースでは一般に例外を発生させるほうがよいでしょう。

戻り値を使う必要がない場合は戻り値を検査しないので、エラーになっているかどうかを見過ごしがち。
こういう場合は例外を発生させてあげた方がエラーに気づくため、バグの温床になりにくいということかな

14分

## 5.2 例外によるエラー処理
エラー処理として想定外の結果（例外が出るか、true, falseで返ってくるか）が起きると問題になる
この時の原則が
「API の設計にあたっては、APIを使いやすくすることだけでなく、APIを誤って使うのを難しくすることも考慮すべき」
誤用されないように設計すべき。
「誤用耐性 (misuse resistance)の原則」初めて聞いた。
?つけたり!つけたりするのはこの原則かな

「フェイルオープン(fail-open)な設計とフェイルクローズド(fail-closed)な設計を意識せよ」
オープン、クローズ？どういうこと？

> 「フェイルオープンな設計」では、 アクセス権のチェックで問題があっても、アクセスは許可されます。

どういうこと？そもそもチェックで問題があったらアクセスは許可されたらあかんやろ

> メソッドが true か false を返す場合、このメソッドの誤用はシステムをフェイルオープンにします

例外だって全部キャッチすれば一緒だよね？？？

全体的に使いたい場合、check?メソッドの場合はいろんな箇所にif文を入れることになる
例外で補足した方が一番最後に書けばいいだけなので、シンプル

5.2.1はパフォーマンス系の話になるため、一旦飛ばし。

14分

## 5.3 一時的なエラーを再試行する
リトライするために`retry`が使える
retry が使える場所は rescue 句だけです。begin 句では使えません。

> 例外をフロー制御に使っているのは少し「コードの不吉な臭い」がしますが、とも
あれ動くようにはなりました。

そうだよね。例外ってそういう使い方してるとコードの流れを追うのが大変そうだもんね。

1.timesって書いてる時点で、違和感を感じたけど、どうだろ・・・。
この辺は人によりけりだろうなぁ・・・。

HTTPリクエストをリトライするときにsleepするのは定石だな。
リトライする秒数を変更していくというのは斬新。
回数を重ねるごとに成功する確率は少ないはず。なるほど
とはいえ、この実装をするかと言われたら、要件によるとは思うが、小難しくしてるだけのように見えるしあんまりやらないかなという印象

直前に失敗しているなら呼び出しを止めたい
→なるほどこれはありそう
そういうのをサーキットブレーカーというらしい
サーキットブレーカーを実装した gem の採用をということだったが、何があるんだろう

22分

## 5.4 例外クラス階層の設計
例外クラス設計の一般原則は、「開発しているライブラリで例外を発生させるので あれば、独自の例外サブクラスを定義すべき」です。
ライブラリのユーザが他のライブラリの例外と区別できる

rescue 句で捕捉されるのは、StandardError を継承したクラ スだけです。
そうだったそうだった。

一般原則として、「エラーの種類に応じた個別の例外クラスを定義するのは、ユーザーがエラーの種類に応じた処理をおこないたい場合」に限ります。

例外クラスの数を際限なく増やすのは避けましょう。ライブラリで発生した例 外をユーザーが適切に処理する必要がある場合にのみ、例外クラスを用意してくだ さい。

ユーザの使い方を想像しながら例外クラスを作るということかな

一般に、Ruby のイディオムでは型に基づく防御的な プログラミングを避けます。なぜなら、Ruby で気にするのは「オブジェクトがどん なメソッドに反応できるのか」と「そのメソッドがどんなオブジェクトを返すのか」 だからです。
そうだよね。型に依存するんじゃなくて、使用しているメソッドに依存したい

12分

## 5.6 復習問題
パフォーマンス

エラーを見過ごすことが減るため、バグの温床になりにくい
→絶対に例外ハンドラを経由しないとけないから、何も書かずに黙って見過ごすは無理

すぐには原因が対処される可能性が低いため
再発する可能性が高い

その例外に対してだけ適切な処理を行いたい場合のみ

3分

# 試したこと、コードサンプル
特になし

# 疑問、質問
