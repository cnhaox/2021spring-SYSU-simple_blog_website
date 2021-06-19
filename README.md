# simple-blog-website

## Database

### 实体

1. Article
    - AID
    - Title
    - Author
    - CTime
2. Tag
    - TID
    - TName
3. Text（弱实体）
    - AID
    - AContent
4. Comment
    - CID
    - Nickname
    - Email
    - CTime
    - CContent
5. File
    - FName

### 联系

1. Article_Tag
2. Article_Text
3. Article_Comment
4. Comment_Comment

### 表

1. Article
    - AID int,
    - Title varchar(10),
    - Author varchar(10),
    - ATime datetime,
    - primary key(AID)
2. Tag
    - TID int,
    - TName varchar(10),
    - primary key(TID)
3. Text
    - AID int,
    - CContent longtext,
    - foreign key(AID) references Article(AID),
    - primary key(AID)
4. Comment
    - CID int,
    - Nickname varchar(10),
    - Email varchar(10),
    - CTime datetime,
    - CContent text,
    - primary key(CID)
5. File
    - FName varchar(10),
    - primary key(FName)
6. Article_Tag
    - AID int,
    - TID int,
    - foreign key(AID) references Article(AID),
    - foreign key(TID) references Tag(TID),
    - primary key(AID, TID)
7. Article_Comment
    - AID int,
    - CID int,
    - foreign key(AID) references Article(AID),
    - foreign key(CID) references Comment(CID),
    - primary key(AID, CID)
8. Comment_Comment
    - C1ID int,
    - C2ID int,
    - foreign key(C1ID) references Comment(CID),
    - foreign key(C2ID) references Comment(CID),
    - primary key(C1ID, C2ID)
