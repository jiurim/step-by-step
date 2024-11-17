<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>차곡차곡</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
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
            width: 50%;
            margin: 20px auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            position: relative;
        }
        .back-arrow {
            position: absolute;
            top: 50%;
            left: 30px;
            cursor: pointer;
            display: flex;
            align-items: center;
            transform: translateY(-50%);
        }
        .back-arrow img {
            margin-right: 5px;
        }
        .tip {
            background-color: #fff5e1;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 20px;
            text-align: center;
        }
        .form-container {
            background-color: #f0e6d6;
            padding: 20px;
            border-radius: 8px;
        }
        .form-container input, .form-container textarea {
            width: calc(100% - 40px);
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            display: block;
            margin-left: 20px;
            margin-right: 20px;
        }
        .form-container button {
            width: calc(100% - 40px);
            padding: 10px;
            background-color: #fff5e1;
            color: black;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-left: 20px;
            margin-right: 20px;
        }
        .form-container button:hover {
            background-color: #fff5e1;
        }
        .form-container .date-mood-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }
    </style>
    <script>
        function loadPreviousEntry() {
            fetch('loadDiary.jsp')
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        document.querySelector('input[name="date"]').value = data.date;
                        document.querySelector('textarea[name="situation"]').value = data.situation;
                        document.querySelector('textarea[name="thoughts"]').value = data.thoughts;
                        document.querySelector('textarea[name="actions"]').value = data.actions;
                        document.querySelector('textarea[name="results"]').value = data.results;
                        selectMood(data.mood); // Set the mood
                    } else {
                        alert('No previous entry found.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Failed to load previous entry.');
                });
        }

        function selectMood(mood) {
            const moodInput = document.getElementById('moodInput');
            moodInput.value = mood;
            let score;
            if (mood === 'good') score = 5;
            else if (mood === 'soso') score = 3;
            else if (mood === 'down') score = 1;

            // Store the mood score in a hidden input for form submission
            document.getElementById('moodScore').value = score;
        }
    </script>
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
            <a href="logout.jsp">로그아웃</a>
        </nav>
    </div>
    <div class="container">
        <div class="back-arrow" onclick="loadPreviousEntry()">
            <img src="../static/left.png" alt="Back" width="20">
        </div>
        <div class="tip">
            Tip » 최대한 지우지 않고 작성해주세요! 다 작성 후 지우는걸 추천드립니다
        </div>
        <div class="form-container">
            <form action="saveDiary.jsp" method="post">
                <div class="date-mood-container">
                    <input type="date" name="date" required>
                </div>
                <input type="hidden" id="moodScore" name="moodScore" value="">
                <textarea name="situation" placeholder="상황"></textarea>
                <textarea name="thoughts" placeholder="생각/느낌"></textarea>
                <textarea name="actions" placeholder="행동"></textarea>
                <textarea name="results" placeholder="결과"></textarea>
                <button type="submit">저장 하기</button>
            </form>
        </div>
    </div>
</body>
</html>
