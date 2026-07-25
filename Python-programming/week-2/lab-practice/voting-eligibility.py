def eligibility(age,id_number,election_timeline):
    if age >= 18 and len(str(id_number)) == 8:
        return f'Citizen  ID: {id_number}  is {age} years and Eligible for this election'
    else:
        if age + election_timeline >= 18:
            return f'Citizen is {age} and not eligible for this but Will be eligible for the next election with {age+election_timeline} years old'
        else:
            return f'Citizen is {age} and not eligible for this and Will still not be eligible for next election with {age+election_timeline} years old'
        
citizen = eligibility(15,39144487,6)
print(citizen)
    