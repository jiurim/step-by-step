<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 2024-06-17
  Time: 오후 7:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.*" %>
<%

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

        String sql = "SELECT date, mood FROM diarydb ORDER BY date";
        pstmt = conn.prepareStatement(sql);

        rs = pstmt.executeQuery();

        StringBuilder dates = new StringBuilder();
        StringBuilder scores = new StringBuilder();

        dates.append("[");
        scores.append("[");

        while (rs.next()) {
            if (dates.length() > 1) {
                dates.append(",");
                scores.append(",");
            }
            dates.append("\"").append(rs.getString("date")).append("\"");
            String mood = rs.getString("mood");
            int score = 0;
            if ("good".equals(mood)) score = 5;
            else if ("soso".equals(mood)) score = 3;
            else if ("down".equals(mood)) score = 1;
            scores.append(score);
        }

        dates.append("]");
        scores.append("]");

        jsonResponse = String.format("{\"success\": true, \"dates\": %s, \"scores\": %s}", dates.toString(), scores.toString());
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
