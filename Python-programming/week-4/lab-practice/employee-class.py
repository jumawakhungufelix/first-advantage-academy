class Employee:
    employee_count = 0
    
    def __init__(self,emp_id: str, name: str,department: str, salary: str):
        self.emp_id = emp_id
        self.name = name
        self.department = department
        self.salary = salary
        Employee.employee_count += 1
        
    def display(self):
        return f'employee name: {self.name}\n employee id: {self.emp_id}\n employee department: {self.department}\n salary: {self.salary}'
    
    def get_net_pay(self):
        return f'Net pay: {self.salary * 0.88}'
    
    def promote(self,amount):
        return f'promoted to an earning of KES {self.salary + amount}'
    
    @classmethod
    def get_total_employees(cls):
       return cls.employee_count
   
    def __str__(self):
       return f"Employee {self.emp_id} {self.name}"
   
    
employee = Employee('EM01', 'felix','DPT1',40000)
print('==============Employee details========')
print(employee)
print(f'==============no.{employee.get_total_employees()}=======================')
print('Details')
print(employee.display())
print(employee.get_net_pay())
print(employee.promote(20000))
print('====================================')