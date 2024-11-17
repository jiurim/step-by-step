<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 2024-06-19
  Time: 오전 9:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.io.*, java.net.*" %>
<%@ page import="net.sf.json.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>다꾸 페이지</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .header {
            width: 100%;
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

        .control-panel {
            margin: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .control-panel .background-options {
            display: flex;
            justify-content: center;
            margin-bottom: 10px;
        }

        .control-panel button {
            padding: 10px 20px;
            background-color: #84A6FF;
            color: #fff;
            border-radius: 8px;
            cursor: pointer;
            border: none;
            margin-right: 10px;
            margin-bottom: 10px;
            text-align: center;
        }

        .container {
            width: 90%;
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-size: cover;
            background-position: center;
            position: relative;
            overflow: hidden;
            min-height: 600px;
        }

        .item {
            position: absolute;
            border: 1px dashed #000;
            padding: 5px;
            cursor: move;
        }

        .save-btn-container {
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
<div class="control-panel">
    <div class="background-options">
        <button class="background-option"
                onclick="document.getElementById('canvas').style.backgroundImage = 'url(../static/note1.png)';">Note 1
        </button>
        <button class="background-option"
                onclick="document.getElementById('canvas').style.backgroundImage = 'url(../static/note2.jpg)';">Note 2
        </button>
        <button class="background-option"
                onclick="document.getElementById('canvas').style.backgroundImage = 'url(../static/note3.png)';">Note 3
        </button>
        <button class="background-option"
                onclick="document.getElementById('canvas').style.backgroundImage = 'url(../static/note4.png)';">Note 4
        </button>
    </div>
    <button onclick="addTextItem()">텍스트 추가</button>
    <button onclick="addImageItem()">이미지 추가</button>
</div>
<div class="container" id="canvas">
    <!-- 사용자가 추가한 요소들이 여기에 위치 -->
</div>
<div class="save-btn-container">
    <button class="save-btn" onclick="saveScrapbook()">저장</button>
</div>

<script>
    function addTextItem() {
        const item = document.createElement('div');
        item.className = 'item';
        item.textContent = '텍스트를 입력하세요';
        item.style.position = 'absolute';
        item.style.left = '10px';
        item.style.top = '10px';
        item.style.cursor = 'move'; // Initially show move cursor
        document.getElementById('canvas').appendChild(item);
        makeDraggable(item);
    }

    function addImageItem() {
        const input = document.createElement('input');
        input.type = 'file';
        input.accept = 'image/*';
        input.style.display = 'none';
        input.onchange = function (event) {
            const file = event.target.files[0];
            const reader = new FileReader();
            reader.onload = function (e) {
                const item = document.createElement('div');
                item.className = 'item';
                item.style.position = 'absolute';
                const img = document.createElement('img');
                img.src = e.target.result;
                img.style.maxWidth = '100%';
                img.style.maxHeight = '100%';
                item.appendChild(img);
                item.style.left = '10px';
                item.style.top = '10px';
                document.getElementById('canvas').appendChild(item);
                makeDraggable(item);
            };
            reader.readAsDataURL(file);
        };
        input.click();
    }

    function makeDraggable(element) {
        let isDragging = false;
        let startX = 0, startY = 0, offsetX = 0, offsetY = 0;

        element.addEventListener('mousedown', function (e) {
            // If the element is editable and the click is inside the content, skip dragging
            if (element.contentEditable === "true" && e.target.isSameNode(element)) {
                return; // 텍스트 편집 중인 경우 드래그 무시
            }

            e.preventDefault(); // 기본 이벤트 방지

            isDragging = true;
            startX = e.clientX;
            startY = e.clientY;
            offsetX = parseInt(element.style.left, 10) - startX;
            offsetY = parseInt(element.style.top, 10) - startY;

            document.addEventListener("mousemove", startMove);
            document.addEventListener("mouseup", stopMove);
        });

        function startMove(e) {
            if (isDragging) {
                element.style.left = e.clientX + offsetX + 'px';
                element.style.top = e.clientY + offsetY + 'px';
            }
        }

        function stopMove() {
            if (isDragging) {
                isDragging = false;
                document.removeEventListener("mousemove", startMove);
                document.removeEventListener("mouseup", stopMove);
            }
        }

        // Enable text editing on double click to clearly differentiate modes
        element.addEventListener('dblclick', function () {
            element.contentEditable = "true";
            element.style.cursor = 'text'; // Show text cursor
        });

        // Disable text editing when clicking outside the text element
        document.addEventListener('click', function (e) {
            if (!element.contains(e.target)) {
                element.contentEditable = "false";
                element.style.cursor = 'move'; // Show move cursor when not editing
            }
        });
    }

    window.onload = function () {
        document.querySelectorAll('.item').forEach(makeDraggable);
    };

    function saveScrapbook() {
        const items = document.querySelectorAll('.item');
        const canvas = document.getElementById('canvas');
        const data = {
            background: canvas.style.backgroundImage.slice(5, -2),
            items: []
        };
        items.forEach(item => {
            const rect = item.getBoundingClientRect();
            const canvasRect = canvas.getBoundingClientRect();
            data.items.push({
                content: item.innerHTML,
                left: rect.left - canvasRect.left,
                top: rect.top - canvasRect.top,
                width: rect.width,
                height: rect.height
            });
        });
        const xhr = new XMLHttpRequest();
        xhr.open('POST', 'saveScrapbook.jsp', true);
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.send(JSON.stringify(data));
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    alert('저장되었습니다.');
                } else {
                    alert('저장에 실패했습니다.');
                }
            }
        };
    }
</script>
</body>
</html>
