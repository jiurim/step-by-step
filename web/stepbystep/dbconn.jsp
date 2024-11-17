<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 2024-06-13
  Time: 오전 1:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.*"%>

<%

    Connection conn=null;

  try{
	 String jdbcUrl = "jdbc:mysql://localhost:3306/stepbystep";
     String dbId = "urim";
     String dbPass = "KKtamsl9207!";

	 Class.forName("com.mysql.jdbc.Driver");
	 conn = DriverManager.getConnection(jdbcUrl,dbId ,dbPass );
  }catch(Exception e) {
      e.printStackTrace();
  }

%>