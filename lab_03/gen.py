from itertools import count
import faker
import random

def make_provider_csv(filename='provider.csv', amount=1000):
    fk = faker.Faker()

    with open(filename, 'wt') as file:
        curr = 1

        while curr <= amount:
            name = f'company-{curr}'
            signing = fk.date()
            rate = random.randint(0, 100)
            mail = fk.ascii_company_email()
            
            file.write(f'{curr};{name};{signing};{rate};{mail}\n')
            curr += 1

def make_product_csv(filename='product.csv', amount=1000):
    with open(filename, 'wt') as file:
        curr = 1

        while curr <= amount:
            name = f'product-{curr}'
            
            file.write(f'{curr};{name}\n')
            curr += 1


def make_item_csv(filename='item.csv', amount=10000):
    fk = faker.Faker()
    with open(filename, 'wt') as file:
        curr = 1
        while curr <= amount:
            product_id = random.randint(1, 1000)
            provider_id = random.randint(1, 1000)
            count = random.randint(1, 10000)
            writeOff = fk.date()
            valuation = random.randint(1000, 1000000)
            
            file.write(f'{curr};{product_id};{provider_id};{count};{writeOff};{valuation}\n')
            curr += 1


def make_position_csv(filename='position.csv', amount=1000):
    with open(filename, 'wt') as file:
        fk = faker.Faker()
        curr = 1
        while curr <= amount:
            name = f'position-{random.randint(1, 1000)}'
            costPrice = random.randint(20, 200)
            rate = random.randint(1, 100)
            date_update = fk.date()
            
            file.write(f'{curr};{name};{costPrice};{rate};{date_update}\n')
            curr += 1


def make_client_csv(filename='client.csv', amount=1000):
    fk = faker.Faker()
    with open(filename, 'wt') as file:
        curr = 1
        while curr <= amount:
            name = fk.name()
            birthDay = fk.date()
            entryDay = fk.date()
            total = random.randint(300, 2000000)
            
            file.write(f'{curr};{name};{birthDay};{entryDay};{total}\n')
            curr += 1


def make_event_csv(filename='event.csv', amount=100000):
        with open(filename, 'wt') as file:
            curr = 1
            while curr <= amount:
                clientID = random.randint(1, 1000)
                position_id = random.randint(1, 1000)
                billID = random.randint(1, 1000)
                count = random.randint(1, 100)
                
                file.write(f'{curr};{clientID};{position_id};{billID};{count}\n')
                curr += 1


def make_item_position_csv(filename='item_position.csv', amount=1000):
    with open(filename, 'wt') as file:
        cccc = 1
        curr = 1
        while curr <= amount:
            for _ in range(random.randint(1, 10)):
                item_id = random.randint(1, 1000)
                count = random.randint(1, 100)
                
                file.write(f'{cccc};{item_id};{curr};{count}\n')
                cccc += 1
            curr += 1


make_provider_csv()
make_client_csv()
make_product_csv()
make_item_position_csv()
make_position_csv()
make_item_csv()
make_event_csv()




