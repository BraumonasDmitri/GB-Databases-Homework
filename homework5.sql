DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;
DESCRIBE vk;
CREATE TABLE users; (
  created_at VARCHAR NULL, 
  updated_at VARCHAR NULL
) ENGINE=InnoDB;

USE TABLE users;

-- Практическое задание теме “Операторы, фильтрация, сортировка и ограничение”
-- 1) Пусть в таблице users поля created_at и updated_at оказались незаполненными. 
-- Заполните их текущими датой и временем.

UPDATE users SET created_at = NOW(), updated_at = NOW() WHERE created_at is NULL or updated_at is NULL;

-- 2) Таблица users была неудачно спроектирована. 
-- Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". 
-- Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.

UPDATE users SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i'); 
UPDATE users SET updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');
ALTER TABLE users MODIFY created_at DATETIME DEFAULT CURRENT_TIMESTAMP; 
ALTER TABLE users MODIFY updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- 3) В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. 
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
-- Однако нулевые запасы должны выводиться в конце, после всех записей.

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
id SERIAL PRIMARY KEY,
    storehouse_id INT unsigned,
    product_id INT unsigned,
    `value` INT unsigned COMMENT 'Запас на складе',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
); 

USE storehouses_products;
INSERT INTO
    storehouses_products (storehouse_id, product_id, value)
VALUES
    (1, 1, 15),
    (1, 3, 0),
    (1, 5, 10),
    (1, 7, 5),
    (1, 8, 0);

SELECT value FROM storehouses_products; 
ORDER BY CASE WHEN value = 0 then 1 else 0 end, value;


   CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(145) NOT NULL,
  `last_name` varchar(145) NOT NULL,
  `email` varchar(145) NOT NULL,
  `phone` varchar(11) NOT NULL,
  `password_hash` char(65) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_unique` (`email`),
  UNIQUE KEY `phone_unique` (`phone`),
  CONSTRAINT `phone_check` CHECK (regexp_like(`phone`,_utf8mb4'^[0-9]{11}$'))
) ENGINE=InnoDB;
 
USE users;

-- Практическое задание теме “Агрегация данных”
-- 1) Подсчитайте средний возраст пользователей в таблице users:

ALTER TABLE users ADD age INT NOT NULL;

UPDATE users SET age = TIMESTAMPDIFF(YEAR, birthday_at, NOW());

SELECT AVG(age) FROM users;

-- 2) Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.
SELECT COUNT(*) as stats from (SELECT DAYOFWEEK(CONCAT(YEAR(NOW()),'-',MONTH(birthday),'-',DAYOFMONTH(birthday))) as date from profiles) as stats where date=1;
-- где date=1 для понедельника, date=2 для вторника и т.д

-- 3) Подсчитайте произведение чисел в столбце таблицы
SELECT EXP(sum(log(value))) from table;