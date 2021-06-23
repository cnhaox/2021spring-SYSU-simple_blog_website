<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.time.*"%>
<%@ page import="java.time.format.*"%>
<%
    String userType = (String)session.getAttribute("userType");
    boolean isManager = false;
    if (userType==null)
        response.sendRedirect("index.jsp");
    else if (userType.equals("manager"))
        isManager = true;
%>
<%
    // 获取名字
    String namePath = application.getRealPath("info");
    File introFile = new File(namePath,"per_info.txt");
    Map<String, String> info = new HashMap<String, String>();
    String BLOGName = "";
    if (introFile.exists()) {
        FileInputStream ch = new FileInputStream(introFile);
        InputStreamReader fr = new InputStreamReader(ch,"UTF-8");
        BufferedReader br = new BufferedReader(fr);  //使文件可按行读取并具有缓冲功能
        String str = br.readLine();
        while(str!=null){
            info.put(str, br.readLine());   //将读取的内容放入info
            str = br.readLine();
        }
        br.close();
        BLOGName = info.get("name");
    }
%>
<%
	String msg = "";
	String title = "";
	String author = "";
    DateTimeFormatter idf = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSSSS");
    DateTimeFormatter odf = DateTimeFormatter.ofPattern("yyyy年MM月dd日 HH:mm:ss E");
	String tags = "";
	String content = "";
	String comment_list = "";
    String connectString = "jdbc:mysql://localhost:3306/blog_18308045?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
    String user = "blogger_18308013";
    String pwd = "18340197";
    request.setCharacterEncoding("utf-8");
    String ATime = request.getParameter("ATime");
    String ATime_fmt = LocalDateTime.parse(ATime,idf).format(odf);
    try
    {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(connectString, user, pwd);
        Statement stmt = con.createStatement();
        String fmt = "select * from Article,Text where Article.ATime='%s' and Text.ATime='%s'";
        String sql = String.format(fmt, ATime, ATime);
        ResultSet rs = stmt.executeQuery(sql);
        rs.next();
        title = rs.getString("Title");
        author = rs.getString("Author");
        content = rs.getString("AContent");
        rs.close();
        fmt = "select * from Tag where ATime='%s'";
        sql = String.format(fmt, ATime);
        rs = stmt.executeQuery(sql);
        if (rs.next())
        {
            tags += "<span class='tag-span'>" + rs.getString("TName") + "</span>";
        }
        while (rs.next())
        {
            tags += "&nbsp;|&nbsp;<span class='tag-span'>" + rs.getString("TName") + "</span>";
        }
        rs.close();
        sql = "select * from Comment where ATime='" + ATime + "'";
        rs = stmt.executeQuery(sql);
        while (rs.next())
        {
        	String CTime = LocalDateTime.parse(rs.getString("CTime").replace(" ", "T")).format(idf);
        	String CTime_fmt = LocalDateTime.parse(CTime,idf).format(odf);
        	String CNickname = rs.getString("CNickname");
        	String form_name = ("ReplyFrom" + CTime);
            comment_list += "<div class='comment-block'>\n";
            comment_list += "    <div class='comment-block-header'>\n";
            comment_list += "        <span class='comment-name comment-name-large'>" + CNickname + "</span>\n";
            comment_list += "        <span class='comment-time comment-time-header'>" + CTime_fmt + "</span>\n";
            comment_list += "    </div>\n";
            comment_list += "    <div class='comment-block-body'>\n";
            comment_list += "        <div>" + rs.getString("CContent") + "</div>\n";
            comment_list += "        <div>\n";
            comment_list += "            <button class='reply-button'  onclick='openReply(true, this)'>回复</button>\n";
            comment_list += "        </div>\n";
            comment_list += "        <div class='comment-block-editor'>\n";
            comment_list += "            <form action='insert.jsp' method='post' id='" + form_name + "' class='form-hidden-style' onsubmit='return checkReply(this)'>\n";
            comment_list += "            </form>\n";
            comment_list += "            <div class='comment-editor-header'>\n";
            comment_list += "                <div class='comment-editor-info'>\n";
            comment_list += "                    <input name='article.jsp?ATime=" + ATime + "' type='hidden' form='" + form_name + "'>\n";
            comment_list += "                    <input name='100' type='hidden' form='" + form_name + "'>\n";
            comment_list += "                    <input name='Subcomment' type='hidden' form='" + form_name + "'>\n";
            comment_list += "                    <input name='datetime' value='STime' type='hidden' form='" + form_name + "'>\n";
            comment_list += "                    <input name='6' type='hidden' form='" + form_name + "'>\n";
            comment_list += "                    <input name='CTime' value='" + CTime + "' type='hidden' form='" + form_name + "'>\n";
            comment_list += "                    <input name='ATime' value='" + ATime + "' type='hidden' form='" + form_name + "'>\n";
            comment_list += "                    <input name='Target' value='" + CNickname + "' type='hidden' form='" + form_name + "'>\n";
            comment_list += "                    昵称：<input name='SNickname' value='' type='text' form='" + form_name + "'>\n";
            comment_list += "                    Email：<input name='SEmail' value='' type='text' form='" + form_name + "'>\n";
            comment_list += "                </div>\n";
            comment_list += "            </div>\n";
            comment_list += "            <div class='comment-editor-body'>\n";
            comment_list += "                <textarea name='SContent' form='" + form_name + "' placeholder='请自觉遵守互联网相关的政策法规，严禁发布色情、暴力、反动的言论。'></textarea>\n";
            comment_list += "            </div>\n";
            comment_list += "            <button class='reply-button' onclick='openReply(false, this)'>取消</button>\n";
            comment_list += "            <input type='submit' form='" + form_name + "' name='submit' class='reply-button' value='回复'>\n";
            comment_list += "        </div>\n";
            comment_list += "    </div>\n";
            comment_list += "    <div class='comment-foot'>\n";
            String sub_fmt = "select * from Subcomment where CTime='%s' and ATime='%s'";
            String sub_sql = String.format(sub_fmt, CTime, ATime);
            Statement sub_stmt = con.createStatement();
            ResultSet sub_rs = sub_stmt.executeQuery(sub_sql);
            while(sub_rs.next())
            {
            	String STime = LocalDateTime.parse(sub_rs.getString("STime").replace(" ", "T")).format(idf);
                String STime_fmt = LocalDateTime.parse(STime,idf).format(odf);
            	String SNickname = sub_rs.getString("SNickname");
            	String sub_form_name = ("SubReplyForm" + STime);
                comment_list += "        <div class='comment-comment'>\n";
                comment_list += "            <div class='comment-comment-header'>\n";
                comment_list += "                <span class='comment-name'>" + SNickname + "</span> 于 <span class='comment-time'>" + STime_fmt + "</span> 回复 <span class='comment-name'>" + sub_rs.getString("Target") + "</span>：\n";
                comment_list += "            </div>\n";
                comment_list += "            <div class='comment-comment-body'>\n";
                comment_list += "                <div>" + sub_rs.getString("SContent") + "</div>\n";
                comment_list += "                <div>\n";
                comment_list += "                    <button class='reply-button' onclick='openReply(true, this)'>回复</button>\n";
                comment_list += "                </div>\n";
                comment_list += "                <div class='comment-block-editor'>\n";
                comment_list += "                    <form action='insert.jsp' method='post' id='" + sub_form_name + "' class='form-hidden-style' onsubmit='return checkReply(this)'>\n";
                comment_list += "                    </form>\n";
                comment_list += "                    <div class='comment-editor-header'>\n";
                comment_list += "                        <div class='comment-editor-info'>\n";
                comment_list += "                            <input name='article.jsp?ATime=" + ATime + "' type='hidden' form='" + sub_form_name + "'>\n";
                comment_list += "                            <input name='100' type='hidden' form='" + sub_form_name + "'>\n";
                comment_list += "                            <input name='Subcomment' type='hidden' form='" + sub_form_name + "'>\n";
                comment_list += "                            <input name='datetime' value='STime' type='hidden' form='" + sub_form_name + "'>\n";
                comment_list += "                            <input name='6' type='hidden' form='" + sub_form_name + "'>\n";
                comment_list += "                            <input name='CTime' value='" + CTime + "' type='hidden' form='" + sub_form_name + "'>\n";
                comment_list += "                            <input name='ATime' value='" + ATime + "' type='hidden' form='" + sub_form_name + "'>\n";
                comment_list += "                            <input name='Target' value='" + SNickname + "' type='hidden' form='" + sub_form_name + "'>\n";
                comment_list += "                            昵称：<input name='SNickname' value='' type='text' form='" + sub_form_name + "'>\n";
                comment_list += "                            Email：<input name='SEmail' value='' type='text' form='" + sub_form_name + "'>\n";
                comment_list += "                        </div>\n";
                comment_list += "                    </div>\n";
                comment_list += "                    <div class='comment-editor-body'>\n";
                comment_list += "                        <textarea name='SContent' form='" + sub_form_name + "' placeholder='请自觉遵守互联网相关的政策法规，严禁发布色情、暴力、反动的言论。'></textarea>\n";
                comment_list += "                    </div>\n";
                comment_list += "                    <button class='reply-button' onclick='openReply(false, this)'>取消</button>\n";
                comment_list += "                    <input type='submit' form='" + sub_form_name + "' name='submit' class='reply-button' value='回复'>\n";
                comment_list += "                </div>\n";
                comment_list += "            </div>\n";
                comment_list += "        </div>\n";
            }
            comment_list += "    </div>\n";
            comment_list += "</div>\n";
            sub_rs.close();
            sub_stmt.close();
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
        <title>article</title>
        <link rel="stylesheet" type="text/css" href="css/general.css" />
        <link rel="stylesheet" type="text/css" href="css/comment.css" />
        <link rel="stylesheet" type="text/css" href="font-awesome/css/font-awesome.css" />
        <link rel="stylesheet" type="text/css" href="css/article.css" />
        <link rel="stylesheet" type="text/css" href="katex/katex.min.css" />
        <link rel="stylesheet" type="text/css" href="highlight/styles/default.min.css">
        <style>
            .menuChecked {
                top: 0px;
            }
            .menuChecked .menu {
                top: 0px;
            }
        </style>
    </head>
    <body>
        <div id="leftPart">
            <div id="nameContainer">
                <div id="headPortraitContainer">
                    <div id="headPortrait"></div>
                </div>
                <div id="blogName">
                    <h2><%=BLOGName%>的个人博客</h2>
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
                <div class="menuHover menuHover1" onclick="openWebpage('home.jsp')"></div>
                <div class="menuHover menuHover2" onclick="openWebpage('tags.jsp')"></div>
                <div class="menuHover menuHover3" onclick="openWebpage('files.jsp')"></div>
                <div class="menuHover menuHover4" onclick="openWebpage('about.jsp')"></div>
                <div class="menuChecked">
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
            <div id="article-container">
                <div id="article-header">
                    <h1><%=title%></h1>
                    <div class="article-mes">
                        <span class="comment-name comment-name-large"><%=author%></span>
                        &nbsp;&nbsp;
                        <span class="comment-time comment-time-large"><%=ATime_fmt%></span>
                    </div>
                    <div class="article-tags">
                    	<%=tags%>
                    </div>
                </div>
                <div id="article-body">
                </div>
            </div>

            <div class="comment-editor-container">
                <h2>吐槽一下?</h2>
                <div class="comment-editor-main">
                    <form action="insert.jsp" method="post" id="newReplyForm" class="form-hidden-style" onsubmit="return checkReply(this)">
                    </form>
                    <div class="comment-editor-header">
                        <div class="comment-editor-info">
                            <input name="article.jsp?ATime=<%=ATime%>" type="hidden" form="newReplyForm">
                            <input name="100" type="hidden" form="newReplyForm">
                            <input name="Comment" type="hidden" form="newReplyForm">
                            <input name="datetime" value="CTime" type="hidden" form="newReplyForm">
                            <input name="4" type="hidden" form="newReplyForm">
                            <input name="ATime" value="<%=ATime%>" type="hidden" form="newReplyForm">
                            昵称：<input name="CNickname" value="" type="text" form="newReplyForm">
                            Email：<input name="CEmail" value="" type="text" form="newReplyForm">
                        </div>
                    </div>
                    <div class="comment-editor-body">
                        <textarea name="CContent" form="newReplyForm" placeholder="请自觉遵守互联网相关的政策法规，严禁发布色情、暴力、反动的言论。"></textarea>
                    </div>
                </div>
                <div class="comment-editor-footer">
                    <input type="submit" form="newReplyForm" name="submit" class="comment-editor-submit" value="发&nbsp;&nbsp;表">
                </div>
            </div>
            <div class="comment-container">
                <h2>全部评论</h2>
<%=comment_list%>
            </div>
        </div>
        <div><%=msg%></div>
        
        <script src="katex/katex.min.js"></script>
        <script src="js/marked.js"></script>
        <script src="highlight/highlight.min.js"></script>
        <script>
            marked.setOptions({
              highlight: function(code, lang) {
                if (typeof lang === 'undefined') {
                  return hljs.highlightAuto(code).value;
                } else if (lang === 'nohighlight') {
                  return code;
                } else {
                  return hljs.highlight(lang, code).value;
                }
              },
              kaTex: katex
            });
            document.getElementById('article-body').innerHTML = marked(
`<%=content.replace("\\", "\\\\").replace("`", "\\`")%>`
            )
        </script>
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
            function openReply(boolValue, obj) {
                var num = obj.parentNode.parentNode.children.length;
                if (boolValue)
                {
                    var objList = document.getElementsByClassName("comment-block-editor");
                    for (var i=0; i<objList.length; i++)
                    {
                        objList[i].parentNode.children[num-2].style.display = "block";
                        objList[i].parentNode.children[num-1].style.display = "none";
                    }
                    obj.parentNode.parentNode.children[num-2].style.display = "none";
                    obj.parentNode.parentNode.children[num-1].style.display = "block";
                }
                else
                {
                    obj.parentNode.parentNode.children[num-2].style.display = "block";
                    obj.parentNode.parentNode.children[num-1].style.display = "none";
                }
            }
            function checkReply(obj)
            {
                var r=confirm("是否确认提交评论？");
                if (r)
                    return true;
                else
                    return false;
            }
        </script>
    </body>
</html>