<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>냉장고를 부탁해 - 메인</title>
    <style>
        body { margin: 0; padding: 40px; font-family: 'Malgun Gothic', sans-serif; background-color: #f5f6f7; }
        /* 너비를 100%로 채워 브라우저 전체 화면을 사용 */
        .wrapper { width: 100%; max-width: 1200px; margin: 0 auto; background: #fff; border: 3px solid #000; padding: 40px; box-sizing: border-box; position: relative; }
        
        .header-area { display: flex; justify-content: space-between; align-items: center; border-bottom: 3px solid #000; padding-bottom: 20px; }
        .logout-btn { background: #fff; border: 2px solid #000; font-weight: bold; cursor: pointer; padding: 10px 20px; font-size: 1rem; }
        .logout-btn:hover { background: red; color: #fff; }
        
        /* 대형 재료 보관 상자 */
        .ingredient-box { border: 3px solid #000; width: 100%; min-height: 200px; margin: 30px 0; padding: 25px; overflow-y: auto; background: #fafafa; box-sizing: border-box; }
        .tag { display: inline-flex; align-items: center; background: #000; color: #fff; padding: 10px 18px; margin: 8px; font-size: 1.1rem; font-weight: bold; }
        .tag form { display: inline; margin-left: 10px; }
        .tag button { background: none; border: none; color: #ff5555; font-size: 1.2rem; font-weight: bold; cursor: pointer; }
        
        /* 입력창 전체화면 비율 맞춤 */
        .input-form { display: flex; gap: 15px; margin: 30px 0; width: 100%; }
        .input-form input { flex: 1; padding: 15px; border: 3px solid #000; font-size: 1.2rem; }
        .input-form button { padding: 15px 40px; background: #000; color: #fff; font-size: 1.2rem; font-weight: bold; border: none; cursor: pointer; }
        .input-form button:hover { background: #333; }
        
        /* 거대한 실행 버튼 */
        .submit-btn { width: 100%; padding: 25px; background-color: #fff; border: 4px solid #000; font-size: 1.6rem; font-weight: 900; cursor: pointer; transition: 0.2s; }
        .submit-btn:hover { background: #00ffcc; color: #000; box-shadow: 0px 5px 0px #000; }
        .history-link { display: block; margin-top: 25px; text-align: right; color: blue; text-decoration: none; font-size: 1.1rem; font-weight: bold; }
    </style>
</head>
<body>

<div class="wrapper">
    <div class="header-area">
        <div>
            <h2>내가 추가한 음식 재료 목록</h2>
            <span style="font-size:14px; color:gray;">로그아웃해도 재료가 기억에 남아있습니다.</span>
        </div>
        <form action="/logout" method="post">
            <button type="submit" class="logout-btn">로그아웃</button>
        </form>
    </div>
    
    <div class="ingredient-box">
        <c:forEach var="item" items="${ingredients}" varStatus="status">
            <span class="tag">
                ${item}
                <form action="/ingredient/delete" method="post">
                    <input type="hidden" name="index" value="${status.index}">
                    <button type="submit">X</button>
                </form>
            </span>
        </c:forEach>
    </div>

    <form action="/ingredient/add" method="post" class="input-form">
        <input type="text" name="name" placeholder="텍스트창에 재료를 적고 음식 추가 버튼 누르기" required>
        <button type="submit">재료 추가</button>
    </form>

    <button class="submit-btn" onclick="location.href='/recommend'">오늘의 음식은.......?</button>
    
    <a href="/history" class="history-link">▶ 저장된 레시피 기록 보러가기</a>
</div>

</body>
</html>