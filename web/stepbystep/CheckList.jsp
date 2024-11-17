<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 2024-06-10
  Time: 오후 9:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>
<%
    String userId = (String) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    List<String> firstTasks = new ArrayList<>();
    List<String> secondTasks = new ArrayList<>();
    List<String> thirdTasks = new ArrayList<>();
    List<String> fourthTasks = new ArrayList<>();
    List<Boolean> firstTasksCompleted = new ArrayList<>();
    List<Boolean> secondTasksCompleted = new ArrayList<>();
    List<Boolean> thirdTasksCompleted = new ArrayList<>();
    List<Boolean> fourthTasksCompleted = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/stepbystep?useUnicode=true&characterEncoding=UTF-8", "urim", "KKtamsl9207!");
        String sql = "SELECT first, second, third, fourth, quadrant, is_completed FROM check_list WHERE user_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            int quadrant = rs.getInt("quadrant");
            String task = "";
            boolean isCompleted = rs.getBoolean("is_completed");
            switch (quadrant) {
                case 1:
                    task = rs.getString("first");
                    if (task != null && !task.trim().isEmpty()) {
                        firstTasks.add(task);
                        firstTasksCompleted.add(isCompleted);
                    }
                    break;
                case 2:
                    task = rs.getString("second");
                    if (task != null && !task.trim().isEmpty()) {
                        secondTasks.add(task);
                        secondTasksCompleted.add(isCompleted);
                    }
                    break;
                case 3:
                    task = rs.getString("third");
                    if (task != null && !task.trim().isEmpty()) {
                        thirdTasks.add(task);
                        thirdTasksCompleted.add(isCompleted);
                    }
                    break;
                case 4:
                    task = rs.getString("fourth");
                    if (task != null && !task.trim().isEmpty()) {
                        fourthTasks.add(task);
                        fourthTasksCompleted.add(isCompleted);
                    }
                    break;
            }
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

    .header .logo a {
        display: flex;
        align-items: center;
        text-decoration: none;
        color: inherit;
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
        width: 90%;
        margin: 20px auto;
        padding: 20px;
        border-radius: 8px;
    }

    .grid-container {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        grid-template-rows: repeat(2, 1fr);
        gap: 20px;
        margin-top: 20px;
        position: relative;
    }

    .grid-item {
        background-color: #f0e6d6;
        padding: 20px;
        border-radius: 8px;
        font-size: 1em;
        color: #333;
        display: flex;
        flex-direction: column;
        position: relative;
    }

    .grid-item:nth-child(1) {
        background-color: #ffd9d9;
    }

    .grid-item:nth-child(2) {
        background-color: #f7f7d9;
    }

    .grid-item:nth-child(3) {
        background-color: #f7d9f7;
    }

    .grid-item:nth-child(4) {
        background-color: #d9f7f7;
    }

    .grid-item ul {
        list-style: none;
        padding: 0;
    }

    .grid-item ul li {
        display: flex;
        align-items: center;
        margin-bottom: 10px;
    }

    .grid-item ul li input[type="text"] {
        flex: 1;
        padding: 5px;
        margin-right: 10px;
        border: 1px solid #ddd;
        border-radius: 4px;
    }

    .grid-item ul li input[type="checkbox"] {
        margin-right: 10px;
    }

    .grid-item label {
        display: block;
        text-align: center;
        font-size: 1.2em;
        margin-bottom: 10px;
    }

    .grid-item::before {
        content: attr(data-label);
        position: absolute;
        background-color: white;
        border-radius: 50%;
        padding: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        font-size: 1.2em;
        font-weight: bold;
        pointer-events: none;
    }

    .grid-item:nth-child(1)::before {
        top: -10px;
        left: -10px;
        content: "2";
    }

    .grid-item:nth-child(2)::before {
        top: -10px;
        right: -10px;
        content: "1";
    }

    .grid-item:nth-child(3)::before {
        bottom: -10px;
        left: -10px;
        content: "3";
    }

    .grid-item:nth-child(4)::before {
        bottom: -10px;
        right: -10px;
        content: "4";
    }

    .axis {
        position: absolute;
        width: 100%;
        height: 100%;
        top: 0;
        left: 0;
        pointer-events: none;
    }

    .axis .horizontal {
        position: absolute;
        width: 100%;
        height: 3px;
        background-color: #84A6FF;
        top: 50%;
        left: 0;
        pointer-events: none;
    }

    .axis .horizontal::after {
        content: '';
        position: absolute;
        width: 0;
        height: 0;
        border-left: 10px solid #84A6FF;
        border-top: 5px solid transparent;
        border-bottom: 5px solid transparent;
        top: -4px;
        right: -10px;
        pointer-events: none;
    }

    .axis .vertical {
        position: absolute;
        height: 100%;
        width: 3px;
        background-color: #FF9595;
        top: 0;
        left: 50%;
        pointer-events: none;
    }

    .axis .vertical::after {
        content: '';
        position: absolute;
        width: 0;
        height: 0;
        border-bottom: 10px solid #FF9595;
        border-left: 5px solid transparent;
        border-right: 5px solid transparent;
        top: -10px;
        left: -4px;
        pointer-events: none;
    }

    .axis .label {
        position: absolute;
        font-size: 1em;
        font-weight: bold;
        pointer-events: none;
    }

    .axis .label.importance {
        bottom: 0;
        left: 50%;
        transform: translate(-50%, 20px);
        pointer-events: none;
    }

    .axis .label.urgency {
        top: 50%;
        right: 0;
        transform: translate(50px, -50%) rotate(90deg);
        pointer-events: none;
    }

    .save-btn-container {
        text-align: center;
        margin-top: 20px;
    }

    .save-btn {
        padding: 10px 20px;
        font-size: 1.2em;
        background-color: #84A6FF;
        color: #fff;
        border: none;
        border-radius: 8px;
        cursor: pointer;
    }
