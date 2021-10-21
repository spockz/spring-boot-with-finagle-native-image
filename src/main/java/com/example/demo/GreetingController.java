package com.example.demo;

import com.twitter.finagle.Service;
import com.twitter.finagle.http.Request;
import com.twitter.finagle.http.Response;
import com.twitter.util.Await;
import com.twitter.util.Duration;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/")
public class GreetingController {
    @Autowired
    private Service<Request, Response> selfService;

    @GetMapping("/proxy")
    public ResponseEntity<String> proxy() throws Exception {
        final Request request = Request.apply("/ping");
        request.host("some");
        return ResponseEntity.ok(Await.result(selfService.apply(request), Duration.fromSeconds(5)).contentString());
    }

    @GetMapping("/ping")
    public ResponseEntity<String> ping() {
        return ResponseEntity.ok("pong");
    }
}
