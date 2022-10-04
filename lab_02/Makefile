.PHONY : start load drop data clean

start :
	docker run --name my_test_pg -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres
	
connect :	
	psql -h 127.0.0.1 -U postgres -d postgres

drop :
	docker stop my_test_pg
	docker rm my_test_pg

data :
	python3 gen.py

clean :
	rm -rf ./*.csv
	