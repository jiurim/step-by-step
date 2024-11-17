<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 2024-06-11
  Time: 오후 10:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <title>차곡차곡 - 로그인</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .login-container {
            background-color: #f0e6d6;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 300px;
            text-align: center;
        }
        .login-container img {
            width: 100px;
            height: 100px;
            margin-bottom: 20px;
        }
        .login-container h1 {
            font-size: 1.5em;
            margin-bottom: 20px;
        }
        .login-container input[type="text"],
        .login-container input[type="password"] {
            width: calc(100% - 40px);
            padding: 10px;
            margin: 10px 20px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .login-container button {
            width: calc(100% - 40px);
            padding: 10px;
            background-color: white;
            color: black;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            box-sizing: content-box;
            margin-left: 20px;
            margin-top: 10px;
        }

        .login-container button:hover {
            background-color: #333;
            color: white;
        }
        .login-container .links {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
        .login-container .links a {
            text-decoration: none;
            color: #000;
            margin: 0 10px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <img src="../static/mainicon.png" alt="Main Icon">
        <h1>차곡차곡</h1>
        <form action="loginProcess.jsp" method="post" accept-charset="utf-8">
            <input type="text" name="user_id" placeholder="아이디" required>
            <input type="password" name="passwd" placeholder="비밀번호" required>
            <button type="submit">로그인</button>
        </form>
        <div class="links">
            <a href="findPassword.jsp">비밀번호 찾기</a>
            <a>|</a>
            <a href="signup.jsp">회원가입</a>
        </div>
    </div>
</body>
</html>

