package com.salesianostriana.gamesforall.user.service;

import com.salesianostriana.gamesforall.exception.EmptyProductListException;
import com.salesianostriana.gamesforall.exception.UserNotFoundException;
import com.salesianostriana.gamesforall.product.dto.BasicProductDTO;
import com.salesianostriana.gamesforall.product.dto.EasyProductDTO;
import com.salesianostriana.gamesforall.product.dto.PageDto;
import com.salesianostriana.gamesforall.product.model.Product;
import com.salesianostriana.gamesforall.product.repository.ProductRepository;
import com.salesianostriana.gamesforall.search.specifications.GSBuilder;
import com.salesianostriana.gamesforall.search.util.SearchCriteria;
import com.salesianostriana.gamesforall.user.dto.CreateUserRequest;
import com.salesianostriana.gamesforall.user.dto.EditUserRequest;
import com.salesianostriana.gamesforall.user.model.User;
import com.salesianostriana.gamesforall.user.model.UserRole;
import com.salesianostriana.gamesforall.user.repo.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.EnumSet;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserService {

    private final PasswordEncoder passwordEncoder;
    private final UserRepository userRepository;
    private final ProductRepository productRepository;

    public User createUser(CreateUserRequest createUserRequest, EnumSet<UserRole> roles) {
        User user =  User.builder()
                .username(createUserRequest.getUsername())
                .password(passwordEncoder.encode(createUserRequest.getPassword()))
                .avatar(createUserRequest.getAvatar())
                .fullName(createUserRequest.getFullName())
                .roles(roles)
                .address(createUserRequest.getAddress())
                .build();

        return userRepository.save(user);
    }

    public User createUserWithUserRole(CreateUserRequest createUserRequest) {
        return createUser(createUserRequest, EnumSet.of(UserRole.USER));
    }

    public User createUserWithAdminRole(CreateUserRequest createUserRequest) {
        return createUser(createUserRequest, EnumSet.of(UserRole.ADMIN));
    }

    public List<User> findAll() {
        return userRepository.findAll();
    }

    public User findById(UUID id) {
        return userRepository.findById(id).orElseThrow(()->new UserNotFoundException(id));
    }

    public Optional<User> findByUsername(String username) {
        return userRepository.findFirstByUsername(username);
    }

    public Optional<User> edit(EditUserRequest user) {

        // El username no se puede editar
        // La contraseña se edita en otro método

        return userRepository.findById(user.getId())
                .map(u -> {
                    u.setAvatar(user.getAvatar());
                    u.setFullName(user.getFullName());
                    return userRepository.save(u);
                }).or(() -> Optional.empty());

    }

    public Optional<User> editPassword(UUID userId, String newPassword) {

        // Aquí no se realizan comprobaciones de seguridad. Tan solo se modifica

        return userRepository.findById(userId)
                .map(u -> {
                    u.setPassword(passwordEncoder.encode(newPassword));
                    return userRepository.save(u);
                }).or(() -> Optional.empty());

    }

    public void delete(User user) {
        deleteById(user.getId());
    }

    public void deleteById(UUID id) {
        // Prevenimos errores al intentar borrar algo que no existe
        if (userRepository.existsById(id))
            userRepository.deleteById(id);
    }

    public boolean passwordMatch(User user, String clearPassword) {
        return passwordEncoder.matches(clearPassword, user.getPassword());
    }

    public boolean userExists(String username) {
        return userRepository.existsByUsername(username);
    }


    public Page<EasyProductDTO> getUserFavoriteProducts(UUID userId, Pageable pageable) {
        Page<Product> favoriteProducts = userRepository.findFavoriteProductsByUserId(userId, pageable);
        return favoriteProducts.map(EasyProductDTO::of);
    }

    public Page<EasyProductDTO> getUserProducts(UUID userId, Pageable pageable) {
        Page<Product> myProducts = userRepository.findProductsByUser(userId, pageable);
        return myProducts.map(EasyProductDTO::of);
    }

    public User buscarPorId(UUID id) {
        return userRepository.buscarPorId(id).orElseThrow(()->new UserNotFoundException(id));
        // .orElseThrow(()->new UserNotFoundException(id));
    }

        //favoritos sin paged
        public List<BasicProductDTO> getUserFavoriteProductsNotPaged(UUID userId) {
            List<Product> favoriteProducts = userRepository.findFavoriteProductsByUserIdNotPaged(userId);
            return favoriteProducts.stream()
                    .map(BasicProductDTO::of)
                    .collect(Collectors.toList());
        }



}
