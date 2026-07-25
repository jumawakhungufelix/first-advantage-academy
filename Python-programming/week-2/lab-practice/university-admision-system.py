def admision_system():
    grade = input('enter KCSE grade attained: ')
    course_choice = input('Enter course choice: ')
    
    if course_choice == 'computer science':
        
        if grade in ['A','B']:
            print(f'Congradulations You meet the minimum requirements for thid course of average grade requirements of grade {grade}\n required grade either A or B')
        elif grade in ['C','D','E'] :
            print(f'You do not meet the minimum requirements for this course ,\n required grade A or B,\n you have grade {grade}')
        else:
            print('Invalid choice for grade')
admision_system()
        