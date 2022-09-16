CREATE DATABASE restaurant;
CREATE SCHEMA alpha;

DROP TABLE IF EXISTS alpha.Providers;
CREATE TABLE IF NOT EXISTS alpha.Providers(
    ProviderId INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ProviderName VARCHAR(200) NOT NULL,
    ProviderSigning DATE NOT NULL,
    ProviderRate INT NOT NULL DEFAULT -1,
    ProviderMail VARCHAR(100) NOT NULL
);

\copy alpha.Providers(ProviderId, ProviderName, ProviderSigning, ProviderRate, ProviderMail) from '/home/ilya/Documents/DB-BMSTU/lab_01/providers.csv' delimiter ';';
select * from alpha.Providers
