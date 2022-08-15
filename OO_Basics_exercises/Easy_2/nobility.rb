# Nobility

# Now that we have a Walkable module, we are given a new challenge. Apparently some of our users are nobility, and the regular way of walking simply isn't good enough. Nobility need to strut.

# We need a new class `Noble` that shows the title and name when `walk` is called.

# byron = Noble.new("Byron", "Lord")
# byron.walk
# => "Lord Byron struts forward"

# We must have access to both `name` and `title` because they are needed for other purposes that we aren't showing here.

module Walkable
  def walk
   "#{name} #{gait} forward"
  end
end

class Animal
  attr_reader :name
  def initialize(name)
    @name = name
  end

end

class Person < Animal
  include Walkable
  private

  def gait
    "strolls"
  end
end

class Noble < Person
  include Walkable
  attr_reader :title, :name

  def initialize(name, title)
    @title = title
    @name = name
  end

  def walk
    "#{title} #{super}"
  end

  private

  def gait
    "struts"
  end
end

class Cat < Animal
  include Walkable

  private

  def gait
    "saunters"
  end
end

class Cheetah < Cat

  private

  def gait
    "runs"
  end
end

byron = Noble.new("Byron", "Lord")
p byron.walk
# => "Lord Byron struts forward"
p byron.name
# => "Byron"
p byron.title
# => "Lord

mike = Person.new("Mike")
mike.walk
# => "Mike strolls forward"

kitty = Cat.new("Kitty")
kitty.walk
# => "Kitty saunters forward"

flash = Cheetah.new("Flash")
flash.walk
# => "Flash runs forward"


