package com.ee.webapp1;

import io.swagger.annotations.ApiOperation;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class SimpleController {

	@GetMapping(value = "/api/v1", produces = MediaType.TEXT_PLAIN_VALUE)
	@ApiOperation(
			value = "The very first endpoint",
			httpMethod = "GET",
			produces = MediaType.TEXT_PLAIN_VALUE
	)
	@ResponseBody
	public String simpleEndpoint() {
		return "OK";
	}

}
