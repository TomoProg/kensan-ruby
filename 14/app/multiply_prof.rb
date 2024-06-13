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
