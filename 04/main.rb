def foo(**kwargs)
  p kwargs
  bar(**kwargs)
  p kwargs
  baz(**kwargs)
  p kwargs
end
def bar(bar: nil)
  bar
end
def baz(baz: nil)
  baz
end

foo(bar:1, baz:2)
