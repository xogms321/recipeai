<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI 추천 레시피 결과</title>
    <style>
        body { margin: 0; padding: 40px; font-family: 'Malgun Gothic', sans-serif; background-color: #f5f6f7; }
        .wrapper { width: 100%; max-width: 1200px; margin: 0 auto; background: #fff; border: 3px solid #000; padding: 40px; box-sizing: border-box; }
        .header-area { display: flex; justify-content: space-between; align-items: center; border-bottom: 3px solid #000; padding-bottom: 20px; }
        
        /* 와이드 레시피 출력 박스 */
        .recipe-box { border: 3px solid #000; padding: 30px; min-height: 300px; margin: 30px 0; background: #f9f9f9; font-size: 1.2rem; line-height: 1.8; }
        
        .btn-group { text-align: center; margin-top: 30px; }
        .btn { padding: 15px 40px; margin: 0 15px; font-size: 1.2rem; font-weight: bold; cursor: pointer; background: #fff; border: 3px solid #000; }
        .btn-save { background: #000; color: #fff; }
        .btn-save:hover { background: #333; }
    </style>
</head>
<body>

<div class="wrapper">
    <div class="header-area">
        <h2>AI 요리 추천 결과</h2>
        <form action="/logout" method="post">
            <button type="submit" style="background:#fff; border:2px solid #000; padding:10px 20px; font-weight:bold; cursor:pointer;">로그아웃</button>
        </form>
    </div>
    
    <h3 style="font-size: 1.8rem; margin-top: 30px;">음식이름: <span style="color: green; font-weight:900;">${recipeTitle}</span></h3>
    
    <div class="recipe-box">
        <h4 style="margin-top:0; font-size:1.4rem; border-bottom:1px solid #ccc; padding-bottom:10px;">해당음식 레시피</h4>
        <p>${recipeContent}</p>
    </div>

    <div class="btn-group">
        <form action="/recipe/save" method="post" style="display: inline;">
            <input type="hidden" name="title" value="${recipeTitle}">
            <input type="hidden" name="content" value="${recipeContent}">
            <button type="submit" class="btn btn-save">저장</button>
        </form>
        <button type="button" class="btn" onclick="location.href='/main'">저장하지 않고 나가기</button>
    </div>
</div>

</body>
</html>