# 今週のテーマ
ウェブアプリケーション設計の原則

# 方針
Railsにおけるウェブアプリケーション設計のベストプラクティスが学べたら嬉しい。
全体をざっと読んでみる

## 16.1 クライアントサイド中心の設計とサーバーサイド中心の設計
ロジックをクライアントサイド（JS）に持たせるか、サーバーサイド（Ruby）に持たせるか

### クライアントサイド中心の設計
高度なインタラクションを求められる場合はクライアント側で実装するしかない  
インタラクションとは、inter + actionの造語。  
何かしらアクションをしたらそれに応じてなにかリアクションするということ。  

### サーバサイド中心の設計
バックトレースを取得することが容易つまりデバッグが容易  
クライアント側でエラーが出た場合、開発者が見つければ共有できるけど、一般ユーザが使っていてエラーが出てもバックトレースを取得するのは無理  
ただ、高度なインタラクションが必要とするところには向かない。  

Hotwireなどフロント側をサーバサイドで記述するような技術も出てきているため、これをうまく使っていくことで、サーバサイド中心の設計でも高度なインタラクションを実現できる？  

個人的にはRails使ってるならサーバサイド中心に設計した方が、ビューヘルパーやERB、ストロングパラメータなどの恩恵が受けれるので、高速に開発できるかなと思ってる。

## 16.2 ウェブフレームワークの選定
- Ruby on Rails
- Sinatra
- Grape
- Roda

## 16.3 URL パスの設計
### フラットアプローチ
扱う要素ごとにトップレベルのURLパスを持たせる

### ネストアプローチ
情報の依存関係をURLパスとしてエンコードする

トピックテーブルの主キーが  
(forum_id = 1, topic_id = 1)  
(forum_id = 2, topic_id = 1)  
みたいなフォーラムのidとトピックのidの組み合わせとかだったりするとネストアプローチしか無理そう  

DB設計にも関わってくるなと感じた。  
RESTfulなURL設計とはこういうものだという話とかなのかなと思ったけどそうでもなかった。

## 16.4 モノリス、マイクロサービス、アイランドチェーン
### モノリス
アプリケーションのコードを同じリポジトリで管理する  
すべてのデータを同じデータベースに保存する  
マージタイミングでの他の人の作業とのコンフリクトに注意  

### マイクロサービス
システムの各構成要素を別のリポジトリで管理する  
データもそれぞれのマイクロサービスごとに保存する  
インターフェースを変えるとなったときのインパクトが大きい。  
他のマイクロサービスから使っている人たち全員とのコミュニケーションが必要  
まぁコミュニケーションが必要なのはどのアーキテクチャでも変わらんと思うけどな。  

### アイランドチェーン
アプリケーションをすべて同じリポジトリで管理する  
データも同じデータベースに保存する  
一方、アプリケーションの構成要素は別々のプロセスで動作させる。  
管理ユーザが使うプロセスは少なく、一般ユーザが使うプロセスは多くするといった使い分けができる  
なんやかよくわからん・・・。

ネオジニアのアーキテクチャはモノリスに該当する？  
Dockerコンテナごとに分けられてて、それぞれ別プロセスで動くと考えればアイランドチェーンに該当する？  
ezgateとかはリポジトリがそれ単体であるし、マイクロサービスと言っていいのかな？
