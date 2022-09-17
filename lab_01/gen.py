import faker
import random


class Generator:
    def generate():
        return


class ProductsGenerator:
    def generate(self, n, filename='products.csv'):
        with open(filename, 'wt') as file:

            title = ''
            count = ''
            write_off = ''
            valuation = ''


class ProvidersGenerator:
    def __init__(self):
        self.faker = faker.Faker('ru_RU')

    def generate(self, n, filename='providers.csv'):
        with open(filename, 'wt') as file:
            curr = 1
            while curr <= n:
                name = f'company-{curr}'
                signing = self.faker.date()
                rate = random.randint(0, 100)
                mail = self.faker.ascii_company_email()
                
                file.write(f'{curr};{name};{signing};{rate};{mail}\n')
                curr += 1

p = ProvidersGenerator()
p.generate(1000)




