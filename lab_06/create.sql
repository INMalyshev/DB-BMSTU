CREATE DATABASE restaurant;

CREATE TABLE provider(
    provider_id                     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    name                            VARCHAR(200),
    date_signing                    DATE,
    rate                            INT,
    mail                            VARCHAR(100)
);

CREATE TABLE client(
    client_id                       INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    name                            VARCHAR(200),
    date_birth                      DATE,
    date_entry                      DATE,
    total                           INT
);

CREATE TABLE product(
    product_id                      INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    name                            VARCHAR(200)
);

CREATE TABLE position(
    position_id                     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    name                            VARCHAR(200),
    cost_price                      INT,
    rate                           INT,
    date_update                     DATE
);

CREATE TABLE item(
    item_id                         INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id                      INT,
    provider_id                     INT,

    amount                          INT,
    date_write_off                  DATE,
    valuation                       INT,

    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (provider_id) REFERENCES provider(provider_id) 
);

CREATE TABLE item_position(
    item_position_id                INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    item_id                         INT,
    position_id                     INT,

    amount                          INT,

    FOREIGN KEY (item_id) REFERENCES item(item_id),
    FOREIGN KEY (position_id) REFERENCES position(position_id)
);

CREATE TABLE event(
    event_id                        INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_id                       INT,
    position_id                     INT,
    bill_id                         INT,

    amount                          INT,

    FOREIGN KEY (client_id) REFERENCES client(client_id),
    FOREIGN KEY (position_id) REFERENCES position(position_id)
);
