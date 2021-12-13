library(websocket)
ws <- websocket::WebSocket$new("ws://127.0.0.1:8080/")
ws$onMessage(function(event) {
  cat(event$data, "\n")
})
ws$send("My name is=John")
ws$send("How are you everyone?")
ws$close()