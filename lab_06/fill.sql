\copy provider(provider_id, name, date_signing, rate, mail) from 'provider.csv' delimiter ';';
\copy client(client_id, name, date_birth, date_entry, total) from 'client.csv' delimiter ';';
\copy product(product_id, name) from 'product.csv' delimiter ';';
\copy position(position_id, name, cost_price, rate, date_update) from 'position.csv' delimiter ';';
\copy item(item_id, product_id, provider_id, amount, date_write_off, valuation) from 'item.csv' delimiter ';';
\copy item_position(item_position_id, item_id, position_id, amount) from 'item_position.csv' delimiter ';';
\copy event(event_id, client_id, position_id, bill_id, amount) from 'event.csv' delimiter ';';