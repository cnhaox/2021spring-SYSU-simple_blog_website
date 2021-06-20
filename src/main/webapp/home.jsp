<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%
    String msg ="";
    String title_list1 = "";
    String title_list2 = "";
    String connectString = "jdbc:mysql://localhost:3306/blog_18308045?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
    String user = "blogger_18308013";
    String pwd = "18340197";
    request.setCharacterEncoding("utf-8");
    try
    {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(connectString, user, pwd);
        Statement stmt = con.createStatement();
        String title = request.getParameter("title");
        String sql = "select * from Article, Text where Article.ATime=Text.ATime";
        if (title != null)
        {
            sql += "like%" + title + "%";
        }
        ResultSet rs = stmt.executeQuery(sql);
        while(rs.next())
        {
            String ATime = rs.getString("ATime");
            title_list1 += "<div class='titleBlockDiv' onclick=\"openWebpage('article.jsp?ATime=" + ATime + "')\">\n";
            title_list1 += "    <div class='titleBlock'>\n";
            title_list1 += "        <h2>" + rs.getString("Title") + "</h2>\n";
            title_list1 += "        <p class=titleMessage>@" + rs.getString("Author") + "&nbsp;|&nbsp;" + rs.getString("ATime") + "</p>\n";
            title_list1 += "    </div>\n";
            title_list1 += "    <div class='contentBlock'>\n";
            title_list1 += "        <p id='titleContent" + ATime + "' class='titleContent'></p>\n";
            title_list1 += "        <script>\n";
            title_list1 += "            var abstract = marked(`" + rs.getString("AContent") + "`);\n";
            title_list1 += "            abstract = abstract.replaceAll(/<[^>]+>/g, '').replaceAll(/\\n/g, ' ').slice(0, 100) + '&hellip;';\n";
            title_list1 += "            document.getElementById('titleContent" + ATime + "').innerHTML = abstract;\n";
            title_list1 += "        </script>\n";
            title_list1 += "    </div>\n";
            title_list1 += "    <footer>Read More >></footer>\n";
            title_list1 += "</div>\n";
            title_list2 += "<tr>\n";
            title_list2 += "    <td>" + rs.getString("Title") + "</td>\n";
            title_list2 += "    <td>" + rs.getString("ATime") + "</td>\n";
            title_list2 += "    <td>\n";
            title_list2 += "        <form action='edit.jsp' method='post'>\n";
            title_list2 += "            <input name='ATime' type='hidden' value='" + ATime + "'>\n";
            title_list2 += "            <input type='submit' class='editButton' name='edit' value='编&nbsp;&nbsp;辑'>\n";
            title_list2 += "        </form> \n";
            title_list2 += "        <form action='delete.jsp' method='post' onsubmit='return checkDelete(this)'>\n";
            title_list2 += "            <input name='home.jsp' type='hidden'>\n";
            title_list2 += "            <input name = '100' type = 'hidden'>\n";
            title_list2 += "            <input name='Article' type='hidden'>\n";
            title_list2 += "            <input name='ATime' type='hidden' value='" + ATime + "'>\n";
            title_list2 += "            <input type='submit' class='deleteButton' name='delete' value='删&nbsp;&nbsp;除'>\n";
            title_list2 += "        </form>\n";
            title_list2 += "    </td>\n";
            title_list2 += "</tr>\n";
        }
        rs.close();
        stmt.close();
        con.close();
    }
    catch (Exception e)
    {
        msg = e.getMessage();
    }
