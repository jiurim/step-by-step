<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 2024-06-11
  Time: 오후 11:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html;charset=EUC-KR" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <title>차곡차곡 - 회원가입</title>
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
        .register-container {
            background-color: #f0e6d6;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 400px;
            text-align: left; /* 레이블 정렬을 위해 중앙에서 왼쪽으로 변경 */
        }
        .register-container img {
            display: block;
            width: 50px;
            height: 50px;
            margin: 0 auto 20px auto; /* 이미지를 중앙에 배치 */
        }
        .register-container h1 {
            font-size: 1.5em;
            text-align: center;
            margin-bottom: 20px;
        }
        .register-container label {
            display: block;
            margin: 10px 20px 5px 20px; /* 레이블에 약간의 여백 추가 */
        }
        .register-container input[type="text"],
        .register-container input[type="password"],
        .register-container input[type="email"] {
            width: calc(100% - 40px);
            padding: 10px;
            margin: 5px 20px 10px 20px; /* 레이블과 입력 필드 사이의 여백을 조정 */
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .register-container button,
        .register-container input[type="submit"] {
            width: calc(100% - 40px);
            padding: 10px;
            background-color: #fff5e1;
            color: #000;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin: 10px 20px;
        }
        .register-container button:hover,
        .register-container input[type="submit"]:hover {
            background-color: #e0d5c0;
        }
        .register-container .gender-container {
            display: flex;
            justify-content: center;
            margin-top: 10px;
        }
        .register-container .gender-container input {
            margin: 0 10px;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <img src="../static/mainicon.png" alt="Main Icon">
        <h1>회원가입</h1>
        <form action="signupProcess.jsp" method="post" accept-charset="utf-8">
            <label for="user_id">아이디</label>
            <input type="text" id="user_id" name="user_id" placeholder="아이디를 입력해 주세요" required>

            <label for="passwd">비밀번호</label>
            <input type="password" id="passwd" name="passwd" placeholder="비밀번호를 입력해 주세요" required>

            <label for="confirm_passwd">비밀번호 확인</label>
            <input type="password" id="confirm_passwd" name="confirm_password" placeholder="비밀번호를 입력해 주세요" required>

            <label for="email">이메일</label>
            <input type="email" id="email" name="email" placeholder="이메일을 입력해 주세요" required>

            <div class="gender-container">
                <label><input type="radio" name="gender" value="남성" required> 남성</label>
                <label><input type="radio" name="gender" value="여성" required> 여성</label>
            </div>
            <input type="submit" value="가입하기">
        </form>
    </div>
</body>
</html>

