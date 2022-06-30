package com.ee.webapp1;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@SpringBootApplication
@EnableSwagger2
public class WebApp1Application {

	public static void main(String[] args) {
		SpringApplication.run(WebApp1Application.class, args);
	}

}
