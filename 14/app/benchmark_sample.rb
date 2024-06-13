require_relative './multiply_prof'

require 'benchmark'
p(Benchmark.realtime do
  3000000.times do
    mp = MultiplyProf.new([2.4r, 4.2r])
    mp.integer
    mp.float
    mp.rational
  end
end)