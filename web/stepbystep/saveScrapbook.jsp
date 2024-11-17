<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 2024-06-19
  Time: 오후 8:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.io.*" %>
<%@ page import="net.sf.json.*" %>
<%@ page session="true" %>

<%
    String userId = (String) session.getAttribute("user_id");
    if (userId == null) {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        return;
    }

    StringBuilder jsonBuilder = new StringBuilder();
    String line;
    try (BufferedReader reader = request.getReader()) {
        while ((line = reader.readLine()) != null) {
            jsonBuilder.append(line);
        }
    } catch (IOException e) {
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        return;
    }

    String jsonString = jsonBuilder.toString();
    JSONObject json = JSONObject.fromObject(jsonString);

    String background = json.getString("background");
    JSONArray items = json.getJSONArray("items");
    String text = "";
    String imageUrl = "";

    for (int i = 0; i < items.size(); i++) {
        JSONObject item = items.getJSONObject(i);
        String content = item.getString("content");
        if (content.contains("<img")) { // 이미지 URL 추출
            int srcIndex = content.indexOf("src=\"") + 5;
            int endSrcIndex = content.indexOf("\"", srcIndex);
            imageUrl = content.substring(srcIndex, endSrcIndex);
        } else {
            text = content; // 텍스트 내용
        }
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/stepbystep?useUnicode=true&characterEncoding=UTF-8", "urim", "KKtamsl9207!");
        String sql = "REPLACE INTO scrapbook (user_id, background, text, image_url) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        pstmt.setString(2, background);
        pstmt.setString(3, text);
        pstmt.setString(4, imageUrl);
        pstmt.executeUpdate();
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    response.setStatus(HttpServletResponse.SC_OK);
%>
