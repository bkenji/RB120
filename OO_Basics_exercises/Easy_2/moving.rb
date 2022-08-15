# Moving

# You have the following classes. Modify the code so that the output below it works. You're only allowed to write one new method to do this.

module Walkable
  def walk
    puts "#{name} #{gait} forward"
  end
end

class Person
  attr_reader :name
  include Walkable

  def initialize(name)
    @name = name
  end

  private

  def gait
    "strolls"
  end
end

class Cat
  attr_reader :name
  include Walkable

  def initialize(name)
    @name = name
  end

  private

  def gait
    "saunters"
  end
end

class Cheetah
  attr_reader :name
  include Walkable

  def initialize(name)
    @name = name
  end

  private

  def gait
    "runs"
  end
end


mike = Person.new("Mike")
mike.walk
# => "Mike strolls forward"

kitty = Cat.new("Kitty")
kitty.walk
# => "Kitty saunters forward"

flash = Cheetah.new("Flash")
flash.walk
# => "Flash runs forward"


# ANSWER:
# - This is an exercise in polymorphism. Different object types responding to a common interface, regardless of how different the actual implementation of their method is. 
# - One way to satisfy the  requirements of the problem is to define a module Walkable, and within it a method walk, returning a string which interpolates the parameters necessary to satisfy the problem.