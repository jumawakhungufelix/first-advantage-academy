def budgetTracker():
    monthly_income= int(input("Enter salary: "))
    expence1 = input("Enter expense 1: ").strip().upper()
    amount1 = int(input("Cost: "))
    expence2 = input("Enter expence 2: ").strip().upper()
    amount2 = int(input("Cost: "))
    expence3 = input("Enter expence 3: ").strip().upper()
    amount3 = int(input("Cost: "))
    expence4 = input("Enter expence 4: ").strip().upper()
    amount4 = int(input("Cost: "))
    expence5 = input("Enter expence 5: ").strip().upper()
    amount5 = int(input("Cost: "))
    
    
    
    total_expences = amount1 + amount2 + amount3 + amount4 + amount5
    
    
    
    surplus = monthly_income - total_expences
    
    savings = surplus/(monthly_income) * 100
    
    
    print ("============================================")
    print ("     INTERACTIVE PERSONAL BUDGET TRACKER     ")
    print("==============================================")
    print(f"  {expence1} :  {amount1} ")
    print(f"  {expence2} :  {amount2} ")
    print(f"  {expence3} :  {amount3} ")
    print(f"  {expence4} :  {amount4} ")
    print(f"  {expence5} :  {amount5} ")
    print("_____TOTAL EXPENCES AND SAVINGS________________")
    print(f"Toatal Expences : {total_expences}")
    if surplus > 0:
        print(f"Surplus         : {surplus} savings :({savings}%)")
    else:
        print(f"You have a balance deficit of {surplus} and therefore no amount saved")
        
    print("===============================================")
budgetTracker()
    
    
        
        
        
        

    
    
    
    
    
    
    
    