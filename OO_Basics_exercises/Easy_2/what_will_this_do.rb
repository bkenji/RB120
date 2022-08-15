# What Will This Do?

# What will the following code print?

class Something
  def initialize
    @data = 'Hello'
  end

  def dupdata
    @data + @data
  end

  def self.dupdata
    'ByeBye'
  end
end

thing = Something.new
puts Something.dupdata
puts thing.dupdata

# ANSWER:
# - Instances of the class Something are initialized with the attribute @data set to "Hello". They have access to the public method `dupdata`, which concatenates the value of @data to itself (thus duplicating it). The class itself has access to another method (a class method) also named `dupdata` (while potentially confusing, no conflict is possible between the two namesake methods, as one can only be invoked upon instances of the class, and the other only upon the class itself). This class method, when invoked, returns the string "ByeBye".

# On line 19 we instantiate a new object 'thing' belong to the Something class.
# On line 20, we output the return value of calling the class method `dupdata`` upon Something, which prints "ByeBye".
# on line 21, we output the return value of calling the instance method `dupdata` upon the instance `thing`, which prints "HelloHello".