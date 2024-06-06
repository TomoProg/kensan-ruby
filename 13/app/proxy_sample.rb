require 'forwardable'

class Sample
  extend Forwardable

  def initialize(val)
    @val = val
  end
  def_delegator :@val, :upcase, :upcase2

  def upcase2
    "bbb"
  end
end

#class HashProxy < DelegateClass(Hash)
class HashProxy < Hash
  def size_squared
    size ** 2
  end
end

s = Sample.new("foo")
p s.upcase2

a = HashProxy.new
a["aaa"] = 1
p a.size_squared
p a.size
