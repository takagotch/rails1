
drop database if exists rmind_dev ;
create database rmind_dev ;
grant all on rmind_dev.* to rmind@localhost identified by 'rmind' ;

drop database if exists rmind_test ;
create database rmind_test ;
grant all on rmind_test.* to rmind@localhost identified by 'rmind' ;

drop database if exists rmind ;
create database rmind ;
grant all on rmind.* to rmind@localhost identified by 'rmind' ;


