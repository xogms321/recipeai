<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>레시피 기록 목록</title>
    <style>
        body { margin: 0; padding: 40px; font-family: 'Malgun Gothic', sans-serif; background-color: #f5f6f7; }
        .wrapper { width: 100%; max-width: 1200px; margin: 0 auto; background: #fff; border: 3px solid #000; padding: 40px; box-sizing: border-box; }
        .header-area { display: flex; justify-content: space-between; align-items: center; border-bottom: 3px solid #000; padding-bottom: 20px; }
        
        /* 와이드 대형 리스트 상자 */
        .list-box { border: 3px solid #000; min-height: 400px; padding: 25px; background: #fff; margin-top: 30px; }
        .recipe-item { border-bottom: 2px dashed #000; padding: 15px 10px; display: flex; justify-content: space-between; align-items: center; font-size: 1.2rem; }
        
        .back-btn { display: inline-block; margin-top: 30px; padding: 15px 30px; background: #000; color: #fff; text-decoration: none; font-size: 1.1rem; font-weight: bold; }
        .del-btn { background: red; color: #fff; border: 2px solid #000; padding: 8px 15px; font-size: 1rem; font-weight:bold; cursor: pointer; }
        .del-btn:hover { background: darkred; }
    </style>
</head>
<body>

<div class="wrapper">
    <div class="header-area">
        <h2>레시피 기록</h2>
        <form action="/logout" method="post">
            <button type="submit" style="background:#fff; border:2px solid #000; padding:10px 20px; font-weight:bold; cursor:pointer;">로그아웃</button>
        </form>
    </div>
    
    <div class="list-box">
        <h4 style="margin-top:0; font-size: 1.4rem;">레시피 목록</h4>
        <c:if test="${empty recipes}">
            <p style="color:gray; text-align:center; margin-top:100px; font-size:1.2rem;">저장된 레시피 기록이 없습니다.</p>
        </c:if>
        
        <c:forEach items="${recipes}" var="recipe" varStatus="status">
    		<div style="border: 3px solid #000; padding: 20px; margin-bottom: 15px; background: #fff; box-shadow: 5px 5px 0px #000; display: flex; justify-content: space-between; align-items: center;">
        
        	<div onclick="location.href='/history/detail?index=${status.index}'" style="cursor: pointer; flex-grow: 1; text-align: left;">
            	<h3 style="margin: 0 0 5px 0; font-size: 1.4rem; font-weight: 900; text-decoration: underline;">${recipe.title}</h3>
            	<span style="color: #666; font-size: 0.95rem;">저장일: ${recipe.date}</span>
        	</div>
        
        	<form action="/recipe/delete" method="post" style="margin: 0;">
            	<input type="hidden" name="index" value="${status.index}">
            	<button type="submit" style="background: #ff4d4d; color: #fff; border: 2px solid #000; padding: 10px 15px; font-weight: bold; cursor: pointer;">삭제</button>
        	</form>
    		</div>
		</c:forEach>
    </div>

    <a href="/main" class="back-btn">◀ 메인 화면으로 돌아가기</a>
</div>

</body>
</html>