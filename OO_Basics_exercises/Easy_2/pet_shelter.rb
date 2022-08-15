# Consider the following code. Then write the classes and methods that will be necessary to make this code run and print the output that follows.

# ANSWER:

# - We need a `Pet` class that takes two arguments, "kind" and "name", when creating new objects.
# - We need an `Owner` class that takes one argument, "name", when creating new objects.
#   - Instances of 'Owner` have  access to the getter methods `name` and `number_of_pets`
# - We need a `Shelter` class that takes no arguments when instantiating new objects.
#   - Instances of the `shelter` class have access to the instance method `adopt`, which takes two objects as arguments: an instance from `Owner` and an instance from `Pet`.
#   - Instances of the `shelter` class also have access to the instance method `print_adoptions`, which prints all the pets adopted by all the owners in the specified string format

# Class: Pet


# Class: Owner
# - How to increment @number_of_pets ?

# Class: Shelter
# - When the instance method `adopt` is called on a shelter object, taking 2 arguments (an owner object and a pet object)
#   - the owner object is stored as a key in a hash
#   - the owner's pet is stored as an element of an array that is the value for the corresponding owner key
# - Ex.: adoptions = {phanson =>[butterscotch, pudding, darwin], bholmes =>[kennedy, sweetie, molly, chester]}
# - When the instance method `print_adoptions` is called on a shelter object, it outputs a string formatted as follows:
#   "#{phanson.name} has adopted the following pets:"
#   "a #{butterscotch.kind} named #{butterscotch.name}"
#   "a #{pudding.kind} named #{pudding.name}" etc
#  - In order to do so, `print_adoptions` must:
#    - Iterate over the hash `owners` 
#    - puts "#{k} has adopted the following pets:"
#    - puts v  (should we re-define Pet#to_s?)


class Pet
  attr_reader :animal, :name

  def initialize(animal, name)
    @animal = animal
    @name = name
   
  end

  # def add_to_shelter(shelter)
  #   shelter.add_to_all_pets(self)
  # end

  def to_s
    "a #{animal} named #{name}"
  end
end

class Owner
  attr_reader :name, :pets
  
  def initialize(name)
    @name = name
    @pets = Array.new
  end

  def number_of_pets
    pets.size
  end

  def add_pet(pet)
    @pets << pet
  end
end

class Shelter
  attr_reader :unadopted_pets
 
  def initialize(*unadopted_pets)
    @owners = Hash.new(0)
    @unadopted_pets = unadopted_pets
  end

  def adopt(owner, pet)
    owner.add_pet(pet)
    @unadopted_pets.delete(pet)
    @owners[owner.name] = owner.pets
  end

  def print_adoptions
    @owners.each do |owner , pets|
      puts "#{owner} has adopted the following pets:"
      puts pets  
      puts
   end
  end

  def print_unadopted
    puts unadopted_pets
  end

end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
# darwin       = Pet.new('bearded dragon', 'Darwin')
# kennedy      = Pet.new('dog', 'Kennedy')
# sweetie      = Pet.new('parakeet', 'Sweetie Pie')
# molly        = Pet.new('dog', 'Molly')
# chester      = Pet.new('fish', 'Chester')
# asta         = Pet.new("cat", "Asta")
# laddie       = Pet.new("dog", "Laddie")


phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

# shelter.adopt(phanson, darwin)
# shelter.adopt(bholmes, kennedy)
# shelter.adopt(bholmes, sweetie)
# shelter.adopt(bholmes, molly)
# shelter.adopt(bholmes, chester)

# puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
holly = Pet.new("dog", "Holly")
jonsnow = Pet.new("cat", "Jon Snow")
juno = Pet.new("dog", "Juno")
frida = Pet.new("dog", "Frida")
glaya = Pet.new("gecko", "Glaya Kayan")
brennokenji = Owner.new("B Kenji")

shelter = Shelter.new(butterscotch, pudding, holly, jonsnow, juno, frida, glaya)
shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."

shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(brennokenji, jonsnow)
shelter.adopt(brennokenji, frida)
shelter.adopt(brennokenji, glaya)
shelter.adopt(brennokenji, juno)
shelter.print_adoptions
shelter.print_unadopted


# P Hanson has adopted the following pets:
# a cat named Butterscotch
# a cat named Pudding
# a bearded dragon named Darwin

# B Holmes has adopted the following pets:
# a dog named Molly
# a parakeet named Sweetie Pie
# a dog named Kennedy
# a fish named Chester

# P Hanson has 3 adopted pets.
# B Holmes has 4 adopted pets.