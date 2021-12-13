library(uuid)

clients <- list()

addClient <- function(ws) {
    clients[[ws$request$uuid]] <<- ws
    return(clients)
}

removeClient <- function(uuid) {
    clients[[uuid]] <<- NULL
}

addClientUserName <- function(ws, name) {
    clients[[ws$request$uuid]]$request$USER <<- name
}

#' @plumber
function(pr) {
    pr$websocket(
        function(ws) {
            ws$request$uuid <- UUIDgenerate()
            ws$request$USER <- "Unknown"
            addClient(ws)
            print("New user connected!") 
            ws$onMessage(function(binary, message) {
                #ws$send(message)
                if(grepl("My name is=",message)) {
                    addClientUserName(ws, strsplit(message,"=")[[1]][2])
                }
                else {
                    for(client in clients) {
                        client$send(paste(clients[[ws$request$uuid]]$request$USER,":", message))
                    }
                }
            })
            ws$onClose(function() {
                removeClient(ws$request$uuid)
            })
        }
    )
}


