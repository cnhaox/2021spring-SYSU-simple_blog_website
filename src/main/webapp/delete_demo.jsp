<!DOCTYPE HTML>
<html>
    <head>
        <title>delete</title>
        <style>
        </style>
    </head>
    <body>
        <div class = "container">
            <h1>delete</h1>
            <form action = "delete.jsp" method = "post">
            	<!-- 重定位地址 -->
                <input name = "delete_demo.jsp" type = "hidden">
            	<!-- 失败重做次数 -->
                <input name = "100" type = "hidden">
            	<!-- 表名 -->
                <input name = "Article" type = "hidden">
            	<!-- 主键 -->
                ATime:<input name = "ATime" type = "text"><br>
            	<!-- 这个只是个按钮，不算属性 -->
                <input name = "delete" type = "submit" value = "delete">
            </form>
            <!-- 返回msg -->
            <%=request.getParameter("msg")%>
        </div>
    </body>
</html>
