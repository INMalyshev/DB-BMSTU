.PHONY : start load drop data clean

start :
	docker pull thorinschiffer/postgres-plpython:12
	docker run --name my_test_pg -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=postgres -d thorinschiffer/postgres-plpython:12
	
connect :	
	psql -h 127.0.0.1 -U postgres -d postgres

drop :
	docker stop my_test_pg
	docker rm my_test_pg

data :
	python3 gen.py

clean :
	rm -rf ./*.csv
	
