package com.example.demo.Login;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class JdbcLoginRepo implements LoginRepository{
    
    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public int findID(String username) {
        String sql = "select idpengguna from pengguna where username = ?";
        List<Pengguna> user = jdbcTemplate.query(sql, this::mapRowToPengguna, username);
        System.out.println(user.getFirst().getIdpengguna());
        return user.getFirst().getIdpengguna();
    }

    @Override
    public String findPass(int idpengguna) {
        String sql = "select * from ibubs where idpengguna = ?";
        List<IbuBS> buBS = jdbcTemplate.query(sql, this::mapRowToIbuBS, idpengguna);
        return buBS.getFirst().getPassword();
    }

    private Pengguna mapRowToPengguna(ResultSet resultSet, int rowNum) throws SQLException{
        return new Pengguna(resultSet.getInt("idpengguna"));
    }

    private IbuBS mapRowToIbuBS(ResultSet resultSet, int rowNum) throws SQLException{
        return new IbuBS(resultSet.getInt("idpengguna"), resultSet.getString("password"));
    }
}
