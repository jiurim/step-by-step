<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 2024-06-17
  Time: 오후 7:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="application/json; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%

    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    String currentDate = request.getParameter("date");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String jsonResponse = "";

    try {
        String jdbcUrl = "jdbc:mysql://localhost:3306/stepbystep?useUnicode=true&characterEncoding=UTF-8";
        String dbId = "urim";
        String dbPass = "KKtamsl9207!";

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);

        String sql = "SELECT * FROM diarydb WHERE date < ? ORDER BY date DESC LIMIT 1";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, currentDate);

        rs = pstmt.executeQuery();

        if (rs.next()) {
            jsonResponse = String.format(
                "{\"success\": true, \"date\": \"%s\", \"mood\": \"%s\", \"situation\": \"%s\", \"thoughts\": \"%s\", \"actions\": \"%s\", \"results\": \"%s\"}",
                rs.getString("date"),
                rs.getString("mood"),
                rs.getString("situation"),
                rs.getString("thoughts"),
                rs.getString("actions"),
                rs.getString("results")
            );
        } else {
            jsonResponse = "{\"success\": false}";
        }
    } catch (Exception e) {
        e.printStackTrace();
        jsonResponse = "{\"success\": false, \"error\": \"" + e.getMessage() + "\"}";
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }

    out.print(jsonResponse);
%>
