create database blog;
use blog;
create table Article
(
	AID int,
	Title varchar(10),
	Author varchar(10),
	ATime datetime,
	primary key(AID)
);
create table Tag
(
	TID int,
	TName varchar(10),
	primary key(TID)
);
create table Text
(
	AID int,
	AContent longtext,
	foreign key(AID) references Article(AID),
	primary key(AID)
);
create table Comment
(
	CID int,
	Nickname varchar(10),
	Email varchar(10),
	CTime datetime,
	CContent text,
	primary key(CID)
);
create table File
(
	FName varchar(10),
	primary key(FName)
);
create table Article_Tag
(
	AID int,
	TID int,
	foreign key(AID) references Article(AID),
	foreign key(TID) references Tag(TID),
	primary key(AID, TID)
);
create table Article_Comment
(
	AID int,
	CID int,
	foreign key(AID) references Article(AID),
	foreign key(CID) references Comment(CID),
	primary key(AID, CID)
);
create table Comment_Comment
(
	C1ID int,
	C2ID int,
	foreign key(C1ID) references Comment(CID),
	foreign key(C2ID) references Comment(CID),
	primary key(C1ID, C2ID)
);
create user 'blogger'@'%' identified by '123';
grant all privileges on blog.* to blogger@'%' identified by '123';
flush  privileges;