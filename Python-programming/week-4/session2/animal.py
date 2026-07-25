class Animal :
    def __init__(self,name:str, species:str):
        self.name = name
        self.species = species
        
    def speak(self) -> str:
        return f"{self.name} makes sound"
    
    
    def describe(self):
        return f'{self.name} is a {self.species}'
        
        
class Dog(Animal):
    def __init__ (self,name,breed):
        super().__init__(name,'Canis lupus Familiars')
        self.breed = breed
        
class Cat(Animal):
    def speak(self) -> str:
        return f"{self.name} says : Meow!"
    
dog = Dog('rex','German shephard')
cat = Cat('whiskers','Felis catus')

print(dog.describe())
print(dog.breed)
print(dog.speak())
print(cat.describe())
print(cat.speak())   