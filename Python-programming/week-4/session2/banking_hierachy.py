# ____________Complete banking class hierachy__________

class Account:
    def __init__ (self,acc_no,owner,balance = 0.0):
        self.acc_no = acc_no
        self.owner = owner
        self.__balance = balance
        self._history = []
        
    @property
    def balance(self):return self.__balance
    
    def _record(self,msg): self._history.append(msg)
    
    def deposit(self,amt):
        if amt <= 0: raise ValueError('Positive amounts only')
        self.__balance += amt
        self._record(f'+KES{amt:,.2f} -> {self.__balance:,.2f}')
        
    def withdraw(self,amt):
        if amt > self.__balance: raise ValueError('Insufficient funds')
        self.__balance -=amt
        self._record(f'-KES {amt:,.2f} -> {self.__balance:,.2f}')
        
    def __str__(self):
        return f'{self.__class__.__name__} ({self.acc_no},{self.owner})'
    
class SavingsAccount(Account):
    INTEREST_RATE = 0.08
    def __init__(self,acc_no,owner,balance):
        super().__init__(acc_no,owner,balance)
    def add_interest(self):
        interest = self.balance * self.INTEREST_RATE
        self.deposit(interest)
        print(f'Interest added : KES {interest:,.2f}')
        
class CurrentAccount(Account):
    def __init__(self, acc_no,owner,balance= 0.0,overdraft = 10000):
        super().__init__(acc_no,owner,balance)
        self._overdraft = overdraft
    def withdraw(self,amt):
        if amt > self.balance + self._overdraft:raise ValueError('Overdraft limit exceeded')
        super().withdraw(amt)  #call parent withdraw
        
    #polymorphism
accounts = [SavingsAccount('SAV001','Brian',500),CurrentAccount('CUR001','Mary',10000)]
for acc in accounts:
    acc.deposit(5000)
    print(acc) #Different class names
        
        
         
        