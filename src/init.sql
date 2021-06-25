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

insert into Article values("2021-06-25 02:56:16.687000", "Hello World! 个人博客指北（持续更新中）", "cnhaox");
insert into Tag values("hello world", "2021-06-25 02:56:16.687000");
insert into Tag values("勿删勿改！", "2021-06-25 02:56:16.687000");
insert into Text values("2021-06-25 02:56:16.687000", '> 这是本项目的民间指北说明，收集了关于这个项目的方方面面，包括常见问题与使用教程。
> 
> 希望各位dalao们高抬贵手，**不要编辑改动删除这篇文章**Orz

## 这是什么？

这是一个个人博客网站项目，使用`HTML`+`CSS`+`JavaScript`+`Java/JSP`+`Tomcat`+`MySQL`实现，无框架，零添加，环保健康。三个小伙伴在7天内不眠不休、夜以继日，完成了这个《专业技术综合实践》的期末大作业。

## 这个博客有什么组合拳？

1. 支持浏览历史文章并对文章评论。也可对评论进行评论。~~如果有人评论你的话，会通过邮箱提醒噢~~(这个功能没做)；
2. 支持管理员发布、编辑和删除文章，文章支持使用图片、音乐、视频等多媒体元素。文章使用markdown文法进行编辑(这篇文章就是在网站上输入发表的)；
3. 文章带有标签。可通过选择标签来浏览不同类型的文章；
4. 博客带有文件管理功能。管理员可以上传、删除文件。游客可下载所需的文件；
5. 可以在About中了解博主的方方面面~博主也可以在About中编辑个人信息，留下联系方式噢~

## 这个博客的痛点在哪？

1. 功能完善，五脏俱全，完成度极高（大概）；
2. 界面美观，有大量动画效果，操作反馈感强（比如把鼠标移到头像，然后试着点击一下？）；
3. 文章显示对markdown语法进行了适配与优化，支持各类常用markdown语法的渲染；
4. 评论区可以盖楼（欢迎到文章底部盖楼~）；
5. 可以在Files页面上传下载喜欢的资源~

## markdown够赋能吗？

**Of Course!**

### 支持三级标题

#### 支持四级标题

##### 各种常见语法：

比如**加粗**, *斜体*, ***粗斜体***, ~~删除线~~, <u>下划线</u>, `代码片段`, 行内公式`$y=x^2$`，链接[百度](https://www.baidu.com)

##### 表格：

| 表头1 | 表头2 | 表头3 |
|:-|:-:|-:|
|   S0  |   S1  |   S2  |
|   S4  |   S5  |   S6  |

##### 引用：

> 引用也是支持的！

>> 无论是二级引用，

>>> 还是三级引用，

>>>> 甚至是四级引用，

>>>> 只要符号打的够多，

>>> 都可以统统满足,

> 实现嵌套引用！

##### 代码块：

```C
// 代码块也是支持的！比如这是C
int main()
{
    int a = 10, b=20;
    printf("hello world!");
    return 0;
}
```

```python
# 这是python
def main():
    for i in range(10):
        print("Hello World!")
if __name__==''__main__'':
    main()
```
##### 公式：

latex公式语法同样支持，可以写公式块！
```
$$
\\begin{align}
f(x)&=\\begin{cases}
\\sum\\limits_{i=1}^{x}i\\\\
\\frac{1}{\\sqrt{\\mathop{softmax}(x)}}\\\\
\\end{cases}\\\\
g(x)&=\\prod\\limits_{i=1}^{i=10}\\cos(\\pi^i)\\\\
h(x)&=\\int_{0}^{x}y \\text{d}y
\\end{align}
$$
```

##### 列表：

1. 列表同样小菜一碟~
    - 嵌套列表也是OK的！
        - 嵌套列表也是OK的！
    - 嵌套列表也是OK的！
2. 嵌套列表也是OK的！
    - 嵌套列表也是OK的！
        - 嵌套列表也是OK的！
    - 嵌套列表也是OK的！

##### 图片：

![图片](img/2021-06-25T025616.687000/bumen.jpg)

##### GIF：

<img src="img/2021-06-25T025616.687000/Grass_Wonder.GIF" alt="草上飞.gif">

##### 视频：

<div style="text-align: center;">
    <video width="480" height="360" controls>
        <source src="img/2021-06-25T025616.687000/video.mp4" type="video/mp4">
        浏览器版本太低，不支持该控件（摊手）
    </video>
</div>
***
<div style="text-align: center;">~一条华丽的分割线~</div>
***
##### 音乐：

<audio controls="controls" src="img/2021-06-25T025616.687000/卡农.mp3">浏览器版本太低，不支持该控件（摊手）</audio>

## 这个博客是否有抓手？

一些简单的教程：

+ 浏览器第一次打开这个博客网站时的任意网页，都会强制进入index.jsp，进行用户身份选择；
+ 游客只有查看博客内容、发表评论和下载文件的权限；管理员相比游客，额外拥有管理文章和文件、编辑个人信息权限；
+ 在使用markdown编辑文章的时候，公式输入与常规markdown语法略有不同。行内公式使用 \\`$公式$\\` 的方式输入；公式块使用\\`\\`\\`$$公式$$\\`\\`\\`的方式输入；
+ 在文章插入图片、音乐等多媒体资源时，先在文章编辑界面上传资源文件，然后使用文件对应显示的路径；

## 是否有使用Tips？

1. 点击头像可返回index.jsp；
2. 很多文本输入框都是可以拉长的哦~
3. 对于一些文章，博客板块显示可能有错位现象，这是因为JS异步执行引起的。刷新一下就可以恢复正常~
4. 可以通过tags快速定位自己想看的文章~
5. 修改了About里面的名字后，网站名字也会有所变化哦~

## To Do List?

~~大概率没时间做了~~
+ 增强安全性(这个博客几乎没啥安全防护功能，请dalao们谨慎测试 T_T )；
+ 增加密码修改的支持；
+ 增加更换背景图片和头像图片的支持；
+ 增加夜间主题；
+ 增加统计功能（如文章浏览量、访客数量等）；
+ 增加评论回复提醒（通过邮箱）；

## 考虑为开源社区做贡献吗？

![不给！](img/2021-06-25T025616.687000/special_week2.jpeg)

好吧，事实上，在本次课程结束后，~~lite版~~（并没有影射某个操作系统的意思）整个项目代码会在GitHub上开源。敬请期待。');
