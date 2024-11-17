<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 2024-06-18
  Time: 오후 9:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <title>차곡차곡</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #ffffff; /* 배경색을 흰색으로 변경 */
            margin: 0;
            padding: 0;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #f0e6d6;
            padding: 10px 20px;
            border-bottom: 1px solid #ddd;
        }
        .header .logo {
            display: flex;
            align-items: center;
        }
        .header img.main-icon {
            width: 30px;
            height: 30px;
            margin-right: 10px;
        }
        .header nav a {
            margin-left: 20px;
            text-decoration: none;
            color: #000;
        }
        .container {
            text-align: center;
            margin: 50px auto;
            width: 50%;
        }
        .container img {
            width: 50px;
            height: 50px;
            vertical-align: middle;
        }
        .container h2 {
            display: inline-block;
            margin: 0 20px;
        }
        .graph {
            width: 100%;
            height: 300px;
            background-color: #ffffff;
            margin: 30px 0;
        }
        .write-diary-btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #f0e6d6;
            border-radius: 8px;
            text-decoration: none;
            color: #000;
            font-size: 1.2em;
        }
        .logo a {
            display: flex;
            align-items: center;
            text-decoration: none;
            color: inherit;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<%
    String userId = (String) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    StringBuilder labels = new StringBuilder();
    StringBuilder data = new StringBuilder();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/stepbystep", "urim", "KKtamsl9207!");
        String sql = "SELECT date, mood FROM diarydb WHERE user_id = ? ORDER BY date";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            String date = rs.getString("date");
            String mood = rs.getString("mood");
            int moodScore = 0;
            if ("good".equals(mood)) {
                moodScore = 5;
            } else if ("soso".equals(mood)) {
                moodScore = 3;
            } else if ("down".equals(mood)) {
                moodScore = 1;
            }
            labels.append("\"").append(date).append("\",");
            data.append(moodScore).append(",");
        }

        if (labels.length() > 0) {
            labels.setLength(labels.length() - 1); // Remove the trailing comma
        }
        if (data.length() > 0) {
            data.setLength(data.length() - 1); // Remove the trailing comma
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
    <div class="header">
        <div class="logo">
            <a href="main.jsp">
                <img src="../static/mainicon.png" alt="Main Icon" class="main-icon">
                <h1>차곡차곡</h1>
            </a>
        </div>
        <nav>
            <a href="diary.jsp">일기쓰기</a>
            <a href="CheckList.jsp">다이어리</a>
            <a href="scrapbook.jsp">다꾸</a>
            <a href="logout.jsp">로그아웃</a>
        </nav>
    </div>
    <div class="container">
        <img src="../static/clover.png" alt="clover">
        <h2><%=userId%>님 반갑습니다. 당신의 하루를 알려주세요</h2>
        <img src="../static/clover.png" alt="clover">
        <div class="graph" id="moodGraph" style="height: 300px;">
            <canvas id="moodChart"></canvas>
        </div>
        <a href="diary.jsp" class="write-diary-btn">일 기 쓰 러 가 기</a>
    </div>
    <script>
        var ctx = document.getElementById('moodChart').getContext('2d');
        var moodChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: [<%=labels.toString()%>],
                datasets: [{
                    label: 'Mood',
                    data: [<%=data.toString()%>],
                    borderColor: 'rgba(75, 192, 192, 1)',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    borderWidth: 2, // 선 굵기 증가
                    pointRadius: 3, // 포인트 크기 증가
                    fill: false
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    x: {
                        title: {
                            display: true,
                            text: '날짜'
                        }
                    },
                    y: {
                        min: 0,
                        max: 5,
                        ticks: {
                            stepSize: 1,
                            callback: function(value) {
                                if (value === 1) return 'down';
                                if (value === 3) return 'soso';
                                if (value === 5) return 'good';
                                return value;
                            }
                        },
                        title: {
                            display: true,
                            text: '감정'
                        }
                    }
                },
                layout: {
                    padding: {
                        right: 0 // 그래프 오른쪽에 빈 공간을 없애기 위해 padding 조정
                    }
                }
            }
        });
    </script>
</body>
</html>
