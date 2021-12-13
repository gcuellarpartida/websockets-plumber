library(uuid)
clients <- list()
results <- data.frame(
    color=c("red","blue","green"), 
    votes=c(0,0,0))

addClient <- function(ws) {
    clients[[ws$request$uuid]] <<- ws
    print(clients)
    return(clients)
}

updateVoteCount <- function(color) {
    results[results$color == color,"votes"] <<- results[results$color == color,"votes"]+1
    print(results)
}

#* @filter logger
function(req, res){
    cat(as.character(Sys.time()), "-",
    req$REQUEST_METHOD, req$PATH_INFO, "-",
    req$HTTP_USER_AGENT, "@", req$REMOTE_ADDR, "\n")
    plumber::forward()
}

#* @filter cors
cors <- function(res) {
    res$setHeader("Access-Control-Allow-Origin", "*")
    plumber::forward()
}

#' @get /poll-results
function() { 
    return(results)
}

#' @plumber
function(pr) {
    pr$websocket(
        function(ws) {
            ws$request$uuid <- UUIDgenerate()
            addClient(ws)
            print("New user connected!") 
            ws$onMessage(function(binary, message) {
                updateVoteCount(jsonlite::fromJSON(message))
                for(client in clients) {
                    client$send(message)
                }
            })
        }
    )
}
