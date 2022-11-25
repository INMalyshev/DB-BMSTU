import random
import psycopg2
from prettytable import PrettyTable, ALL
from tools import (
    bcolors,
    input_int_number
)


# ЗАДАНИЕ №1.
# Выполнить скалярный запрос
def task1(cursor, *params):
    print(f"\n{bcolors.BOLD}\t\t\t\t\t\t{bcolors.UNDERLINE}ЗАДАНИЕ №1{bcolors.ENDC}"
          f"\n{bcolors.BOLD}cкалярный запрос - по id клиента определить сумму выкупа{bcolors.ENDC}\n")

    id = input_int_number(f"{bcolors.OKCYAN}Введите id клиента{bcolors.ENDC} "
                                f"(или E, если хотите вернуться в меню): ",
                                f"id клиента был введен {bcolors.FAIL}неправильно{bcolors.ENDC}"
                                f" (должно быть целое число)\n")

    if id is None:
        return

    cursor.execute(
        "SELECT total FROM client WHERE client_id = %s;",
        (id,)
    )

    ans = cursor.fetchall()
    if not ans:
        print(f"Клиент с id {bcolors.OKCYAN}{id}{bcolors.ENDC} в базе {bcolors.OKCYAN}не найден{bcolors.ENDC}\n")
        return


    print(f"\n{bcolors.OKCYAN}Результат{bcolors.ENDC}\n"
          f"Сумма выкупа для клиента с id {bcolors.OKCYAN}{id}{bcolors.ENDC} равна {bcolors.OKCYAN}{ans[0][0]}{bcolors.ENDC}\n")


# ЗАДАНИЕ №2.
# Выполнить запрос с несколькими соединениями(JOIN)
def task2(cursor, *params):
    print(f"\n{bcolors.BOLD}\t\t\t\t\t\t{bcolors.UNDERLINE}ЗАДАНИЕ №2{bcolors.ENDC}"
          f"\n{bcolors.BOLD}соединения - по id позиции определить количество item-ов {bcolors.ENDC}\n")

    id = input_int_number(f"{bcolors.OKCYAN}Введите ID позиции{bcolors.ENDC} "
                                f"(или E, если хотите вернуться в меню): ",
                                f"ID был введен {bcolors.FAIL}неправильно{bcolors.ENDC}"
                                f" (должно быть целое число)\n")
    if id is None:
        return

    cursor.execute(
        " select p.position_id, p.name, count(ip.item_position_id)"
        " from position p join item_position ip on p.position_id = ip.position_id"
        " group by 1, 2"
        " having p.position_id = %s;", 
        (id, )
    )

    ans = cursor.fetchall()
    if not ans:
        print(f"позиции с ID {bcolors.OKCYAN}{id}{bcolors.ENDC} в базе {bcolors.OKCYAN}не найдено{bcolors.ENDC}\n")
        return

    print(f"{bcolors.OKCYAN}Результат{bcolors.ENDC}")
    tb = PrettyTable()
    tb.field_names = ["ID", 'Имя', 'Количество']
    tb.add_row(ans[0])
    print(tb, '\n')


# ЗАДАНИЕ №3.
# Выполнить запрос с ОТВ(CTE) и оконными функциями
def task3(cursor, *params):
    print(f"\n{bcolors.BOLD}\t\t\t\t\t\t\t\t  {bcolors.UNDERLINE}ЗАДАНИЕ №3{bcolors.ENDC}"
          f"\n{bcolors.BOLD}ОТВ и оконки{bcolors.ENDC}\n")

    cursor.execute(
        " select distinct "
            " bill_id,"
            " sum(amount) over (partition by bill_id),"
            " max(amount) over (partition by bill_id),"
            " min(amount) over (partition by bill_id)"
        " from" 
            " event"
        " limit"
            " 10;"
    )

    ans = cursor.fetchall()

    print(f"{bcolors.OKCYAN}Результат{bcolors.ENDC}")
    tb = PrettyTable()
    tb.field_names = ["bill id", 'bill sum', "max target", 'min target']
    for row in ans:
        tb.add_row(row)
    print(tb, '\n')


