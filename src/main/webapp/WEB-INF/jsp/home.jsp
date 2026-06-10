<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>냉장고를 부탁해 - 홈</title>
    <style>
        /* 화면 전체를 여백 없이 꽉 채우는 설정 */
        body { 
            margin: 0; 
            padding: 0; 
            font-family: 'Malgun Gothic', sans-serif; 
            background-color: #f5f6f7;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh; /* 브라우저 높이 전체 사용 */
            width: 100vw;  /* 브라우저 너비 전체 사용 */
        }
        /* 컨테이너가 화면에 꽉 차도록 대형 레이아웃 설계 */
        .full-container { 
            width: 100%;
            max-width: 800px; /* 전체화면 감각을 주되 너무 퍼지지 않게 밸런스 조정 */
            padding: 50px; 
            text-align: center;
            background: #ffffff;
            border: 3px solid #000000;
            box-shadow: 10px 10px 0px #000000; /* 깔끔한 네오 브루탈리즘 스타일 */
            box-sizing: border-box;
        }
        h1 { font-size: 3.5rem; margin-bottom: 10px; font-weight: 900; letter-spacing: -1px; }
        .subtitle { font-size: 1.1rem; color: #666; margin-bottom: 40px; }
        
        /* 입력창을 가로로 시원하게 늘림 */
        .input-group { margin-bottom: 20px; width: 100%; }
        input { 
            width: 80%; 
            max-width: 500px;
            padding: 15px 20px; 
            font-size: 1.1rem; 
            border: 3px solid #000; 
            outline: none;
            box-sizing: border-box;
        }
        input:focus { background-color: #f0f0f0; }
        
        /* 버튼 디자인 키우기 */
        .btn-box { margin-top: 30px; }
        .btn { 
            width: 160px; 
            padding: 15px; 
            font-size: 1.1rem;
            font-weight: bold; 
            cursor: pointer; 
            margin: 0 10px;
            background: #ffffff; 
            border: 3px solid #000000;
            transition: 0.2s;
        }
        .btn:hover { background: #000000; color: #ffffff; box-shadow: -5px 5px 0px #00ffcc; }
    </style>
</head>
<body>
    <div class="full-container">
        <h1>냉장고를 부탁해~~</h1>
        <div class="subtitle">이용하시려면 로그인 버튼을 눌러주십시오</div>
        
        <form action="/login" method="post">
            <div class="input-group">
                <input type="text" name="userId" placeholder="아이디 입력" required>
            </div>
            <div class="input-group">
                <input type="password" name="password" placeholder="비밀번호 입력">
            </div>
            <div class="btn-box">
                <button type="submit" class="btn">로그인</button>
                <button type="button" class="btn" onclick="location.href='/signup'">회원가입</button>
            </div>
        </form>
    </div>
    <script>
        // 컨트롤러가 보낸 error 메시지나 회원가입 완료 message가 있으면 알림창을 띄웁니다.
        <% 
            String errorMsg = (String) request.getAttribute("error");
            if (errorMsg == null) {
                errorMsg = (String) session.getAttribute("error");
            }
            
            String successMsg = (String) request.getAttribute("message");
            if (successMsg == null) {
                successMsg = (String) session.getAttribute("message");
            }
        %>

        // 1. 로그인 실패 시 경고창
        <% if (errorMsg != null) { %>
            alert("<%= errorMsg %>");
        <% } %>

        // 2. 회원가입 성공 후 돌아왔을 때 안내창 (선택사항)
        <% if (successMsg != null) { %>
            alert("<%= successMsg %>");
        <% } %>
    </script>
</body>
</html>