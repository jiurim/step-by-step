<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.io.*, java.net.*" %>
<%@ page import="net.sf.json.*" %>
<%@ page session="true" %>
<%

    request.setCharacterEncoding("UTF-8");

    String userId = (String) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String date = request.getParameter("date");
    String situation = request.getParameter("situation");
    String thoughts = request.getParameter("thoughts");
    String actions = request.getParameter("actions");
    String results = request.getParameter("results");
    String diaryContent = situation + " " + thoughts + " " + actions + " " + results;

    int moodScore = 0;
    String mood = "";
    String sentiment = ""; // 감정 분석 결과를 저장하는 변수

    if (diaryContent != null && !diaryContent.isEmpty()) {
        String apiURL = "https://naveropenapi.apigw.ntruss.com/sentiment-analysis/v1/analyze";
        String clientId = "jl64c3ev8o"; // 클로바 API 클라이언트 ID
        String clientSecret = "g4LtVk725Wb08gpWYOAJMSCR6T70uThrbYXIFxOs"; // 클로바 API 클라이언트 시크릿

        try {
            URL url = new URL(apiURL);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            con.setRequestProperty("X-NCP-APIGW-API-KEY-ID", clientId);
            con.setRequestProperty("X-NCP-APIGW-API-KEY", clientSecret);

            // 요청 JSON 생성
            String jsonMessage = "{\"content\":\"" + diaryContent.replaceAll("\n", " ").replaceAll("\"", "\\\"") + "\"}";
            con.setDoOutput(true);
            OutputStream os = con.getOutputStream();
            byte[] input = jsonMessage.getBytes("utf-8");
            os.write(input, 0, input.length);
            os.flush();
            os.close();

            int responseCode = con.getResponseCode();
            BufferedReader br;
            if (responseCode == 200) { // 정상 호출
                br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
            } else { // 오류 발생
                br = new BufferedReader(new InputStreamReader(con.getErrorStream(), "utf-8"));
            }
            String inputLine;
            StringBuffer apiResponse = new StringBuffer();
            while ((inputLine = br.readLine()) != null) {
                apiResponse.append(inputLine);
            }
            br.close();

            // JSON 파싱 및 감정 점수 추출
            String responseBody = apiResponse.toString();

            // 전체 응답을 로그에 기록
            System.out.println("API Response: " + responseBody);

            JSONObject jsonResponse = JSONObject.fromObject(responseBody);

            if (jsonResponse.has("document")) {
                JSONObject document = jsonResponse.getJSONObject("document");
                if (document.has("sentiment")) {
                    sentiment = document.getString("sentiment");

                    // 감정 점수를 계산하는 로직
                    if ("positive".equals(sentiment)) {
                        moodScore = 5;
                        mood = "good";
                    } else if ("neutral".equals(sentiment)) {
                        moodScore = 3;
                        mood = "soso";
                    } else if ("negative".equals(sentiment)) {
                        moodScore = 1;
                        mood = "down";
                    }
                } else {
                    // sentiment 키가 존재하지 않을 때 처리
                    mood = "unknown";
                }
            } else {
                // document 키가 존재하지 않을 때 처리
                mood = "unknown";
            }

            // 로그에 감정 분석 결과 기록
            System.out.println("Sentiment: " + sentiment);
            System.out.println("Mood Score: " + moodScore);
            System.out.println("Mood: " + mood);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 감정 분석 결과를 데이터베이스에 저장
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/stepbystep", "urim", "KKtamsl9207!");
        String sql = "INSERT INTO diarydb (user_id, date, mood, moodScore, situation, thoughts, actions, results) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        pstmt.setString(2, date);
        pstmt.setString(3, mood);
        pstmt.setInt(4, moodScore);
        pstmt.setString(5, situation);
        pstmt.setString(6, thoughts);
        pstmt.setString(7, actions);
        pstmt.setString(8, results);
        pstmt.executeUpdate();
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

    response.sendRedirect("diary.jsp");
%>
