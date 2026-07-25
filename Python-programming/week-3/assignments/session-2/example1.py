# try:
#     age = int (input('Enter age: '))
#     result = 100/age
# except ValueError:
#     print('Invalid age - please enter a nuber!')
# except ZeroDivisionError:
#     print('Age cannot be zero!')
# else:
#     print(f'Result : {result:.2f}')
# finally:
#     print('Program continues safely.')

# def calculate_grade(marks):
#     if not isinstance(marks, (int,float)):
#         raise TypeError(f'Marks must be numeric , got {type(marks).__name__}')
#     if marks < 0 or marks > 100:
#         raise ValueError(f'Marks must ve 0-100, got {marks}')
#     return 'A' if marks >= 70 else 'B' if marks >= 60 else 'C'

# try:
#     print(calculate_grade('name'))
    
# except ValueError as e:
#     print(f'Error: {e}')
    
# class InsufficientFundsError(Exception):
#     def __init__(self,balance,amount):
#         self.balance = balance
#         self.amount= amount
#         super().__init__()

# try:
#     new_balance = wihdraw(5000,8000)
# except InsufficientFundsError as e:
#     print(f'Transaction failed: {e}')
    
    
    
    
    