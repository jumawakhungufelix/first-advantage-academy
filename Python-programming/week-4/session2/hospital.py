class Person:
    def __init__(self,name: str, id: str):
        self.__name = name
        self._id = id
        
        
    
    @property
    def name(self):
        return self.__name
        
    def describe(self):
        return f' name is {self.__name} with id {self._id}'
    
    def __str__(self):
        return f'{self.__name}  {self._id}'
    
class Patient(Person):
    def __init__(self,name,id,dob,blood_type,ward):
        super().__init__(name,id)
        self.odb = dob
        self.blood_type = blood_type
        self.ward = ward         
    def describe(self):
        print('')
    
class Doctor(Person):
    def __init__(self, name, id,occupation):
        super().__init__(name,id)
        self.occupation = occupation
        
    def describe(self):
        return f'{self.name} is a {self.occupation} ID: {self._id}'
    
    
   
    
    
class Nurse(Person):
    def __init__(self,name,id,occupation):
        super().__init__(name,id)
        self.occupation = occupation
        
        
    def describe(self):
        return f'{self.name} is a {self.occupation} ID: {self._id}'
    
patient = Patient('alison','AC009','Cancer level 1')
doctor = Doctor('james','DC09','Doctor')
nurse = Nurse('Ann','N006','Nurse')
print('=======================================================================')
print(patient.describe())
print('========================================================================')
print(doctor.describe())
print('================================================================================')
print(f'{nurse.describe()} a nurse')
print('================================================================================')