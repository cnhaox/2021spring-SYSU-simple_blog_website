<%@ page language="java" contentType="text/html; charset=utf-8"%>
<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>个人博客</title>
        <link rel="stylesheet" type="text/css" href="css/general.css" />
        <link rel="stylesheet" type="text/css" href="css/comment.css" />
        <link rel="stylesheet" type="text/css" href="font-awesome/css/font-awesome.css" />
        <link rel="stylesheet" type="text/css" href="css/article.css" />
        <style>
            .menuChecked {
                top: 0px;
            }
            .menuChecked .menu {
                top: 0px;
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
            <div id="article-container">
                <h1>这是文章标题</h1>
                <div class="article-mes">
                    <span class="comment-name comment-name-large">作者</span>
                    &nbsp;&nbsp;
                    <span class="comment-time comment-time-large">2021-01-01 12:00:30</span>
                </div>
                <div class="article-tags">
                    <span class="tag-header">标签：</span> <span class="tag-span">标签1</span>&nbsp;|&nbsp;<span class="tag-span">标签2</span>&nbsp;|&nbsp;<span class="tag-span">标签3</span>
                </div>

                <p>
                    这是文章段落。这是文章段落。这是文章段落。这是文章段落。这是文章段落。这是文章段落。这是文章段落。
                    这是文章段落。这是文章段落。这是文章段落。这是文章段落。这是文章段落。这是文章段落。
                    这是文章段落。这是文章段落。这是文章段落。这是文章段落。这是文章段落。这是文章段落。
                </p>
                <p>好，文章结束了。</p>
            </div>
            <script>
                document.getElementById('article--container').innerHTML = marked('# Marked in browser\n\nRendered by **marked**.![](./img/pic.jpeg)')
            </script>

            <div class="comment-editor-container">
                <h2>吐槽一下?</h2>
                <div class="comment-editor-main">
                    <form action="" method="post" id="newReplyForm" class="form-hidden-style" onsubmit="return checkReply(this)">
                    </form>
                    <div class="comment-editor-header">
                        <div class="comment-editor-info">
                            <input type="hidden" form="newReplyForm" name="cid" value="">
                            昵称：<input type="text" form="newReplyForm" name="userName" value="">
                            Email：<input type="text" form="newReplyForm" name="email" value="">
                        </div>
                    </div>
                    <div class="comment-editor-body">
                        <textarea form="newReplyForm" name="comment" placeholder="请自觉遵守互联网相关的政策法规，严禁发布色情、暴力、反动的言论。" value=""></textarea>
                    </div>
                </div>
                <div class="comment-editor-footer">
                    <input type="submit"  form="newReplyForm" name="submit" class="comment-editor-submit" value="发&nbsp;&nbsp;表">
                </div>
            </div>
            <div class="comment-container">
                <h2>全部评论</h2>
                <div class="comment-block">
                    <div class="comment-block-header">
                        <span class="comment-name comment-name-large">用户名</span>
                        <span class="comment-time comment-time-header">2021-01-01 12:00:30</span>
                    </div>
                    <div class="comment-block-body">
                        <div>
                            这是一条评论。评论内容在这个div显示。
                        </div>
                        <div>
                            <button class="reply-button"  onclick="openReply(true, this)">回复</button>
                        </div>
                        <div class="comment-block-editor">
                            <form action="" method="post" id="ReplyFormCID" class="form-hidden-style" onsubmit="return checkReply(this)">
                            </form>
                            <div class="comment-editor-header">
                                <div class="comment-editor-info">
                                    <input type="hidden" name="cid" value="CID">
                                    昵称：<input type="text" form="ReplyFormCID" id="userNameInput" name="userName" value="">
                                    Email：<input type="text" form="ReplyFormCID" id="emailInput" name="email" value="">
                                </div>
                            </div>
                            <div class="comment-editor-body">
                                <textarea form="ReplyFormCID" placeholder="请自觉遵守互联网相关的政策法规，严禁发布色情、暴力、反动的言论。"></textarea>
                            </div>
                            <button class="reply-button" onclick="openReply(false, this)">取消</button>
                            <input type="submit"  form="ReplyFormCID" name="submit" class="reply-button" value="回复">
                        </div>
                    </div>
                    <div class="comment-foot">
                        <div class="comment-comment">
                            <div class="comment-comment-header">
                                <span class="comment-name">用户名1</span> 于 <span class="comment-time">2021-01-01 12:30:00</span> 回复 <span class="comment-name">用户名</span>：
                            </div>
                            <div class="comment-comment-body">
                                <div>
                                    这是一条回复。评论内容在这个div显示。
                                </div>
                                <div>
                                    <button class="reply-button" onclick="openReply(true, this)">回复</button>
                                </div>
                                <div class="comment-block-editor">
                                    <form action="" method="post" id="ReplyFormCID" class="form-hidden-style" onsubmit="return checkReply(this)">
                                    </form>
                                    <div class="comment-editor-header">
                                        <div class="comment-editor-info">
                                            <input type="hidden" name="cid" value="CID">
                                            昵称：<input type="text" form="ReplyFormCID" id="userNameInput" name="userName" value="">
                                            Email：<input type="text" form="ReplyFormCID" id="emailInput" name="email" value="">
                                        </div>
                                    </div>
                                    <div class="comment-editor-body">
                                        <textarea form="ReplyFormCID" placeholder="请自觉遵守互联网相关的政策法规，严禁发布色情、暴力、反动的言论。"></textarea>
                                    </div>
                                    <button class="reply-button" onclick="openReply(false, this)">取消</button>
                                    <input type="submit"  form="ReplyFormCID" name="submit" class="reply-button" value="回复">
                                </div>
                            </div>
                        </div>
                        <div class="comment-comment">
                            <div class="comment-comment-header">
                                <span class="comment-name">用户名1</span> 于 <span class="comment-time">2021-01-01 12:30:00</span> 回复 <span class="comment-name">用户名</span>：
                            </div>
                            <div class="comment-comment-body">
                                <div>
                                    这是一条回复。评论内容在这个div显示。
                                </div>
                                <div>
                                    <button class="reply-button" onclick="openReply(true, this)">回复</button>
                                </div>
                                <div class="comment-block-editor">
                                    <form action="" method="post" id="ReplyFormCID" class="form-hidden-style" onsubmit="return checkReply(this)">
                                    </form>
                                    <div class="comment-editor-header">
                                        <div class="comment-editor-info">
                                            <input type="hidden" name="cid" value="CID">
                                            昵称：<input type="text" form="ReplyFormCID" id="userNameInput" name="userName" value="">
                                            Email：<input type="text" form="ReplyFormCID" id="emailInput" name="email" value="">
                                        </div>
                                    </div>
                                    <div class="comment-editor-body">
                                        <textarea form="ReplyFormCID" placeholder="请自觉遵守互联网相关的政策法规，严禁发布色情、暴力、反动的言论。"></textarea>
                                    </div>
                                    <button class="reply-button" onclick="openReply(false, this)">取消</button>
                                    <input type="submit"  form="ReplyFormCID" name="submit" class="reply-button" value="回复">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="comment-block">
                    <div class="comment-block-header">
                        <span class="comment-name comment-name-large">用户名</span>
                        <span class="comment-time comment-time-header">2021-01-01 12:00:30</span>
                    </div>
                    <div class="comment-block-body">
                        <div>
                            这是一条评论。评论内容在这个div显示。
                        </div>
                        <div>
                            <button class="reply-button"  onclick="openReply(true, this)">回复</button>
                        </div>
                        <div class="comment-block-editor">
                            <form action="" method="post" id="ReplyFormCID" class="formStyle" onsubmit="return checkReply(this)">
                            </form>
                            <div class="comment-editor-header">
                                <div class="comment-editor-info">
                                    <input type="hidden" name="cid" value="CID">
                                    昵称：<input type="text" form="ReplyFormCID" id="userNameInput" name="userName" value="">
                                    Email：<input type="text" form="ReplyFormCID" id="emailInput" name="email" value="">
                                </div>
                            </div>
                            <div class="comment-editor-body">
                                <textarea form="ReplyFormCID" placeholder="严禁发布色情、暴力、反动的言论。"></textarea>
                            </div>
                            <button class="reply-button" onclick="openReply(false, this)">取消</button>
                            <input type="submit"  form="ReplyFormCID" name="submit" class="reply-button" value="回复">
                        </div>
                    </div>
                    <div class="comment-foot">
                        <div class="comment-comment">
                            <div class="comment-comment-header">
                                <span class="comment-name">用户名1</span> 于 <span class="comment-time">2021-01-01 12:30:00</span> 回复 <span class="comment-name">用户名</span>：
                            </div>
                            <div class="comment-comment-body">
                                <div>
                                    这是一条回复。评论内容在这个div显示。
                                </div>
                                <div>
                                    <button class="reply-button" onclick="openReply(true, this)">回复</button>
                                </div>
                                <div class="comment-block-editor">
                                    <form action="" method="post" id="ReplyFormCID" class="formStyle" onsubmit="return checkReply(this)">
                                    </form>
                                    <div class="comment-editor-header">
                                        <div class="comment-editor-info">
                                            <input type="hidden" name="cid" value="CID">
                                            昵称：<input type="text" form="ReplyFormCID" id="userNameInput" name="userName" value="">
                                            Email：<input type="text" form="ReplyFormCID" id="emailInput" name="email" value="">
                                        </div>
                                    </div>
                                    <div class="comment-editor-body">
                                        <textarea form="ReplyFormCID" placeholder="严禁发布色情、暴力、反动的言论。"></textarea>
                                    </div>
                                    <button class="reply-button" onclick="openReply(false, this)">取消</button>
                                    <input type="submit"  form="ReplyFormCID" name="submit" class="reply-button" value="回复">
                                </div>
                            </div>
                        </div>
                        <div class="comment-comment">
                            <div class="comment-comment-header">
                                <span class="comment-name">用户名1</span> 于 <span class="comment-time">2021-01-01 12:30:00</span> 回复 <span class="comment-name">用户名</span>：
                            </div>
                            <div class="comment-comment-body">
                                <div>
                                    这是一条回复。评论内容在这个div显示。
                                </div>
                                <div>
                                    <button class="reply-button" onclick="openReply(true, this)">回复</button>
                                </div>
                                <div class="comment-block-editor">
                                    <form action="" method="post" id="ReplyFormCID" class="formStyle" onsubmit="return checkReply(this)">
                                    </form>
                                    <div class="comment-editor-header">
                                        <div class="comment-editor-info">
                                            <input type="hidden" name="cid" value="CID">
                                            昵称：<input type="text" form="ReplyFormCID" id="userNameInput" name="userName" value="">
                                            Email：<input type="text" form="ReplyFormCID" id="emailInput" name="email" value="">
                                        </div>
                                    </div>
                                    <div class="comment-editor-body">
                                        <textarea form="ReplyFormCID" placeholder="严禁发布色情、暴力、反动的言论。"></textarea>
                                    </div>
                                    <button class="reply-button" onclick="openReply(false, this)">取消</button>
                                    <input type="submit"  form="ReplyFormCID" name="submit" class="reply-button" value="回复">
                                </div>
                            </div>
                        </div>
                    </div>
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
            function openReply(boolValue, obj) {
                var num = obj.parentNode.parentNode.children.length;
                if (boolValue)
                {
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