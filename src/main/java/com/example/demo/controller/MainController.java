package com.example.demo.controller;

import com.example.demo.service.GeminiService;
import jakarta.servlet.http.HttpSession;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
public class MainController {

    private final GeminiService geminiService;
    private final JdbcTemplate jdbcTemplate; // ⭐️ MySQL 연동을 위한 전용 템플릿 주입

    public MainController(GeminiService geminiService, JdbcTemplate jdbcTemplate) {
        this.geminiService = geminiService;
        this.jdbcTemplate = jdbcTemplate;
    }
    @GetMapping("/test")
    @ResponseBody
    public String test() {
        return "Controller OK";
    }

    @GetMapping("/")
    public String home() {
        return "home";
    }

    @PostMapping("/login")
    public String login(
            @RequestParam("userId") String userId, 
            @RequestParam("password") String password, 
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        // ⭐️ DB에서 해당 아이디의 회원 정보 조회
        String sql = "SELECT password FROM users WHERE user_id = ?";
        List<String> results = jdbcTemplate.query(sql, (rs, rowNum) -> rs.getString("password"), userId);
        
        if (!results.isEmpty()) {
            String savedPassword = results.get(0);
            if (!savedPassword.equals(password)) {
                redirectAttributes.addFlashAttribute("error", "비밀번호가 일치하지 않습니다.");
                return "redirect:/";
            }
        } else {
            redirectAttributes.addFlashAttribute("error", "존재하지 않는 아이디입니다. 회원가입을 해주세요.");
            return "redirect:/";
        }

        // 로그인 성공 시 세션에 아이디 저장
        session.setAttribute("userId", userId);
        return "redirect:/main";
    }

    @PostMapping("/logout")
    public String logout(HttpSession session) {
        session.removeAttribute("userId");
        return "redirect:/";
    }

