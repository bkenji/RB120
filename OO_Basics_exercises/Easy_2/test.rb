class MyClass



  def initialize(name)
    @word = name
  end

  def word
    @word
    'hello'
  end
  attr_accessor :word
end

c = MyClass.new('bob')
p c.word
p c