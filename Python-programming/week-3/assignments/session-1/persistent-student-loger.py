#creates text file
# with open('student.txt', 'w') as f:
#     f.write('Felix, 95\n')
#     f.write('kelvin , 90\n')
  
  #seaarch by nam function  
def search_by_name(name):
    with open('student.txt', 'r') as f:
        content=f.read()
        for i in content:
            if name in content:
                return f'{name} found. sucess!'
            
            else:
                return f"{name} not found in {content}"
                
#delete function
def delete_student(data):
    with open('student.txt', 'r') as f:
        records = f.readline()
        
    new_record = [record for record in  records if data not in record]
    print("record deleted successfuly")
    
    with open('student.txt', 'w') as f:
        f.writelines(new_record)
        
                

print(search_by_name('kelvin'))
delete_student('kelvin, 90')

        