</style>
</head>
<body>
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
    <form action="saveCheckList.jsp" method="post" accept-charset="utf-8">
        <div class="grid-container">
            <div class="grid-item" data-label="1">
                <label>2순위</label>
                <ul>
                    <% for (int i = 0; i < 4; i++) {
                        String task = i < firstTasks.size() ? firstTasks.get(i) : "";
                        boolean isCompleted = i < firstTasksCompleted.size() && firstTasksCompleted.get(i);
                    %>
                    <li>
                        <input type="checkbox" name="completed1" <%= isCompleted ? "checked" : "" %>>
                        <input type="text" name="task1" value="<%= task %>" placeholder="할 일">
                    </li>
                    <% } %>
                </ul>
            </div>
            <div class="grid-item" data-label="2">
                <label>1순위</label>
                <ul>
                    <% for (int i = 0; i < 4; i++) {
                        String task = i < secondTasks.size() ? secondTasks.get(i) : "";
                        boolean isCompleted = i < secondTasksCompleted.size() && secondTasksCompleted.get(i);
                    %>
                    <li>
                        <input type="checkbox" name="completed2" <%= isCompleted ? "checked" : "" %>>
                        <input type="text" name="task2" value="<%= task %>" placeholder="할 일">
                    </li>
                    <% } %>
                </ul>
            </div>
            <div class="grid-item" data-label="3">
                <label>3순위</label>
                <ul>
                    <% for (int i = 0; i < 4; i++) {
                        String task = i < thirdTasks.size() ? thirdTasks.get(i) : "";
                        boolean isCompleted = i < thirdTasksCompleted.size() && thirdTasksCompleted.get(i);
                    %>
                    <li>
                        <input type="checkbox" name="completed3" <%= isCompleted ? "checked" : "" %>>
                        <input type="text" name="task3" value="<%= task %>" placeholder="할 일">
                    </li>
                    <% } %>
                </ul>
            </div>
            <div class="grid-item" data-label="4">
                <label>4순위</label>
                <ul>
                    <% for (int i = 0; i < 4; i++) {
                        String task = i < fourthTasks.size() ? fourthTasks.get(i) : "";
                        boolean isCompleted = i < fourthTasksCompleted.size() && fourthTasksCompleted.get(i);
                    %>
                    <li>
                        <input type="checkbox" name="completed4" <%= isCompleted ? "checked" : "" %>>
                        <input type="text" name="task4" value="<%= task %>" placeholder="할 일">
                    </li>
                    <% } %>
                </ul>
            </div>
            <div class="axis">
                <div class="horizontal"></div>
                <div class="vertical"></div>
                <div class="label importance">중요도</div>
                <div class="label urgency">긴급도</div>
            </div>
        </div>
        <div class="save-btn-container">
            <button type="submit" class="save-btn">저장</button>
        </div>
    </form>
</div>
</body>
</html>
