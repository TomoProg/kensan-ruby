def measure
  s = Time.now
  yield
  e = Time.now
  puts "経過時間: [#{e - s}s]"
end

def sample
end

num = ARGV[0]&.to_i || 100000
puts "#{num}回呼び出します"

puts "シンボル"
measure do
  100000.times do
    send(:sample)
  end
end

puts "文字列"
measure do
  100000.times do
    send('sample')
  end
end

puts "文字列->to_sym"
measure do
  100000.times do
    send('sample'.to_sym)
  end
end
