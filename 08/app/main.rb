module Plugins
  module Core
    # Bookを拡張するためのモジュール
    module BookMethods
      attr_accessor :checked_out_to # ここにはUserのインスタンスが入る

      def initialize(name)
        @name = name
      end

      # 返却
      def checkin
        checked_out_to.books.delete(self)
        @checked_out_to = nil
      end
    end

    # Userを拡張するためのモジュール
    module UserMethods
      attr_accessor :books
      def initialize(id)
        @id = id
        @books = []
      end

      # 借りる
      def checkout(book)
        book.checked_out_to = self
        @books << book
      end
    end
  end
end

class Libry
  class Book; end
  class User; end

  # プラグインの読み込み処理
  def self.plugin(mod)
    if defined?(mod::BookMethods)
      Book.include(mod::BookMethods)
    end
    if defined?(mod::UserMethods)
      User.include(mod::UserMethods)
    end
  end

  plugin(Plugins::Core) # 最初からデフォルトの挙動は使えるようにしておく
end

puts "----- Core Plugin -----"
user = Libry::User.new(1)
book = Libry::Book.new("Ruby入門")
user.checkout(book)
p user.books
book.checkin
p user.books #=> []

module Tomoprog
  module BookMethods
    def initialize(name)
      super
    end

    def checkin
      # 返却しません
    end
  end
end

# 自分で作ったプラグインを使う
puts "----- Tomoprog Plugin -----"
Libry.plugin(Tomoprog)
user = Libry::User.new(1)
book = Libry::Book.new("Ruby入門")
user.checkout(book)
p user.books
book.checkin
p user.books #=> [Ruby入門]

