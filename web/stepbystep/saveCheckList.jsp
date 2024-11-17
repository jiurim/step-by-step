<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>
<%
    request.setCharacterEncoding("UTF-8");

    String userId = (String) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    // 요청으로부터 할 일 항목을 가져옴
    String[] tasks1 = request.getParameterValues("task1");
    String[] tasks2 = request.getParameterValues("task2");
    String[] tasks3 = request.getParameterValues("task3");
    String[] tasks4 = request.getParameterValues("task4");
    String[] completedTasks = request.getParameterValues("completedTask");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/stepbystep?useUnicode=true&characterEncoding=UTF-8", "urim", "KKtamsl9207!");

        // 기존 항목 삭제
        String deleteSql = "DELETE FROM check_list WHERE user_id = ?";
        pstmt = conn.prepareStatement(deleteSql);
        pstmt.setString(1, userId);
        pstmt.executeUpdate();
        pstmt.close();

        // 새로운 항목 삽입 또는 업데이트
        String insertSql = "INSERT INTO check_list (user_id, first, second, third, fourth, is_completed, quadrant) VALUES (?, ?, ?, ?, ?, ?, ?)";

        if (tasks1 != null) {
            for (String task : tasks1) {
                if (task != null && !task.trim().isEmpty()) {
                    pstmt = conn.prepareStatement(insertSql);
                    pstmt.setString(1, userId);
                    pstmt.setString(2, task);
                    pstmt.setString(3, "");
                    pstmt.setString(4, "");
                    pstmt.setString(5, "");
                    pstmt.setBoolean(6, completedTasks != null && Arrays.asList(completedTasks).contains(task));
                    pstmt.setInt(7, 1); // 1순위
                    pstmt.executeUpdate();
                    pstmt.close();
                }
            }
        }

        if (tasks2 != null) {
            for (String task : tasks2) {
                if (task != null && !task.trim().isEmpty()) {
                    pstmt = conn.prepareStatement(insertSql);
                    pstmt.setString(1, userId);
                    pstmt.setString(2, "");
                    pstmt.setString(3, task);
                    pstmt.setString(4, "");
                    pstmt.setString(5, "");
                    pstmt.setBoolean(6, completedTasks != null && Arrays.asList(completedTasks).contains(task));
                    pstmt.setInt(7, 2); // 2순위
                    pstmt.executeUpdate();
                    pstmt.close();
                }
            }
        }

        if (tasks3 != null) {
            for (String task : tasks3) {
                if (task != null && !task.trim().isEmpty()) {
                    pstmt = conn.prepareStatement(insertSql);
                    pstmt.setString(1, userId);
                    pstmt.setString(2, "");
                    pstmt.setString(3, "");
                    pstmt.setString(4, task);
                    pstmt.setString(5, "");
                    pstmt.setBoolean(6, completedTasks != null && Arrays.asList(completedTasks).contains(task));
                    pstmt.setInt(7, 3); // 3순위
                    pstmt.executeUpdate();
                    pstmt.close();
                }
            }
        }

        if (tasks4 != null) {
            for (String task : tasks4) {
                if (task != null && !task.trim().isEmpty()) {
                    pstmt = conn.prepareStatement(insertSql);
                    pstmt.setString(1, userId);
                    pstmt.setString(2, "");
                    pstmt.setString(3, "");
                    pstmt.setString(4, "");
                    pstmt.setString(5, task);
                    pstmt.setBoolean(6, completedTasks != null && Arrays.asList(completedTasks).contains(task));
                    pstmt.setInt(7, 4); // 4순위
                    pstmt.executeUpdate();
                    pstmt.close();
                }
            }
        }

        response.sendRedirect("CheckList.jsp");
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
