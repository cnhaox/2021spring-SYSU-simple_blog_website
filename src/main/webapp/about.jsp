<%@ page language="java" import="java.util.*, java.io.*"
contentType="text/html; charset=utf-8" %>
<%
    String userType = (String)session.getAttribute("userType");
    boolean isManager = false;
    if (userType==null)
        response.sendRedirect("index.jsp");
    else if (userType.equals("manager"))
        isManager = true;
%>
<%request.setCharacterEncoding("utf-8");
	String path = application.getRealPath("info");
	File file = new File(path,"per_info.txt");
	//if (!file.getParentFile().exists())
	//    file.getParentFile().mkdir();
	//if (!file.exists())
	//    file.createNewFile();
	Map<String, String> info = new HashMap<String, String>();
	if (file.exists()) {
		FileInputStream ch = new FileInputStream(file);
		InputStreamReader fr = new InputStreamReader(ch,"UTF-8");
		BufferedReader br = new BufferedReader(fr);  //使文件可按行读取并具有缓冲功能
		String str = br.readLine();
		while(str!=null){
			info.put(str, br.readLine());   //将读取的内容放入info
			str = br.readLine();
		}
		br.close();
	}
	
	String name = info.get("name");
	String school = info.get("school");
	String hobby = info.get("hobby");
	String status = info.get("status");
	String contact = info.get("contact");
	String introduction = info.get("introduction");
	String blog_mes = info.get("blog_mes");
	
	if (request.getMethod().equalsIgnoreCase("post")){
		name = request.getParameter("name");
		school = request.getParameter("school");
		hobby = request.getParameter("hobby");
		status = request.getParameter("status");
		contact = request.getParameter("contact");
		introduction = request.getParameter("introduction");
		blog_mes = request.getParameter("blog_mes");
		
		String saveButton=request.getParameter("submit_mes"); //判断是否按了保存按钮
		if(saveButton!=null){
			Enumeration<String> enums=request.getParameterNames();
			FileOutputStream outstr = new FileOutputStream(file);
			BufferedWriter fw = new BufferedWriter(new OutputStreamWriter(outstr, "UTF-8"));
			while(enums.hasMoreElements()){
				String idx=(String)enums.nextElement();
				fw.write(idx + "\n" + request.getParameter(idx)+"\n");
			}
			fw.close();
		}
	}
%>
<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>about</title>
        <link rel="stylesheet" type="text/css" href="css/general.css" />
        <link rel="stylesheet" type="text/css" href="font-awesome/css/font-awesome.css" />
        <link rel="stylesheet" type="text/css" href="css/about.css" />
        <style>
            .menuChecked {
                top: 180px;
            }
            .menuChecked .menu {
                top: -180px;
            }
        </style>
    </head>
    <body>
        <div id="leftPart">
            <div id="nameContainer">
                <div id="headPortraitContainer" onclick="openWebpage('index.jsp')" style="cursor:pointer;">
                    <div id="headPortrait"></div>
                </div>
                <div id="blogName">
                    <h2><%=name%>的个人博客</h2>
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
            <div class="aboutDivList">
                <h1>About Me</h1>
                <div class="aboutDiv">
                    <% if (isManager) {%>
                    <div class="showed">
                        <button class="manageButton manageButton-bigger" onclick="openManage(true)">修改信息</button>
                    </div>
                    <%}%>
                    <form action="" method="post" id="mesForm" class="formStyle" onsubmit="return checkSubmit(this)">
                    </form>
                    <h2>个人简介</h2>
                    <table class="mes-table" id="mes_table">
                        <tr>
                            <td>名字昵称：</td>
                            <td class="showed"> <%= name %> </td>
                            <td class="hidden"><textarea form="mesForm" name="name" class="text-style" placeholder=""><%= name %></textarea></td>
                        </tr>
                        <tr>
                            <td>学校专业：</td>
                            <td class="showed"> <%= school %> </td>
                            <td class="hidden"><textarea form="mesForm" name="school" class="text-style" placeholder=""><%= school %></textarea></td>
                        </tr>
                        <tr>
                            <td>兴趣爱好：</td>
                            <td class="showed"> <%= hobby %> </td>
                            <td class="hidden"><textarea form="mesForm" name="hobby" class="text-style" placeholder=""><%= hobby %></textarea></td>
                        </tr>
                        <tr>
                            <td>当前状态：</td>
                            <td class="showed"> <%= status %> </td>
                            <td class="hidden"><textarea form="mesForm" name="status" class="text-style" placeholder=""><%= status %></textarea></td>
                        </tr>
                        <tr>
                            <td>联系方式：</td>
                            <td class="showed"> <%= contact %> </td>
                            <td class="hidden"><textarea form="mesForm" name="contact" class="text-style" placeholder=""><%= contact %></textarea></td>
                        </tr>
                    </table>
                </div>
                <div class="aboutDiv">
                    <h2>自我介绍</h2>
                    <div  class="showed">
                        <%= introduction %>
                    </div>
                    <div class="hidden">
                        <textarea form="mesForm" name="introduction" class="text-style text-bigger-style" placeholder=""><%= introduction %></textarea>
                    </div>
                </div>
                <div class="aboutDiv">
                    <h2>博客信息</h2>
                    <div  class="showed">
                        <%= blog_mes %>
                    </div>
                    <div class="hidden">
                        <textarea form="mesForm" name="blog_mes" class="text-style text-bigger-style" placeholder=""><%= blog_mes %></textarea>
                    </div>
                </div>
                <div class="aboutDiv hidden" id="manage_div">
                    <input type="button" class="manageButton" onclick="openManage(false)" value="取消"/>
                    <input type="submit" form="mesForm" class="manageButton" name="submit_mes" value="修改"/>
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
            function openManage(boolValue) {
                var obj_list1 = document.getElementsByClassName("showed");
                var obj_list2 = document.getElementsByClassName("hidden");
                if (boolValue)
                {
                    for (var i=0; i<obj_list1.length; i++)
                        obj_list1[i].style.display = "none";
                    for (var i=0; i<obj_list2.length; i++)
                        obj_list2[i].style.display = "block";
                }
                else
                {
                    for (var i=0; i<obj_list1.length; i++)
                        obj_list1[i].style.display = "block";
                    for (var i=0; i<obj_list2.length; i++)
                        obj_list2[i].style.display = "none";
                }
                window.onresize();
            }
            function refreshImgName(obj) {
                var filePath = obj.value;
                var fileName = null;
                if (filePath.indexOf("/")!=-1)
                {
                    var arr = filePath.split('/');
                    fileName = arr[arr.length-1];
                }
                else if (filePath.indexOf("\\"!=-1))
                {
                    var arr = filePath.split("\\");
                    fileName = arr[arr.length-1];
                }
                else
                    fileName = filePath;
                obj.parentNode.nextElementSibling.innerHTML = fileName;
            }
            function checkSubmit(obj)
            {
                var r=confirm("是否确认修改？");
                if (r)
                    return true;
                else
                    return false;
            }
        </script>
    </body>
</html>