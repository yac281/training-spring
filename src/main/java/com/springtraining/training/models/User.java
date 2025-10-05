package com.springtraining.training.models;

import jakarta.persistence.*;
import lombok.Data;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Objects;

@Data
@Entity
@Table(name = "user")
public class User implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "username")
    private String username;

    @Column(name = "password")
    private String password;

    @Column(name = "created_at")
    private Date createdAt;

    @Column(name = "updated_at")
    private Date updatedAt;

    @Column(name = "status")
    private String status;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority("USER"));
    }

    @Override
    public boolean isAccountNonExpired() {
        return !Objects.equals(status, "ACCOUNT_EXPIRED");
    }

    @Override
    public boolean isAccountNonLocked() {
        return !Objects.equals(status, "ACCOUNT_LOCKED");
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return !Objects.equals(status, "CREDENTIALS_EXPIRED");
    }

    @Override
    public boolean isEnabled() {
        return Objects.equals(status, "ACTIVE");
    }
}
