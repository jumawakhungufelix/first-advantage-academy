def atm_withdrawal():
    balance =int(input('Enter current balance: '))
    transact_choice = int(input('enter 1 for current balance and 2 for withdrawal '))
    daily_limit = 70000
    
    if transact_choice == 1 :
        print(balance)
        
        
    elif transact_choice == 2 :
        withdraw = int(input('Enter amount to withdraw '))
        
        if daily_limit >= withdraw <= balance :
            print(f'withdrawal successfull. new balance is {balance-withdraw}')
            
        else:
            if withdraw > balance:
                print('withdrawal amount is more than the account balnce')
            else:
                print('You have exceeded the daily limit of withdrawal enter a low amount')
    else:
        print('invalid entry')
atm_withdrawal()
    