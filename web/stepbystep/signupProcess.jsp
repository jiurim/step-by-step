<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 2024-06-13
  Time: 오후 1:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    String user_id = request.getParameter("user_id");
    String passwd = request.getParameter("passwd");
    String email = request.getParameter("email");
    String gender = request.getParameter("gender");

    // Gender 값을 'm' 또는 'f'로 변경
    if ("남성".equals(gender)) {
        gender = "m";
    } else if ("여성".equals(gender)) {
        gender = "f";
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        String jdbcUrl = "jdbc:mysql://localhost:3306/stepbystep";
        String dbId = "urim";
        String dbPass = "KKtamsl9207!";

        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);

        String sql = "INSERT INTO members (user_id, passwd, email, gender) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, user_id);
        pstmt.setString(2, passwd);
        pstmt.setString(3, email);
        pstmt.setString(4, gender);

        int result = pstmt.executeUpdate();

        if (result > 0) {
            // 회원가입 성공 시 로그인 페이지로 이동
            response.sendRedirect("login.jsp");
        } else {
            // 회원가입 실패 시 메시지 표시
            out.println("<script>alert('회원가입에 실패했습니다. 다시 시도해 주세요.'); history.back();</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('회원가입에 실패했습니다. 다시 시도해 주세요.'); history.back();</script>");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>

