class Fish
  attr_accessor :name
end


p Fish.new.name

nemo = Fish.new
nemo.name = "Nemo"

p nemo.name
