class ATMError(Exception): pass
class PINError(Exception): pass
class BalanceError(ATMError): pass
accounts = {'ACC001': {'name':'Brian','balance': 45000,'pin':'1234','attempts': 0}}

def get_account(acc_no):
    acc = accounts.get(acc_no)
    if not acc:
        raise ATMError(f'Account {acc_no} not found.')
    return acc

def verify_pin(acc,pin):
    if acc['attempts'] >= 3:
        raise PINError('Acconunt locked. Contact support.')
    if acc['pin'] != pin:
        acc['attempts'] += 1
        left= 3 - acc['attempts']
        raise PINError(f'Wrong PIN. {left} attempt(s) remaining.')
    acc['attempts'] = 0 
    
def withdraw(acc,amount):
    try:
        amount = float(amount)
    except ValueError:
        raise ATMError ('Amount must be positve.')
    if amount <= 0:       raise ATMError('Amount must be positive')
    if amount > 70000:    raise ATMError('Exceeds daily limit KES 70000')
    if amount > acc['balance'] : raise BalanceError('insufficient funds.')
    acc['balance'] -= amount
    return amount
try:
    acc = get_account(input('Account No: '))
    verify_pin(acc, input('PIN: '))
    drawn = withdraw(acc,input('Amount:'))
    print(f'KES {drawn:.2f} dispensed. Balance: KES {acc['balance']:,.2f}')
except PINError as e : print(f' PIN Error: {e}')
except BalanceError as e: print(f'Balance Error: {e}')
except ATMError as e: print(f'ATM Error: {e}')
