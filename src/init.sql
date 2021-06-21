drop user blogger_18308013;
drop database blog_18308045;

create database blog_18308045;
use blog_18308045;
create table Article
(
    ATime datetime,
	Title varchar(50),
	Author varchar(20),
	primary key(ATime)
);
create table Tag
(
	TName varchar(20),
    ATime datetime,
	foreign key(ATime) references Article(ATime) on delete cascade,
	primary key(TName, ATime)
);
create table Text
(
	ATime datetime,
	AContent longtext,
	foreign key(ATime) references Article(ATime) on delete cascade,
	primary key(ATime)
);
create table Comment
(
	CTime datetime,
	ATime datetime,
	CNickname varchar(20),
	CEmail varchar(50),
	CContent text,
    foreign key(ATime) references Article(ATime) on delete cascade,
	primary key(CTime, ATime)
);
create table Subcomment
(
	STime datetime,
	CTime datetime,
	ATime datetime,
    Target varchar(20),
	SNickname varchar(20),
	SEmail varchar(50),
	SContent text,
    foreign key(CTime) references Comment(CTime) on delete cascade,
    foreign key(ATime) references Article(ATime) on delete cascade,
    primary key(STime, CTime, ATime)
);
create user 'blogger_18308013'@'%' identified by '18340197';
grant all privileges on blog_18308045.* to blogger_18308013@'%' identified by '18340197';
flush  privileges;

insert into Article values("2021-06-21 03:38:03", "Title", "Author");
insert into Text values("2021-06-21 03:38:03", "## SubTitle1\n### SubTitle2\n![](img/pic.jpeg)\nContent Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content");
insert into Tag values("Tag1", "2021-06-21 03:38:03");
insert into Tag values("Tag2", "2021-06-21 03:38:03");
insert into Comment values("2021-06-21 03:38:04", "2021-06-21 03:38:03", "Nickname1", "email1@qq.com", "Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content");
insert into SubComment values("2021-06-21 03:38:05", "2021-06-21 03:38:04", "2021-06-21 03:38:03", "Nickname1", "Nickname2", "email2@qq.com", "Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content");