    @GetMapping("/main")
    public String mainPage(HttpSession session, Model model) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) return "redirect:/";
        
        // ⭐️ DB에서 현재 로그인한 사용자의 냉장고 재료 리스트만 정확히 조회
        String sql = "SELECT name FROM ingredients WHERE user_id = ?";
        List<String> ingredients = jdbcTemplate.query(sql, (rs, rowNum) -> rs.getString("name"), userId);
        
        model.addAttribute("ingredients", ingredients);
        return "main-view";
    }

    @PostMapping("/ingredient/add")
    public String addIngredient(@RequestParam("name") String name, HttpSession session) {
        String userId = (String) session.getAttribute("userId");
        if (userId != null && !name.trim().isEmpty()) {
            // ⭐️ DB의 ingredients 테이블에 새 재료 행 추가(INSERT)
            String sql = "INSERT INTO ingredients (user_id, name) VALUES (?, ?)";
            jdbcTemplate.update(sql, userId, name.trim());
        }
        return "redirect:/main";
    }

    @PostMapping("/ingredient/delete")
    public String deleteIngredient(@RequestParam("index") int index, HttpSession session) {
        String userId = (String) session.getAttribute("userId");
        if (userId != null) {
            // 순서 정렬 상태 확인 후 해당 유저의 n번째 아이템 고유 ID를 찾아서 삭제 처리
            String selectSql = "SELECT id FROM ingredients WHERE user_id = ?";
            List<Integer> ids = jdbcTemplate.query(selectSql, (rs, rowNum) -> rs.getInt("id"), userId);
            
            if (index >= 0 && index < ids.size()) {
                int targetDbId = ids.get(index);
                String deleteSql = "DELETE FROM ingredients WHERE id = ?";
                jdbcTemplate.update(deleteSql, targetDbId);
            }
        }
        return "redirect:/main";
    }

    @GetMapping("/recommend")
    public String recommendRecipe(HttpSession session, Model model) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) return "redirect:/";

        // DB에서 현재 유저의 재료들 다시 긁어오기
        String sql = "SELECT name FROM ingredients WHERE user_id = ?";
        List<String> ingredients = jdbcTemplate.query(sql, (rs, rowNum) -> rs.getString("name"), userId);

        if (ingredients.isEmpty()) {
            return "redirect:/main";
        }

        Map<String, String> recipeResult = geminiService.getRecipeFromGemini(ingredients);
        model.addAttribute("recipeTitle", recipeResult.get("title"));
        model.addAttribute("recipeContent", recipeResult.get("recipe"));
        
        return "recipe-view";
    }

    @PostMapping("/recipe/save")
    public String saveRecipe(@RequestParam("title") String title, @RequestParam("content") String content, HttpSession session) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) return "redirect:/";

        // ⭐️ DB의 saved_recipes 테이블에 레시피 영구 저장
        String sql = "INSERT INTO saved_recipes (user_id, title, content, save_date) VALUES (?, ?, ?, ?)";
        String formattedDate = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        
        jdbcTemplate.update(sql, userId, title, content, formattedDate);
        return "redirect:/history";
    }

    @GetMapping("/history")
    public String historyPage(HttpSession session, Model model) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) return "redirect:/";
        
        // ⭐️ DB에서 현재 유저가 보관한 레시피 목록만 로드
        String sql = "SELECT title, save_date FROM saved_recipes WHERE user_id = ?";
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, userId);
        
        List<Map<String, String>> savedRecipes = new ArrayList<>();
        for (Map<String, Object> row : rows) {
            Map<String, String> recipe = Map.of(
                "title", String.valueOf(row.get("title")),
                "date", String.valueOf(row.get("save_date"))
            );
            savedRecipes.add(recipe);
        }
        
        model.addAttribute("recipes", savedRecipes);
        return "recipe-history";
    }

    @GetMapping("/history/detail")
    public String recipeDetail(@RequestParam("index") int index, HttpSession session, Model model) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) return "redirect:/";

        // 유저 고유 레시피들의 전체 컬럼 데이터를 DB에서 순서대로 들고 옴
        String sql = "SELECT title, content, save_date FROM saved_recipes WHERE user_id = ?";
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, userId);
        
        if (index >= 0 && index < rows.size()) {
            Map<String, Object> row = rows.get(index);
            Map<String, String> recipe = Map.of(
                "title", String.valueOf(row.get("title")),
                "content", String.valueOf(row.get("content")),
                "date", String.valueOf(row.get("save_date"))
            );
            model.addAttribute("recipe", recipe);
            return "recipe-detail";
        }
        return "redirect:/history";
    }

    @PostMapping("/recipe/delete")
    public String deleteRecipe(@RequestParam("index") int index, HttpSession session) {
        String userId = (String) session.getAttribute("userId");
        if (userId != null) {
            String selectSql = "SELECT id FROM saved_recipes WHERE user_id = ?";
            List<Integer> ids = jdbcTemplate.query(selectSql, (rs, rowNum) -> rs.getInt("id"), userId);
            
            if (index >= 0 && index < ids.size()) {
                int targetDbId = ids.get(index);
                String deleteSql = "DELETE FROM saved_recipes WHERE id = ?";
                jdbcTemplate.update(deleteSql, targetDbId);
            }
        }
        return "redirect:/history";
    }

    @GetMapping("/signup")
    public String signupView() {
        return "signup"; 
    }

    @PostMapping("/signup")
    public String doSignup(
            @RequestParam("userId") String userId,
            @RequestParam("password") String password,
            @RequestParam("userName") String userName,
            RedirectAttributes redirectAttributes) {
        
        // ⭐️ DB 아이디 중복 검사
        String checkSql = "SELECT COUNT(*) FROM users WHERE user_id = ?";
        Integer count = jdbcTemplate.queryForObject(checkSql, Integer.class, userId);
        
        if (count != null && count > 0) {
            redirectAttributes.addFlashAttribute("error", "존재하는 id입니다 다른id를 입력해주십시오");
            return "redirect:/signup";
        }
        
        // ⭐️ DB 회원가입 처리 (INSERT)
        String insertSql = "INSERT INTO users (user_id, password, user_name) VALUES (?, ?, ?)";
        jdbcTemplate.update(insertSql, userId, password, userName);
        
        redirectAttributes.addFlashAttribute("message", "회원가입이 완료되었습니다! 가입한 정보로 로그인을 해주세요.");
        return "redirect:/"; 
    }
}
