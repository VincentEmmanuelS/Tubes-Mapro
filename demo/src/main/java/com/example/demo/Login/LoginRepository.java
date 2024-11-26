package com.example.demo.Login;

public interface LoginRepository {
    int findID(String username);
    String findPass(int idpengguna);
}