# ЗАДАНИЕ №4.
# Выполнить запрос к метаданным
def task4(cursor, *params):
    print(f"\n{bcolors.BOLD}\t\t\t\t\t{bcolors.UNDERLINE}ЗАДАНИЕ №4{bcolors.ENDC}"
          f"\n{bcolors.BOLD}метаданные - получить информацию о схемах в бд{bcolors.ENDC}\n")

    cursor.execute(
        "select * from information_schema.schemata inf "
        "where inf.schema_name not in ('information_schema', 'pg_catalog', 'pg_toast') "
        "order by inf.schema_name"
    )

    schemas_inf = list(map(lambda x: list(x[:3]), cursor.fetchall()))

    # print(schemas_inf)

    for i, schema in enumerate(schemas_inf):
        cursor.execute(
            "select inf.table_name "
            "from information_schema.tables inf "
            "where inf.table_schema = %s "
            "order by inf.table_name ",

            (schema[1], )
        )

        tables_inf = []
        for tpl in cursor.fetchall():
            tables_inf += [t for t in tpl]

        schemas_inf[i].append('\n'.join(tables_inf) if tables_inf else [])

    # print(schemas_inf)

    print(f"{bcolors.OKCYAN}Результат{bcolors.ENDC}")
    tb = PrettyTable()
    tb.hrules = ALL
    tb.field_names = ["БД", 'Схема', "Владелец", 'Список таблиц']
    for row in schemas_inf:
        tb.add_row(row)
    print(tb, '\n')


# ЗАДАНИЕ №5.
# Вызвать скалярную функцию из ЛР 3
def task5(cursor, *params):
    # Пример для ввода 4, 1, '2022-10-26'
    print(f"\n{bcolors.BOLD}\t\t\t\t\t  {bcolors.UNDERLINE}ЗАДАНИЕ №5{bcolors.ENDC}"
          f"\n{bcolors.BOLD}скалярная функция - имя клиента по id{bcolors.ENDC}\n")

    id = input_int_number(f"{bcolors.OKCYAN}Введите id клиента{bcolors.ENDC} "
                                f"(или E, если хотите вернуться в меню): ",
                                f"id клиента был введен {bcolors.FAIL}неправильно{bcolors.ENDC}"
                                f" (должно быть целое число)\n")

    if id is None:
        return

    cursor.execute(
        "select getClientName(%s)",
        (id,)
    )

    print(
        f"\n{bcolors.OKCYAN}Результат{bcolors.ENDC}\n"
        f"Имя клиента с ID {bcolors.OKCYAN}{id}{bcolors.ENDC} "
        f"--- {bcolors.OKCYAN}{cursor.fetchone()[0]}{bcolors.ENDC}\n ")


# ЗАДАНИЕ №6.
# Вызвать многооператорную или табличную функцию из ЛР 3
def task6(cursor, *params):
    # Пример для ввода 4, 1, '2022-10-26'
    print(f"\n{bcolors.BOLD}\t\t\t\t\t               {bcolors.UNDERLINE}ЗАДАНИЕ №6{bcolors.ENDC}"
          f"\n{bcolors.BOLD}табличная функция - основная информация о клиенте по id{bcolors.ENDC}\n")

    id = input_int_number(f"{bcolors.OKCYAN}Введите id клиента{bcolors.ENDC} "
                                f"(или E, если хотите вернуться в меню): ",
                                f"id клиента был введен {bcolors.FAIL}неправильно{bcolors.ENDC}"
                                f" (должно быть целое число)\n")

    if id is None:
        return

    cursor.execute(
        "select * from getClientInfo(%s)",
        (id,)
    )

    print(f"{bcolors.OKCYAN}Результат{bcolors.ENDC}")
    tb = PrettyTable()
    tb.field_names = ["id", "name", 'total']
    ans = cursor.fetchall()
    tb.add_row(list(ans[0]))

    print(tb, '\n')


