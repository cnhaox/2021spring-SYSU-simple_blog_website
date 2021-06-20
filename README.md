# simple-blog-website

## 部署

/src/init.sql

## 数据库

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
    - AContent longtext,
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

### 统一接口

#### 说明

1. 未实现select的统一接口，因为select操作不太统一。
2. insert所有属性（包括主键）顺序可调换。
3. update按照主键值搜索，更新任意指定属性（主键外属性顺序可调换）。
4. delete按照主键值搜索，删除。
5. 部分datetime类型属性需要使用以下包。

    ```jsp
    <!-- 时间属性用到的包 -->
    <%@ page import="java.time.*"%>
    ```

6. 完整示例代码见insert_demo.jsp，update_demo.jsp，delete_demo.jsp。

#### 使用样例

1. insert.jsp

    ```jsp
    <form action = "insert.jsp" method = "post" name = "f">
        <!-- 重定位地址 -->
        <input name = "insert_demo.jsp" type = "hidden">
        <!-- 表名 -->
        <input name = "Article" type = "hidden">
        <!-- 表属性数量 -->
        <input name = "4" type = "hidden">
        <!-- 主键和普通属性 -->
        AID:<input name = "AID" type = "text"><br>
        Title:<input name = "Title" type = "text"><br>
        Author:<input name = "Author" type = "text"><br>
        <!-- 时间属性 -->
        <input name = "ATime" value = <%=LocalDateTime.now()%> type = "hidden">
        <!-- 这个只是个按钮，不算属性 -->
        <input name = "insert" type = "submit" value = "insert">
    </form>
    <!-- 返回msg -->
    <%=request.getParameter("msg")%>
    ```

2. update.jsp

    ```jsp
    <form action = "update.jsp" method = "post" name = "f">
        <!-- 重定位地址 -->
        <input name = "update_demo.jsp" type = "hidden">
        <!-- 表名 -->
        <input name = "Article" type = "hidden">
        <!-- 主键 -->
        AID:<input name = "AID" type = "text"><br>
        <!-- 需要更新的属性数量 -->
        <input name = "2" type = "hidden">
        <!-- 普通属性 -->
        Title:<input name = "Title" type = "text"><br>
        <!-- 时间属性 -->
        <input name = "ATime" value = <%=LocalDateTime.now()%> type = "hidden">
        <!-- 这个只是个按钮，不算属性 -->
        <input name = "update" type = "submit" value = "update">
    </form>
    <!-- 返回msg -->
    <%=request.getParameter("msg")%>
    ```

3. delete.jsp

    ```jsp
    <form action = "delete.jsp" method = "post" name = "f">
    <!-- 重定位地址 -->
    <input name = "delete_demo.jsp" type = "hidden">
    <!-- 表名 -->
    <input name = "Article" type = "hidden">
    <!-- 主键 -->
    AID:<input name = "AID" type = "text"><br>
    <!-- 这个只是个按钮，不算属性 -->
    <input name = "delete" type = "submit" value = "delete">
    </form>
    <!-- 返回msg -->
    <%=request.getParameter("msg")%>
    ```
