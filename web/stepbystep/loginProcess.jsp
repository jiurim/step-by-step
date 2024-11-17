<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 2024-06-13
  Time: 오전 1:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>

<%

    String user_id = request.getParameter("user_id");
    String passwd = request.getParameter("passwd");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    boolean isValidUser = false;

    try {
        String jdbcUrl = "jdbc:mysql://localhost:3306/stepbystep";
        String dbId = "urim";
        String dbPass = "KKtamsl9207!";

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);

        String sql = "SELECT * FROM members WHERE user_id = ? AND passwd = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, user_id);
        pstmt.setString(2, passwd);

        rs = pstmt.executeQuery();

        if (rs.next()) {
            isValidUser = true;
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }

    if (isValidUser) {
        // 로그인 성공 시 세션 설정
        HttpSession session1 = request.getSession();
        session.setAttribute("user_id", user_id);
        response.sendRedirect("main.jsp");
    } else {
        // 로그인 실패 시 메시지 표시
        out.println("<script>alert('아이디 또는 비밀번호가 잘못되었습니다.'); history.back();</script>");
    }
%>