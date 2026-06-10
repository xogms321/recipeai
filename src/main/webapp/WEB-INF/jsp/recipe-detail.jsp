<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>과거 레시피 상세보기</title>
    <style>
        body { 
            margin: 0; padding: 0; 
            font-family: 'Malgun Gothic', sans-serif; 
            background-color: #f5f6f7;
            display: flex; justify-content: center; align-items: center;
            min-height: 100vh; width: 100vw;
            box-sizing: border-box; padding: 40px 0;
        }
        .full-container { 
            width: 100%; max-width: 900px; padding: 50px;
            background: #ffffff; border: 3px solid #000000;
            box-shadow: 10px 10px 0px #000000; box-sizing: border-box;
            position: relative;
        }
        h1 { font-size: 2.8rem; margin-top: 0; margin-bottom: 10px; font-weight: 900; color: #000; }
        .date { font-size: 1.1rem; color: #666; margin-bottom: 30px; font-weight: bold; }
        .recipe-box { 
            border: 3px solid #000; padding: 30px; min-height: 300px;
            background: #fafafa; font-size: 1.2rem; line-height: 1.8;
            text-align: left; white-space: normal; word-break: break-all;
        }
        .btn-box { margin-top: 40px; text-align: center; }
        .btn { 
            padding: 15px 40px; font-size: 1.1rem; font-weight: bold; 
            cursor: pointer; background: #000000; color: #ffffff; border: 3px solid #000000;
            transition: all 0.2s;
        }
        .btn:hover { box-shadow: -5px 5px 0px #00ffcc; color: #000; background: #fff; }
    </style>
</head>
<body>
    <div class="full-container">
        <h1>${recipe.title}</h1>
        <div class="date">저장 시간: ${recipe.date}</div>
        
        <div class="recipe-box">
            ${recipe.content}
        </div>
        
        <div class="btn-box">
            <button type="button" class="btn" onclick="location.href='/history'">목록으로 돌아가기</button>
        </div>
    </div>
</body>
</html>