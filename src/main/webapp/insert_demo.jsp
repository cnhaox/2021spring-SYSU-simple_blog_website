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
            <form action = "insert.jsp" method = "post">
            	<!-- 重定位地址 -->
                <input name = "insert_demo.jsp" type = "hidden">
            	<!-- 失败重做次数 -->
                <input name = "100" type = "hidden">
            	<!-- 表名 -->
                <input name = "Article" type = "hidden">
            	<!-- 主键，时间属性 -->
                <input name = "datetime" value = "ATime" type = "hidden">
            	<!-- 表其他属性数量 -->
                <input name = "2" type = "hidden">
            	<!-- 普通属性 -->
                Title:<input name = "Title" type = "text"><br>
                Author:<input name = "Author" type = "text"><br>
            	<!-- 这个只是个按钮，不算属性 -->
                <input name = "insert" type = "submit" value = "insert">
            </form>
            <!-- 返回msg -->
            <%=request.getParameter("msg")%>
        </div>
    </body>
</html>
