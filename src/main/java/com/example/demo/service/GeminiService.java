package com.example.demo.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;

@Service
public class GeminiService {

    @Value("${gemini.api.key}")
    private String apiKey;


    private final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=";

    public Map<String, String> getRecipeFromGemini(List<String> ingredients) {
        RestTemplate restTemplate = new RestTemplate();
        String url = GEMINI_API_URL + apiKey;

        String ingredientListStr = String.join(", ", ingredients);
        String prompt = String.format(
            "사용자가 가진 재료: [%s]. 이 재료들을 활용해서 만들 수 있는 최고의 요리 1가지를 추천해줘. " +
            "중요!!!실제로 존재하는 레시피만 추천해주세요"+
            "중요!!!재료는 다 사용할 필요는 없습니다"+
            "목록에 없는 재료는 절대 사용하지 마세요. 소금, 물, 식용유만 예외로 허용합니다."+
            "만약 재료가 너무 부족해서 요리를 만들 수 없다면, '재료가 부족합니다.'라는 문장을 반드시 제일 첫 줄에 포함시키고, " +
            "해당 요리를 만들기 위해 '최소한으로 추가해야 할 필수 재료'를 명시한 뒤 레시피를 안내해줘. " +
            "응답 포맷은 반드시 아래 형식을 완벽히 지켜서 출력해줘.\n" +
            "음식이름: [요리명]\n" +
            "레시피: [상세 요리 과정 설명]", ingredientListStr
        );

        Map<String, Object> requestBody = new HashMap<>();
        
        List<Map<String, Object>> contentsList = new ArrayList<>();
        Map<String, Object> contentMap = new HashMap<>();
        
        List<Map<String, Object>> partsList = new ArrayList<>();
        Map<String, Object> partMap = new HashMap<>();
        
        partMap.put("text", prompt);
        partsList.add(partMap);
        
        contentMap.put("parts", partsList);
        contentsList.add(contentMap);
        
        requestBody.put("contents", contentsList);

        try {
            // 구글 서버에 요청 후 결과 받기
            Map<String, Object> response = restTemplate.postForObject(url, requestBody, Map.class);
            
            List<Map<String, Object>> candidates = (List<Map<String, Object>>) response.get("candidates");
            Map<String, Object> firstCandidate = candidates.get(0);
            Map<String, Object> content = (Map<String, Object>) firstCandidate.get("content");
            List<Map<String, Object>> parts = (List<Map<String, Object>>) content.get("parts");
            String rawText = (String) parts.get(0).get("text");

            return parseGeminiResponse(rawText);
        } catch (Exception e) {
            Map<String, String> errorMap = new HashMap<>();
            errorMap.put("title", "AI 추천 오류");
            errorMap.put("recipe", "Gemini API 호출 및 데이터 분석에 실패했습니다. 에러 내용: " + e.getMessage());
            return errorMap;
        }
    }

    private Map<String, String> parseGeminiResponse(String rawText) {
        Map<String, String> resultMap = new HashMap<>();
        String title = "추천 요리";
        String recipe = rawText;

        if (rawText.contains("음식이름:")) {
            int titleIdx = rawText.indexOf("음식이름:");
            int recipeIdx = rawText.indexOf("레시피:");
            if (recipeIdx > titleIdx) {
                title = rawText.substring(titleIdx + 5, recipeIdx).trim();
                recipe = rawText.substring(recipeIdx + 4).trim();
            }
        }
        
        resultMap.put("title", title);
        resultMap.put("recipe", recipe.replace("\n", "<br>")); 
        return resultMap;
    }
}
