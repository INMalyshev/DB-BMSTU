CREATE DATABASE IF NOT EXISTS restaurant;
CREATE SCHEMA IF NOT EXISTS alpha;


CREATE TABLE IF NOT EXISTS restaurant.alpha.Providers(
    ProviderId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ProviderName VARCHAR(200) NOT NULL,
    ProviderSigning DATE NOT NULL,
    ProviderRate INT NOT NULL DEFAULT -1,
    ProviderMail VARCHAR(100) NOT NULL
);


CREATE TABLE IF NOT EXISTS restaurant.alpha.Products(
    ProductId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ProductName VARCHAR(200) NOT NULL,
    ProductCount INT NOT NULL DEFAULT 0,
    ProductWriteOff DATE NOT NULL,
    ProductValuation INT NOT NULL DEFAULT 0,
    FOREIGN KEY (ProviderId) REFERENCES restaurant.alpha.Providers(ProviderId) 
);


CREATE TABLE IF NOT EXISTS restaurant.alpha.Drinks(
    DrinkId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    DrinkName VARCHAR(200) NOT NULL,
    DrinkCostPrice INT NOT NULL DEFAULT 0,
    DrinkWeekendsPrice INT NOT NULL DEFAULT 0,
    DrinkWeekdaysPrice INT NOT NULL DEFAULT 0
);


CREATE TABLE IF NOT EXISTS restaurant.alpha.Dishes(
    DishId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    DishName VARCHAR(200) NOT NULL,
    DishCostPrice INT NOT NULL DEFAULT 0,
    DishPrice INT NOT NULL DEFAULT 0,
    DishRate INT NOT NULL DEFAULT -1,
);


CREATE TABLE IF NOT EXISTS restaurant.alpha.Providers2Products(
    FOREIGN KEY (ProviderId) REFERENCES restaurant.alpha.Providers(ProviderId),
    FOREIGN KEY (ProductId) REFERENCES restaurant.alpha.Products(ProductId),
    Providers2ProductsPrice INT NOT NULL DEFAULT 0
);


CREATE TABLE IF NOT EXISTS restaurant.alpha.Products2Drinks(
    FOREIGN KEY (ProductId) REFERENCES restaurant.alpha.Products(ProductId),
    FOREIGN KEY (DrinkId) REFERENCES restaurant.alpha.Drinks(DrinkId),
    Products2DrinksCount INT NOT NULL DEFAULT 0
);


CREATE TABLE IF NOT EXISTS restaurant.alpha.Products2Dishes(
    FOREIGN KEY (ProductId) REFERENCES restaurant.alpha.Products(ProductId),
    FOREIGN KEY (DishId) REFERENCES restaurant.alpha.Dishes(DishId),
    Products2DishesCount INT NOT NULL DEFAULT 0
);


CREATE TABLE IF NOT EXISTS restaurant.alpha.History(
    HistoryId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    FOREIGN KEY (ProviderId) REFERENCES restaurant.alpha.Providers(ProviderId),
    FOREIGN KEY (ProductId) REFERENCES restaurant.alpha.Products(ProductId),
    HistoryCount INT NOT NULL DEFAULT 0,
    ProductValuation INT NOT NULL DEFAULT 0
);


CREATE TABLE IF NOT EXISTS restaurant.alpha.Clients(
    ClientId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ClientName VARCHAR(200) NOT NULL,
    ClientBirthDay DATE NOT NULL,
    ClientEntryDate DATE NOT NULL,
    ClientTotal INT NOT NULL DEFAULT 0
);

