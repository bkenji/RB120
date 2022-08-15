# Complete the Program - Houses

# Assume you have the following code:

class House
  attr_reader :price, :rooms
  include Comparable

  def initialize(price, rooms)
    @price = price
    @rooms = rooms
  end

  def <=>(other)
    self <=> other
  end
end

home1 = House.new(100_000, 2)
home2 = House.new(150_000, 4)


puts "Home 1 is cheaper" if home1.rooms < home2.rooms
puts "Home 2 is more expensive" if home2.rooms > home1.rooms

# Home 1 is cheaper
# Home 2 is more expensive


# ANSWER:
# - The goal is to have home1 < home2 be equal to home1.price < home2.price
# - Including the Comparable module gives us access to the <=> method, which allows for comparisons of different integer values.
# - We can then redefine <=> within the House class to accept one argument (another instance object) and compare the price of self with the price of the other instance object.

# FURTHER EXPLORATION:
# - The technique employed in the solution restricts comparison (<=>) to comparing the attribute price of the House objects only. It wouldn't work if we wanted to compare, say, their size, or their age, or the number of rooms they have.
# - In order to allow for the comparison of any (existing or potential) quantifiable attribute of the object house, perhaps we could use some duck-typing, which would allow different object types (including different attributes of the class objects, which are themselves different object types) to respond to the same interface (i.e., to the <=> method).
# - But how to implement duck typing?
# - A simpler solution (adopted by Tovi Newman in the discussion for this exercise) is to redefine the `<=>` method to compare simply `self` with `other`. Then, when calling the method, one can specify which attribute to compare during runtime.
