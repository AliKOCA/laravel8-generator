--Kullanıcıları Oluştur
$ sudo su - postgres
$ psql

Create Role u_laravel8 with login CREATEDB CREATEROLE encrypted password 'Ail88*/&5$3a';

ALTER USER u_laravel8 SET timezone = 'Asia/Istanbul';

CREATE DATABASE db_laravel8 
        WITH OWNER u_laravel8
	TEMPLATE template0 
	ENCODING 'UTF-8' 
	LC_COLLATE 'tr_TR.UTF-8' 
	LC_CTYPE = 'tr_TR.UTF-8';

ALTER DATABASE db_laravel8 SET timezone TO 'Asia/Istanbul';

grant all privileges on database db_laravel8 to u_laravel8;

2.
\connect db_laravel8

/*Şemaları oluştur.*/
Create schema sch_laravel8;

ALTER SCHEMA sch_laravel8 OWNER TO u_laravel8;
ALTER ROLE u_laravel8 SET search_path = sch_laravel8;