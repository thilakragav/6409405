package com.cognizant.springlearn.controller;

import com.cognizant.springlearn.model.Country;
import com.cognizant.springlearn.service.CountryService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.web.bind.annotation.*;

@RestController
public class CountryController {

    private static final Logger LOGGER = LoggerFactory.getLogger(CountryController.class);

    @Autowired
    private CountryService countryService;

    @RequestMapping("/country")
    public Country getCountryIndia() {
        LOGGER.info("START: getCountryIndia()");
        ApplicationContext context = new ClassPathXmlApplicationContext("country.xml");
        Country india = (Country) context.getBean("in");
        LOGGER.info("END: getCountryIndia()");
        return india;
    }

    @GetMapping("/country/{code}")
    public Country getCountry(@PathVariable String code) {
        LOGGER.info("START: getCountry()");
        Country result = countryService.getCountry(code);
        LOGGER.info("END: getCountry()");
        return result;
    }
}
