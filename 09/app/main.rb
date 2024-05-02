module MyAttrReaderModule
  def my_attr_accessor(*args)
    args.each do |arg|
      define_method(arg) do
        instance_variable_get("@#{arg}")
      end
      define_method("#{arg}=") do |v|
        instance_variable_set("@#{arg}", v)
      end
    end
  end
end

class SampleClass
  extend MyAttrReaderModule
  my_attr_accessor :v
end

p SampleClass.method_defined? :v

s = SampleClass.new
s.v = 1
p s.v #=> 1
