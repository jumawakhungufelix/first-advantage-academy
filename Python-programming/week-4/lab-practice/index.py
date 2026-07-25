#-----------class definition syntax-----------
class Student:

    
    #class attribute -- shared by all instances
    institution = 'FAC Academy'
    student_count = 0
    
    
    #__init__ = constructor - runs when object is created
    def __init__( self, name: str, reg_no: str,marks: float):
        #instance attributes -- unique to each object
        self.name = name.strip().title()
        self.reg_no = reg_no.upper()
        self.marks = marks
        self.grade = self.calc_grade()  # call method in init
        Student.student_count += 1      # update class variable
        
        #instaces method - convention: starts with _
    def calc_grade(self)-> str:
        if self.marks >= 70: return 'A'
        elif self.marks >= 60: return 'B'
        elif self.marks >- 50: return 'C'
        else: return 'Fail'
        
        #class method - operates on the class not instance  
    @classmethod
    def get_count(cls):
        return cls.student_count
    #string representation - for print() and str()
    def __str__ (self)-> str:
        return f"Student {self.name}, {self.reg_no}, Grade{self.grade}"
st1 = Student('felix','CT12',70)
print(st1)
              