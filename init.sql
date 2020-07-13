create database if not exists wenkudb;

use wenkudb;

create table if not exists hustusers(
    id int primary key auto_increment,
    emailadd  varchar(40) not  null unique,
    password varchar(20) not null,
    permissioncode tinyint default 1,
    remain tinyint default 3
);

create table if not exists hustsessions(
    emailadd varchar(40) not null primary key,
    sessionid varchar(100)  not null
);