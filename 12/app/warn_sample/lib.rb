class Sample
  def self.deprecated_method
    warn("#{__callee__} is deprecated", uplevel: 0, category: :deprecated)
    puts "Hello, deprecated method!"
  end

  def self.experimental_method
    warn("#{__callee__} is experimental", uplevel: 1, category: :experimental)
    puts "Hello, experimental method!"
  end
end
