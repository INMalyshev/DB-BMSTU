\copy alpha.provider(provider_id, name, date_signing, rate, mail) from 'provider.csv' delimiter ';';
\copy alpha.client(client_id, name, date_birth, date_entry, total) from 'client.csv' delimiter ';';
\copy alpha.product(product_id, name) from 'product.csv' delimiter ';';
\copy alpha.position(position_id, name, cost_price, rate, date_update) from 'position.csv' delimiter ';';
\copy alpha.item(item_id, product_id, provider_id, amount, date_write_off, valuation) from 'item.csv' delimiter ';';
\copy alpha.item_position(item_position_id, item_id, position_id, amount) from 'item_position.csv' delimiter ';';
\copy alpha.event(event_id, client_id, position_id, bill_id, amount) from 'event.csv' delimiter ';';