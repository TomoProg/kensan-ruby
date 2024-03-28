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
