drop user blogger_18308013;
drop database blog_18308045;

create database blog_18308045;
use blog_18308045;
create table Article
(
    ATime datetime(6),
	Title varchar(50),
	Author varchar(20),
	primary key(ATime)
);
create table Tag
(
	TName varchar(20),
    ATime datetime(6),
	foreign key(ATime) references Article(ATime) on delete cascade,
	primary key(TName, ATime)
);
create table Text
(
	ATime datetime(6),
	AContent longtext,
	foreign key(ATime) references Article(ATime) on delete cascade,
	primary key(ATime)
);
create table Comment
(
	CTime datetime(6),
	ATime datetime(6),
	CNickname varchar(20),
	CEmail varchar(50),
	CContent text,
    foreign key(ATime) references Article(ATime) on delete cascade,
	primary key(CTime, ATime)
);
create table Subcomment
(
	STime datetime(6),
	CTime datetime(6),
	ATime datetime(6),
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

# insert into Article values("2021-06-21T03:38:03.000001", "Title", "Author");
# insert into Text values("2021-06-21T03:38:03.000001", "## SubTitle1\n### SubTitle2\n![](img/pic.jpeg)\nContent Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content");
# insert into Tag values("Tag1", "2021-06-21T03:38:03.000001");
# insert into Tag values("Tag2", "2021-06-21T03:38:03.000001");
# insert into Comment values("2021-06-21T03:38:04.000001", "2021-06-21T03:38:03.000001", "Nickname1", "email1@qq.com", "Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content");
# insert into SubComment values("2021-06-21T03:38:05.000001", "2021-06-21T03:38:04.000001", "2021-06-21T03:38:03.000001", "Nickname1", "Nickname2", "email2@qq.com", "Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content");
