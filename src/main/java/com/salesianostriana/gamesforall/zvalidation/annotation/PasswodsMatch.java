package com.salesianostriana.gamesforall.zvalidation.annotation;

import com.salesianostriana.gamesforall.zvalidation.validator.PasswordsMatchValidator;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = PasswordsMatchValidator.class)
@Documented
public @interface PasswodsMatch {

    String message() default "Las contraseñas introducidas no coinciden";
    Class <?> [] groups() default {};
    Class <? extends Payload> [] payload() default {};

    String passwordField();
    String verifyPasswordField();

}

