
package com.thilak.ormlearn;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import com.thilak.ormlearn.model.Country;
import com.thilak.ormlearn.service.CountryService;

@SpringBootApplication
public class OrmLearnApplication implements CommandLineRunner {

    @Autowired
    private CountryService countryService;

    public static void main(String[] args) {
        SpringApplication.run(OrmLearnApplication.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        Country country = countryService.findCountryByCode("IN");
        System.out.println(country);
    }
}
