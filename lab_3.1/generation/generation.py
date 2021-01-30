import pandas as pd
import random
import string

def generate_phone():
    return(''.join(["{}".format(random.randint(0, 9)) for num in range(0, 10)]))

def generate_email():
    return(''.join(random.choice(string.ascii_letters) for x in range(8)) + "@gmail.com")

def generate_passengers(amount = 100):
    with open('names.txt', 'r') as f:
        names = f.readlines()
    with open('surnames.txt', 'r') as f:
        surnames = f.readlines()
    result = pd.DataFrame(columns=['passenger_id', 'name', 'surname', 'phone', 'e-mail', 'miles', 'amount_spent'])
    for i in range(amount):
        result.append({
            'passenger_id' : i+1,
            'name' : random.choice(names),
            'surname' : random.choice(surnames),
            'phone' : generate_phone(),
            'e-mail' : generate_email()
        }, ignore_index=True)

        print(result)
    print(result)
    result.to_csv('passengers.csv')

def generate_tickets(amount = 100):
    pass

def generate_cruises(amount = 100):
    pass

if __name__=='__main__':
    generate_passengers()