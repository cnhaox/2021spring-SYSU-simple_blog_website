drop user user;
drop database blog_18308045;

create database blog_18308045;
use blog_18308045;
set character_set_client=utf8;
set character_set_connection=utf8;
set character_set_results=utf8;
set global max_allowed_packet=1073741824;

create table Article
(
    ATime datetime(6),
	Title varchar(50),
	Author varchar(50),
	primary key(ATime)
);
create table Tag
(
	TName varchar(50),
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
	CNickname varchar(50),
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
    Target varchar(50),
	SNickname varchar(50),
	SEmail varchar(50),
	SContent text,
    foreign key(CTime) references Comment(CTime) on delete cascade,
    foreign key(ATime) references Article(ATime) on delete cascade,
    primary key(STime, CTime, ATime)
);
create user 'user'@'%' identified by '123';
grant all privileges on blog_18308045.* to 'user'@'%' identified by '123';
flush  privileges;

insert into Article values("2021-06-23 17:04:55.366467", "数电实验13", "作者的名字，是什么？");
insert into Tag values("hello world", "2021-06-23 17:04:55.366467");
insert into Tag values("数电实验", "2021-06-23 17:04:55.366467");
insert into Comment values("2021-06-23 17:04:56", "2021-06-23 17:04:55.366467", "助教A", "A@助教.com", "你做得好啊！");
insert into Text values("2021-06-23 17:04:55.366467", '# 实验12

## 有效的余三码

0011
0100
0101
0110
0111
1000
1001
1010
1011
1100

## DFA

暂时不支持mermaid语法。。。

```
graph TD
S0((S0))
S1((S1))
S2((S2))
S3((S3))
S4((S4))
S5((S5))
S6((S6))
S7((S7))
S8((S8))
S9((S9))
S10((S10))
S11((S11))
S12((S12))
S13((S13))
S14((S14))
S15((S0))
S16((S0))
S17((S0))
S18((S0))
S19((S0))
S20((S0))
S21((S0))
S22((S0))
S23((S0))
S24((S0))
S25((S0))
S26((S0))
S27((S0))
S28((S0))
S29((S0))
S30((S0))
S0--0/0-->S1
S0--1/0-->S2
S1--0/0-->S3
S1--1/0-->S4
S2--0/0-->S5
S2--1/0-->S6
S3--0/0-->S7
S3--1/0-->S8
S4--0/0-->S9
S4--1/0-->S10
S5--0/0-->S11
S5--1/0-->S12
S6--0/0-->S13
S6--1/0-->S14
S7--0/1-->S15
S7--1/0-->S16
S8--0/1-->S17
S8--1/0-->S18
S9--0/1-->S19
S9--1/0-->S20
S10--0/0-->S21
S10--1/1-->S22
S11--0/0-->S23
S11--1/0-->S24
S12--0/0-->S25
S12--1/1-->S26
S13--0/0-->S27
S13--1/0-->S28
S14--0/0-->S29
S14--1/1-->S30
```

|   |0    |1    |
|---|-----|-----|
|S0 |S1 /0|S2 /0|
|S1 |S3 /0|S4 /0|
|S2 |S5 /0|S6 /0|
|S3 |S7 /0|S8 /0|
|S4 |S9 /0|S10/0|
|S5 |S11/0|S12/0|
|S6 |S13/0|S14/0|
|S7 |S0 /1|S0 /0|
|S8 |S0 /1|S0 /0|
|S9 |S0 /1|S0 /0|
|S10|S0 /0|S0 /1|
|S11|S0 /0|S0 /0|
|S12|S0 /0|S0 /1|
|S13|S0 /0|S0 /0|
|S14|S0 /0|S0 /1|

## Minimal DFA

|   |0    |1    |
|---|-----|-----|
|S0 |S1 /0|S2 /0|
|S1 |S3 /0|S4 /0|
|S2 |S5 /0|S5 /0|
|S3 |S7 /0|S7 /0|
|S4 |S7 /0|S10/0|
|S5 |S11/0|S10/0|
|S7 |S0 /1|S0 /0|
|S10|S0 /0|S0 /1|
|S11|S0 /0|S0 /0|

## 真值表

|32\\\\10|00 |01|11|10 |
|------|---|--|--|---|
|00    |S0 |S1|S2|S3 |
|01    |S4 |S5|S7|S10|
|11    |S11|X |X |X  |
|10    |X  |X |X |X  |

|X32\\\\10|00    |01    |11    |10    |
|-------|------|------|------|------|
|000    |0001/0|0010/0|0101/0|0111/0|
|001    |0111/0|1100/0|0000/1|0000/0|
|011    |0000/0|XXXX/X|XXXX/X|XXXX/X|
|010    |XXXX/X|XXXX/X|XXXX/X|XXXX/X|
|110    |XXXX/X|XXXX/X|XXXX/X|XXXX/X|
|111    |0000/0|XXXX/X|XXXX/X|XXXX/X|
|101    |0110/0|0110/0|0000/0|0000/1|
|100    |0011/0|0100/0|0101/0|0111/0|

## 表达式

```
$$
\\begin{aligned}
    \\because&\\begin{cases}
        Q_3&=\\overline X\\cdot Q_2\\cdot\\overline{Q_1}\\cdot Q_0\\\\
        Q_2&=\\overline{Q_3}\\cdot Q_2\\cdot\\overline{Q_1}+X\\cdot \\overline{Q_1}\\cdot Q_0+\\overline{Q_2}\\cdot Q_1\\\\
        Q_1&=\\overline{Q_3}\\cdot Q_2\\cdot\\overline{Q_1}\\cdot\\overline{Q_0}+X\\cdot\\overline{Q_2}\\cdot\\overline{Q_0}+\\overline X\\cdot\\overline{Q_2}\\cdot\\overline{Q_1}\\cdot Q_0\\\\
        &+X\\cdot\\overline{Q_3}\\cdot Q_2\\cdot\\overline{Q_1}+\\overline{Q_2}\\cdot Q_1\\cdot\\overline{Q_0}\\\\
        Q_0&=\\overline{Q_2}\\cdot\\overline{Q_0}+\\overline X\\cdot\\overline{Q_3}\\cdot\\overline{Q_1}\\cdot\\overline{Q_0}+\\overline{Q_2}\\cdot Q_1\\\\
        F&=\\overline X\\cdot Q_2\\cdot Q_1\\cdot Q_0+X\\cdot Q_2\\cdot Q_1\\cdot\\overline{Q_0}
    \\end{cases}\\\\
    \\because&Q=J\\cdot\\overline Q+\\overline K\\cdot Q\\\\
    \\therefore&\\begin{cases}
        D_3&=\\overline X\\cdot Q_2\\cdot\\overline{Q_1}\\cdot Q_0\\\\
        &=\\overline{(\\overline{Q_0}+X)+\\overline{Q_2}+Q_1}\\\\
        J_2&=X\\cdot\\overline{Q_1}\\cdot Q_0+Q_1\\\\
        K_2&=\\overline{X\\cdot\\overline{Q_1}\\cdot Q_0+\\overline{Q_3}\\cdot\\overline{Q_1}}\\\\
        J_1&=X\\cdot\\overline{Q_2}\\cdot\\overline{Q_0}+\\overline{Q_3}\\cdot Q_2\\cdot\\overline{Q_0}+\\overline X\\cdot\\overline{Q_2}\\cdot Q_0+X\\cdot\\overline{Q_3}\\cdot Q_2\\\\
        &=\\overline{Q_2}\\cdot(X\\oplus Q_0)+\\overline{Q_3}\\cdot Q_2\\cdot(\\overline{Q_0}+X)\\\\
        K_1&=\\overline{X\\cdot\\overline{Q_2}\\cdot\\overline{Q_0}+\\overline{Q_2}\\cdot\\overline{Q_0}}\\\\
        &=Q_2+Q_0\\\\
        J_0&=\\overline{Q_2}+\\overline X\\cdot\\overline{Q_3}\\cdot\\overline{Q_1}+\\overline{Q_2}\\cdot Q_1\\\\
        &=\\overline{Q_2}+\\overline{X+Q_3+Q_1}\\\\
        K_0&=\\overline{\\overline{Q_2}\\cdot Q_1}\\\\
        &=Q_2+\\overline{Q_1}\\\\
        D_F&=\\overline X\\cdot Q_2\\cdot Q_1\\cdot Q_0+X\\cdot Q_2\\cdot Q_1\\cdot\\overline{Q_0}\\\\
        &=Q_2\\cdot Q_1\\cdot(X\\oplus Q_0)
    \\end{cases}
\\end{aligned}
$$
```

## 电路图

![电路图](img/2021-06-23T170455.366467/电路图.png)

## 结果

测试了0000，1111，0101：

<video width=''320'' height=''240'' controls>
  <source src=''img/2021-06-23T170455.366467/演示视频.webm'' type=''video/webm''>
您的浏览器不支持Video标签。
</video>');