%>
<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>个人博客</title>
        <link rel="stylesheet" type="text/css" href="css/general.css" />
        <link rel="stylesheet" type="text/css" href="font-awesome/css/font-awesome.css" />
        <style>
            .menuChecked {
                top: 0px;
            }
            .menuChecked .menu {
                top: -0px;
            }
            .manage {
                float: right;
                position: relative;
            }
            .manageButton {
                margin: 10px 5px;
                width: 50px;
                height: 30px;
                border: none;
                background-color: rgba(57,165,247,1);
                color: white;
                cursor: pointer;
            }
            .manageButton:hover {
                box-shadow: inset 0px 0px 3px rgba(0,0,0,0.4);
            }
            .titleListDiv {
                position: relative;
                margin: 100px 50px;
            }
            .titleList {
                position: relative;
                padding: 0px 10px;
            }
            .titleBlockDiv {
                position: relative;
                width: 100%;
                padding: 5px;
                overflow: hidden;
            }
            .contentBlock {
                height: 0px;
                width: 100%;
                overflow: hidden;
                transition: all 1s;
            }
            .titleBlockDiv:hover {
                box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.3);
                background-color: rgba(0,0,0,0.1);
            }
            .titleBlockDiv:hover .contentBlock {
                height: 100px;
            }
            .titleMessage {
                color: grey;
                font-size: small;
            }
            .titleContent {
                color:rgba(0, 0, 0, 0.7);
            }
            footer {
                float:right;
                font-size: small;
                color: blue;
            }/*
            #prevLink {
                float:left;
            }
            #nextLink {
                float: right;
            }
            .pageButton {
                margin: 10px 5px;
                width: 70px;
                height: 30px;
                border: none;
                background-color: rgba(57,165,247,0.8);
                color: white;
                cursor: pointer;
            }
            .pageButton:hover {
                box-shadow: inset 0px 0px 3px rgba(0,0,0,0.4);
            }*/
            #titleList2 {
                display:none;
            }
            
        </style>
        <script src="./js/marked.min.js"></script>
    </head>
    <body>
        <div id="leftPart">
            <div id="nameContainer">
                <div id="headPortraitContainer">
                    <div id="headPortrait"></div>
                </div>
                <div id="blogName">
                    <h2>XX的个人博客</h2>
                </div>
            </div>
            <div id="menuContainer">
                <ul class="menu">
                    <li>Home</li>
                    <li>Tags</li>
                    <li>Files</li>
                    <li>About</li>
                </ul>
                <!-- 用来代表原本菜单中的三个选项（li元素） -->
                <div class="menuHover menuHover1" onclick="openWebpage('home.html')"></div>
                <div class="menuHover menuHover2" onclick="openWebpage('tags.html')"></div>
                <div class="menuHover menuHover3" onclick="openWebpage('files.html')"></div>
                <div class="menuHover menuHover4" onclick="openWebpage('about.html')"></div>
                <div class="menuChecked"">
                    <ul class="menu">
                        <li>Home</li>
                        <li>Tags</li>
                        <li>Files</li>
                        <li>About</li>
                    </ul>
                </div>
            </div>
           
        </div>
        <div id="mainPart">
            <div class="titleListDiv">
                <div class="search">
                    <form action="" method="post">
                        <i class="fa fa-search" aria-hidden="true"></i>
                        <input type="text" name="condition" placeholder="Searching...">
                        <input type="submit" name="search" value="搜索">
                    </form> 
                </div>
                <div style="clear:both"></div>
                <h1>文章</h1>
                <div class="titleList" id="titleList1">
                    <div class="manage">
                        <input type="button" class="manageButton" onclick="openWebpage('edit.html')" value="发布"/>
                        <input type="button" class="manageButton" onclick="manageArticle(true)" value="管理"/>
                    </div>
                    <div style="clear:both"></div>
                    <%=title_list1%>
                    <div><%=msg%></div>
                    <!--
                    <div class="pageBottonDiv">
                        <a href="" id="prevLink"><input type="button" class="pageButton" value="<< 上一页"></a>
                        <a href="http://www.baidu.com/" id="nextLink"><input type="button" class="pageButton" value="下一页 >>"></a>
                    </div>-->
                </div>
                <div class="titleList" id="titleList2">
                    <div class="manage">
                        <input type="button" class="manageButton" onclick="manageArticle(false)" value="完成"/>
                    </div>
                    <div style="clear:both"></div>
                    <table class="tableStyle">
                        <tr>
                            <th>文章标题</th>
                            <th>时间</th>
                            <th>操作</th>
                        </tr>
                        <%=title_list2%>
                    </table>
                    <div><%=msg%></div>
                </div>
            </div>
        </div>
        
        <script>
            window.onscroll = function() {
                var sl=0-Math.max(document.body.scrollLeft,document.documentElement.scrollLeft);
                var style = document.defaultView.getComputedStyle(document.getElementById('leftPart'));  
                var leftWidth = parseInt(style.left);
                if (leftWidth>=0)
                    sl += parseInt(style.left);
                document.getElementById('leftPart').style.left = sl+'px';
            };
            window.onresize = function() {
                var clientWidth = Math.max(document.body.clientWidth, document.documentElement.clientWidth);
                var leftWidth = parseInt(document.defaultView.getComputedStyle(document.getElementById("leftPart")).width);
                var mainWidth = parseInt(document.defaultView.getComputedStyle(document.getElementById("mainPart")).width);
                var cl=Math.max(Math.ceil((clientWidth-leftWidth-mainWidth)/2), 0);
                document.getElementById('leftPart').style.left = cl+'px';
                document.getElementById('mainPart').style.left = (360+cl)+'px';
            }
            window.onresize();
            function openWebpage(path) {
                window.location.href = path;
            }
            function manageArticle(boolVal) {
                if (boolVal)
                {
                    document.getElementById("titleList1").style.display = "none";
                    document.getElementById("titleList2").style.display = "block";
                }
                else
                {
                    document.getElementById("titleList2").style.display = "none";
                    document.getElementById("titleList1").style.display = "block";
                }
            }
            function checkDelete(obj) {
                var articleName = obj.children[0].value;
                var r=confirm("是否确认删除 "+articleName+" ?");
                if (r)
                    return true;
                else
                    return false;
            }
        </script>
    </body>
</html>