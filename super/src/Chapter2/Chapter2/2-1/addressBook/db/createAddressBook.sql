create table addresses (
    id     int not null auto_increment,
    name varchar(20) not null,
    zipCode varchar(7) not null,
    address varchar(80) not null,
    created_on datetime not null,
    updated_on datetime not null,
    primary key (id));
create table user_details (
    id     int not null auto_increment,
    address_id  int not null,
    profile text not null,
    telNum  varchar(14) not null,
    constraint  fk_details  foreign key (address_id) references addresses(id),
    primary key (id));
create table mails(
    id   int not null auto_increment,
    mailAddress varchar(30) not null,
    address_id  int not null,
    constraint  fk_mails  foreign key (address_id) references addresses (id),
    primary key (id));
