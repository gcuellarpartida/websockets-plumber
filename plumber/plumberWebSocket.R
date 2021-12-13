library(plumber)
library(websocket)
library(R6)

PlumberWebSocket <- R6Class("PlumberWebSocket", 
  inherit = Plumber,
  public = list(
    onWSOpen = function(ws) {
        if (is.function(private$ws_open)) {
            private$ws_open(ws)
        }
        invisible(self)
    },
    websocket = function(open = NULL) {
      if (!is.null(open)) stopifnot(is.function(open))
        private$ws_open <- open
    }
  ), 
  private = list(
      ws_open = NULL
  )
)

PlumberWebSocket$new("plumber.R")$run(port=5555)

plumbWebSocket <- function (file = NULL, dir = ".") 
{
    if (!is.null(file) && !identical(dir, ".")) {
        file <- file.path(normalize_dir_path(dir), file)
    }
    if (is.null(file)) {
        if (identical(dir, "")) {
            stop("You must specify either a file or directory parameter")
        }
        dir <- normalize_dir_path(dir)
        entrypoint <- list.files(dir, "^entrypoint\\.r$", ignore.case = TRUE)
        if (length(entrypoint) >= 1) {
            if (length(entrypoint) > 1) {
                entrypoint <- entrypoint[1]
                warning("Found multiple files named 'entrypoint.R'. Using: '", 
                  entrypoint, "'")
            }
            old_wd <- setwd(dir)
            on.exit(setwd(old_wd), add = TRUE)
            pr <- sourceUTF8(entrypoint, new.env(parent = globalenv()))
            if (!is_plumber(pr)) {
                stop("'", entrypoint, "' must return a runnable Plumber router.")
            }
            return(pr)
        }
        file <- list.files(dir, "^plumber\\.r$", ignore.case = TRUE, 
            full.names = TRUE)
        if (length(file) == 0) {
            stop("No plumber.R file found in the specified directory: ", 
                dir)
        }
        if (length(file) > 1) {
            file <- file[1]
            warning("Found multiple files named 'plumber.R' in directory: '", 
                dir, "'.\nUsing: '", file, "'")
        }
    }
    if (!file.exists(file)) {
        stop("File does not exist: ", file)
    }
    PlumberWebSocket$new(file)
}