package com.salesianostriana.gamesforall.product.model;

import com.salesianostriana.gamesforall.trade.model.Trade;
import com.salesianostriana.gamesforall.user.model.User;
import lombok.*;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@EntityListeners(AuditingEntityListener.class)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Product {

    @Id
    @GeneratedValue
    private Long id;

    private String title;
    private String description;

    private String image;

    private double price;


    @Builder.Default
    private LocalDateTime publication_date = LocalDateTime.now();


    private StateEnum state;

    private boolean shipping_available;

    private boolean sold;


    @ManyToOne //eager
    @JoinColumn(name = "user_id", foreignKey = @ForeignKey(name = "FK_PRODUCT_USER"))
    private User user;


    @ManyToOne //eager
    @JoinColumn(name = "platform_id", foreignKey = @ForeignKey(name = "FK_PRODUCT_PLATAFORM"))
    private Platform platform;


    @ManyToMany//borrado?(cascade = CascadeType.ALL) nunca borrar
    @JoinTable(
            name = "product_category",
            joinColumns = @JoinColumn(name = "product_id", foreignKey = @ForeignKey(name = "FK_PRODUCT")),
            inverseJoinColumns = @JoinColumn(name = "category_id",foreignKey = @ForeignKey(name = "FK_CATEGORY")))
    private Set<Category> categories;



    @OneToOne(mappedBy = "product")
    private Trade trade;

    //HELPERS PLATAFORMAS
//
//    public void addToPlatform(Platform p) {
//        this.platform = p;
//        p.getProductos().add(this);
//    }
//
//    public void removeFromPlatform(Platform p) {
//        this.platform = null;
//        p.getProductos().remove(this);
//    }
//
//
//
//    //HELPERS CATEGORIAS
//    public void addCategory(Category c) {
//        if (this.getCategories() == null)
//            this.setCategories(new HashSet<>());
//        this.getCategories().add(c);
//        if (c.getCategorizedProducts() == null)
//            c.setCategorizedProducts(new ArrayList<>());
//        c.getCategorizedProducts().add(this);
//    }
//
//    public void removeCategory(Category c) {
//        c.getCategorizedProducts().remove(this);
//        this.getCategories().remove(c);
//    }


}

//SEGUN LUISMI LAS TO-MANY OBLIGATORIAMENTE DEBEN SER LAZY