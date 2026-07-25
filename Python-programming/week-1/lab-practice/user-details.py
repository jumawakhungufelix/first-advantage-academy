def userInfo():
    name = input ("Name: ").strip().upper()
    age = int(input("Age: "))
    city = input("City: ").strip().upper()
    
    birth_year = 2026 - age
    
    print("\n==================================")
    print("             INFO CARD              ")
    print("\n==================================")
    print(f"Personś name: {name}")
    print(f"Age:          {age}")
    print(f"Birth year:   {birth_year}")
    print(f"Home City:    {city}")
    print("=====================================")
    
userInfo()