<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>냉장고를 부탁해 - 회원가입</title>
    <style>
        body { 
            margin: 0; padding: 0; 
            font-family: 'Malgun Gothic', sans-serif; 
            background-color: #f5f6f7;
            display: flex; justify-content: center; align-items: center;
            height: 100vh; width: 100vw;
        }
        .full-container { 
            width: 100%; max-width: 600px; padding: 50px; text-align: center;
            background: #ffffff; border: 3px solid #000000;
            box-shadow: 10px 10px 0px #000000; box-sizing: border-box;
        }
        h1 { font-size: 2.5rem; margin-bottom: 30px; font-weight: 900; }
        .input-group { margin-bottom: 20px; width: 100%; text-align: left; max-width: 400px; margin-left: auto; margin-right: auto; }
        .input-group label { display: block; font-weight: bold; margin-bottom: 5px; font-size: 1rem; }
        input { 
            width: 100%; padding: 15px; font-size: 1.1rem; 
            border: 3px solid #000; outline: none; box-sizing: border-box;
        }
        .btn-box { margin-top: 40px; }
        .btn { 
            width: 160px; padding: 15px; font-size: 1.1rem; font-weight: bold; 
            cursor: pointer; margin: 0 10px; background: #ffffff; border: 3px solid #000000;
        }
        .btn-submit { background: #000000; color: #ffffff; }
        .btn:hover { box-shadow: -5px 5px 0px #00ffcc; color: #000; background: #fff; }
        .btn-submit:hover { background: #00ffcc; color: #000; }
    </style>
</head>
<body>
    <div class="full-container">
        <h1>회원가입</h1>
        
        <form action="/signup" method="post">
            <div class="input-group">
                <label>아이디</label>
                <input type="text" name="userId" placeholder="사용할 아이디 입력" required>
            </div>
            <div class="input-group">
                <label>비밀번호</label>
                <input type="password" name="password" placeholder="비밀번호 입력" required>
            </div>
            <div class="input-group">
                <label>이름</label>
                <input type="text" name="userName" placeholder="이름 입력" required>
            </div>
            
            <div class="btn-box">
                <button type="submit" class="btn btn-submit">가입완료</button>
                <button type="button" class="btn" onclick="location.href='/'">취소</button>
            </div>
        </form>
    </div>
    <script>
        // 컨트롤러가 보낸 error 메시지가 있으면 알림창(alert)을 띄웁니다.
        <% if (request.getAttribute("error") != null || session.getAttribute("error") != null) { 
            // RedirectAttributes의 FlashAttribute는 세션에 잠시 저장되므로 둘 다 체크합니다.
            String errorMsg = (String) request.getAttribute("error");
            if (errorMsg == null) {
                errorMsg = (String) session.getAttribute("error");
            }
        %>
            alert("<%= errorMsg %>");
        <% } %>
    </script> 
</body>
</html>