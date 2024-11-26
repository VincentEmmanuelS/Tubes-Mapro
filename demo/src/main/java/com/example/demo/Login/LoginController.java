package com.example.demo.Login;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/login")
public class LoginController {
    
    @Autowired
    private LoginRepository repo;

    @GetMapping("/")
    public String index() {
        return "login";
    }

    @PostMapping("bubs")
    public String cekAkun(@RequestParam String username, @RequestParam String password) {
        int id = this.repo.findID(username);
        String pass = this.repo.findPass(id);
        if(pass.equals(password)) {
            return "bubs";
        }else {
            return "redirect:/login/";
        }
    }
}
