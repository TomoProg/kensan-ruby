class MultiplyProf
  def initialize(vals)
    @i1, @i2 = vals.map(&:to_i)
    @f1, @f2 = vals.map(&:to_f)
    @r1, @r2 = vals.map(&:to_r)
  end

  def integer
    @i1 * @i2
  end

  def float
    @f1 * @f2
  end

  def rational
    @r1 * @r2
  end
end

require_relative './multiply_prof'

require 'ruby-prof'
result = RubyProf.profile do
  1000.times do
    mp = MultiplyProf.new([2.4r, 4.2r])
    mp.integer
    mp.float
    mp.rational
  end
end

# プロファイル結果を表形式のテキストで出力する
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT, {})