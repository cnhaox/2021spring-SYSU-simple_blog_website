<!-- 时间属性用到的包 -->
<%@ page import="java.time.*"%>
<!DOCTYPE HTML>
<html>
    <head>
        <title>insert</title>
        <style>
        </style>
    </head>
    <body>
        <div class = "container">
            <h1>insert</h1>
            <form action = "insert.jsp" method = "post" name = "f">
            	<!-- 重定位地址 -->
                <input name = "insert_demo.jsp" type = "hidden">
            	<!-- 表名 -->
                <input name = "Article" type = "hidden">
            	<!-- 表属性数量 -->
                <input name = "4" type = "hidden">
            	<!-- 主键 -->
                AID:<input name = "AID" type = "text"><br>
            	<!-- 普通属性 -->
                Title:<input name = "Title" type = "text"><br>
                Author:<input name = "Author" type = "text"><br>
            	<!-- 时间属性 -->
                <input name = "ATime" value = <%=LocalDateTime.now()%> type = "hidden">
            	<!-- 这个只是个按钮，不算属性 -->
                <input name = "insert" type = "submit" value = "insert">
            </form>
            <!-- 返回msg -->
            <%=request.getParameter("msg")%>
        </div>
    </body>
</html>
