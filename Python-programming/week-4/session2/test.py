class Parent:
    def __init__ (self,name,age):
        self.__name = name
        self._age = age
        
    @property
    def setname(self):
        return self.__name
    
class Child:
    def display(self):
        return f'{self.name}'