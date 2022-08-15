# Reverse Engineering

# Write a class that will display:

# ABC
# xyz

# when the following code is run:

# my_data = Transform.new('abc')
# puts my_data.uppercase
# puts Transform.lowercase('XYZ')


class Transform
  attr_reader :string

  def initialize(string)
    @string = string
  end

  def uppercase
    string.upcase
  end

  def self.lowercase(str)
    str.downcase
  end
end


my_data = Transform.new('abc')
puts my_data.uppercase
 puts Transform.lowercase('XYZ')


# ANSWER:
# - In order to instantiate a new object by invoking Transform::new, a class named Transform must be defined.
# - Moreover, since Transform::new takes one argument, we must define a constructor `initialize` method within it that also takes one argument, storing it in an instance variable. 
# - Since we must be able to call the method Transform#upperacse on the instances of Transform, we must define an instance method named uppercase that will the value of the instance variable in uppercase.
# - Since we also must be able to call Transform::lowercase on the class itself (rather than on the instance of the class), we must define a class method named lowercase that will take an argument and return the argument in lowercase form.