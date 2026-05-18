# BigDataTrino
Инструкция:

1. ```git clone https://github.com/Ecodrin/BigDataTrino.git ```

2. ```docker compose up -d```

3. Чтобы запустить все trino скрипты: ```./scripts/run_all.sh``` 
    
    a. Чтобы запустить скрипт перевода в схему звезда: ```./scripts/to_dwh.sh ```
    
    b.Чтобы запустить скрипт генерации отчетов: ```./scripts/to_reports.sh```

4. Параметры подключения DBeaver: 
    
    a. postgres: user: ```postgres```, password: ```123```, БД: ```postgres```, host: ```localhost```,port: ```5432``` 
    
    b. clickhouse: user: ```default```, password: ```123```, БД: ```reports```, host: ```localhost```,port: ```8123```

Отчеты:
1. ```reports.products``` --- ТОП продаваемых продуктов.
2. ```reports.customers``` --- средний чек для каждого клиента.
3. ```reports.month_sale``` --- средний размер заказа по месяцем(сумма и количество).
4. ```reports.store``` --- средний чек для каждого магазина.
5. ```reports.country_supplier``` --- распределение продаж по странам поставщиков.
6. ```reports.product_reviews``` --- ТОП продуктов с наибольшим количеством отзывов. 




![Лабораторная работа №4](https://github.com/user-attachments/assets/8cde5065-780b-46c3-867f-5d4332b42e28)
