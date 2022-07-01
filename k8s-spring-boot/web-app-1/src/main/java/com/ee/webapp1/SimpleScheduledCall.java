package com.ee.webapp1;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.lang.invoke.MethodHandles;
import java.net.URI;

@Component
public class SimpleScheduledCall {

	private static final Logger logger = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());

	private final RestTemplate restTemplate;
	private final String urlAPI;

	public SimpleScheduledCall(@Value("${scheduled-call.web-app-2}") String webApp2Host) {
		this.restTemplate = new RestTemplate();
		restTemplate.getMessageConverters().add(new StringHttpMessageConverter());
		this.urlAPI = webApp2Host + "/api/v1";
	}

	@Scheduled(fixedDelayString = "${scheduled-call.fixedDelayMs}", initialDelay = 10000)
	public void makeScheduledCall() {
		URI uri = UriComponentsBuilder.fromUriString(urlAPI).build().toUri();
		logger.info(restTemplate.getForObject(uri, String.class));
	}

}
