
package com.thilak.ormlearn.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.thilak.ormlearn.model.Country;
import com.thilak.ormlearn.repository.CountryRepository;

@Service
public class CountryService {

    @Autowired
    private CountryRepository countryRepository;

    public Country findCountryByCode(String code) {
        return countryRepository.findById(code).orElse(null);
    }
}
