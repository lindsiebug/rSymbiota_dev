#' Start Docker
#' @param verbose logical
#' @param sleep waiting time for system call to finish
#' @import sys
#' @details This should run for Unix platforms (e.g., Mac) and Windows. Docker available for download at: https://www.docker.com
#' @export
start_docker <- function(verbose = TRUE, sleep = 2){

  cmd = "docker"

  if(verbose){
    out <- exec_wait(cmd, args = c("pull", "selenium/standalone-chrome"))
    if(out != 0)
      stop("Docker not available. Please start Docker app.")
  }else{
    out <- exec_internal(cmd, args = c("pull", "selenium/standalone-chrome"))
    if(out$status != 0)
      stop("Docker not available. Please start Docker app.")
  }


  out <- exec_internal(cmd, args = c("run", "-d", "-p", "4445:4444", "selenium/standalone-chrome"),
                       error = FALSE)
  if (verbose)
    if (out$status == 0) {
      cat("Port is allocated \n")
    } else {
      stop_docker()
      stop("Port is not allocated. Run *stop_docker* and try again\n")
    }
  Sys.sleep(sleep)
}

#' Stop Docker
#' @param sleep waiting time for system call to finish
#' @details This should run for Unix platforms (e.g., Mac) and Windows. Docker available for download at: https://www.docker.com
#' @export
stop_docker <- function(sleep = 2){

  out <- exec_internal("docker", args = c("ps", "-q"))

  stdo <- tempfile()
  out <- exec_wait("docker", "ps", std_out = stdo)
  out <- readLines(stdo)
  out[2] <- gsub("\\s+", " ", out[2])
  out[2] <- stringr::str_split(out[[2]], "\\s")
  nam <- out[[2]][length(out[[2]])]

  out <- exec_internal("docker", args = c("stop", nam))

  Sys.sleep(sleep)
}


