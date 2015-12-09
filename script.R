
setwd("~/GitHub/rStan/")
source("functions.R")

rating_data0 <- read.csv("u.data",sep="\t", header=F)
names(rating_data0) <- c("id","item","rating")
rating_data0 <- rating_data0[,1:3]

filter_size <- 10
rating_data <- subset(rating_data0, id<=filter_size & item <= filter_size)

iter_list <- c(20,50,100)
chain_list <- c(1,2,5)
d_list = c(1,2,10)
execution_data <- NULL
m_pred_list <- list()

for (iter in iter_list) {
  for (chains in chain_list) {
    for (d in d_list) {
      start_time <- Sys.time()
      source("execute.R")
      time_elapsed <- Sys.time() - start_time
      
      exec_data_instance <- data.frame(
        iter = iter, chains = chains, d = d,
        mse = mse_pred, time = time_elapsed
      )
      execution_data <- rbind(execution_data, exec_data_instance)
      m_pred_list <- unlist(list(m_pred_list, list(m_pred)), recursive=FALSE)
    }
  }
}

save.image("~/GitHub/rStan/2015-12-08_Workspace.RData")