# ЗАДАНИЕ №7.
# Вызвать хранимую процедуру из ЛР 3
def task7(cursor, *params):
    print(f"\n{bcolors.BOLD}\t\t\t\t\t{bcolors.UNDERLINE}ЗАДАНИЕ №7{bcolors.ENDC}"
          f"\n{bcolors.BOLD}хранимая процедура - увелчить total по id на фиксированную сумму{bcolors.ENDC}\n")

    id = input_int_number(f"{bcolors.OKCYAN}Введите id клиента{bcolors.ENDC} "
                                f"(или E, если хотите вернуться в меню): ",
                                f"id клиента был введен {bcolors.FAIL}неправильно{bcolors.ENDC}"
                                f" (должно быть целое число)\n")

    if id is None:
        return

    alpha = input_int_number(f"{bcolors.OKCYAN}Введите слагаемое{bcolors.ENDC} "
                                f"(или E, если хотите вернуться в меню): ",
                                f"слагаемое было введено {bcolors.FAIL}неправильно{bcolors.ENDC}"
                                f" (должно быть целое число)\n")

    if alpha is None:
        return

    print(f"\n{bcolors.OKCYAN}Сейчас в таблице{bcolors.ENDC}")

    cursor.execute(
            "select * from getClientInfo(%s)",
            (id,)
        )

    print(f"{bcolors.OKCYAN}Результат{bcolors.ENDC}")
    tb = PrettyTable()
    tb.field_names = ["id", "name", 'total']
    ans = cursor.fetchall()
    tb.add_row(list(ans[0]))
    print(tb, '\n')

    cursor.execute(
        "call addToClientTotal(%s, %s);",
        (alpha, id, )
    )

    connect = params[0]
    connect.commit()

    print(f"{bcolors.OKCYAN}Процедура выполнена{bcolors.ENDC}")

    cursor.execute(
            "select * from getClientInfo(%s)",
            (id,)
        )

    print(f"{bcolors.OKCYAN}Результат{bcolors.ENDC}")
    tb = PrettyTable()
    tb.field_names = ["id", "name", 'total']
    ans = cursor.fetchall()
    tb.add_row(list(ans[0]))
    print(tb, '\n')


# ЗАДАНИЕ №8.
# Вызвать системную функцию или процедуру
# https://postgrespro.ru/docs/postgrespro/10/functions-info
def task8(cursor, *params):
    print(f"\n{bcolors.BOLD}\t\t\t\t\t{bcolors.UNDERLINE}ЗАДАНИЕ №8{bcolors.ENDC}"
          f"\n{bcolors.BOLD}системные функции - получить имя бд и имя пользователя{bcolors.ENDC}\n")

    cursor.execute(
        "select current_database(), current_user;"
    )

    ans = cursor.fetchall()
    print(f"{bcolors.OKCYAN}Результат{bcolors.ENDC}")
    print(f"Имя текущей базы данных: {bcolors.OKCYAN}{ans[0][0]}{bcolors.ENDC}, "
          f"имя пользователя: {bcolors.OKCYAN}{ans[0][1]}{bcolors.ENDC}\n")


# ЗАДАНИЕ №9.
# Создать таблицу в базе данных, соответствующую тематике БД
def task9(cursor, *params):
    print(f"\n{bcolors.BOLD}\t\t\t\t\t{bcolors.UNDERLINE}ЗАДАНИЕ №9{bcolors.ENDC}"
          f"\n{bcolors.BOLD}создать таблицу - таблица жалоб и предложений {bcolors.ENDC}\n")

    cursor.execute(
        "create table if not exists client_info("
        "   client_info_id serial primary key,"
        "   name varchar(200),"
        "   total int"
        ")"
    )

    connect = params[0]
    connect.commit()

    print(f"{bcolors.OKCYAN}Таблица успешно создана{bcolors.ENDC}\n")


# ЗАДАНИЕ №10.
# Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT или COPY
def task10(cursor, *params):
    connect = params[0]

    try:
        cursor.execute("select * from client_info;")
    except:
        print(f'{bcolors.WARNING}Сначала создайте таблицу!!! (Пункт 9){bcolors.ENDC}\n')
        connect.commit()
        return

    print(f"\n{bcolors.BOLD}\t\t\t\t\t{bcolors.UNDERLINE}ЗАДАНИЕ №10{bcolors.ENDC}"
          f"\n{bcolors.BOLD}вставить данные в созданную таблицу {bcolors.ENDC}\n")

    cursor.execute(
        "select name, total from client order by name limit 10;"
    )

    unique_mat_id = []
    for tpl in cursor.fetchall():
        unique_mat_id.append( [t for t in tpl])

    # Почистить таблицу перед вставкой
    cursor.execute(
        "delete from client_info; "
        "ALTER SEQUENCE client_info_client_info_id_seq RESTART WITH 1;"
    )

    n = 10
    for i in range(n):
        cursor.execute(
            "insert into client_info(name, total) "
            "values (%s, %s)",

            (unique_mat_id[i][0], unique_mat_id[i][1], )
        )

    connect.commit()
    print(f'{bcolors.OKCYAN}Данные успешно загружены{bcolors.ENDC}\n')

    cursor.execute(
        "select * from client_info"
    )

    tb = PrettyTable()
    tb.field_names = ["ID", 'name', 'total']
    for row in cursor.fetchall():
        tb.add_row(row)
    print(tb, '\n')


LIST_TASKS = [task1, task2, task3, task4, task5, task6, task7, task8, task9, task10]