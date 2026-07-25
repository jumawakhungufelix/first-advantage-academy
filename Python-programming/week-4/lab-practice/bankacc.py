class BankAccount:
    '''Models a simple bank savings acount.'''
    
    INTEREST_RATE = 0.08  #8% annual - class constant
    
    def __init__ (self,acc_no: str,owner : str, balance: float = 0.0):
        self.acc_no =acc_no
        self.owner = owner.strip().title()
        self.balance = balance  #balcnce = 'protected' convention
        self.history = []
        
    def deposit(self,amount: float):
        if amount <= 0:
            raise ValueError('Deposit amount must be ppositive')
        self.balance += amount
        self.history.append(f'Deposit +ksh {amount:>10,.2f} Balance: {self.balance:>10,.2f}')
        print(f'Deposited KES {amount:,.2f}. New balance: KES {self.balance:,.2f}')
        
    def withdraw(self,amount:float):
        if amount <= 0:   raise ValueError('Amount must be positive')
        if amount > self.balance: raise ValueError('Insufficient funds')
        self.balance = amount
        self.history.append(f' Withdraw KES{amount:>10,.2f} Balance: {self.balance:>10,.2f} ')
        print(f'Withdrew KES {amount:,.2f}. New balance: KES {self.balance:,.2f}')
        
    def get_balance(self) -> float: return self.balance
    
    def mini_statement(self):
        print(f'\n=== {self.owner} | {self.acc_no} ===')
        for entry in self.history[-5:]:  #last 5 transactions
            print(f' {entry}')
        print(f'current balance : KES {self.balance:,.2f}')
        
acc = BankAccount('KCB-001','brian ochieng',10000)
acc.deposit(5000)
acc.withdraw(2000)
acc.mini_statement()
        