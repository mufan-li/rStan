
setwd("~/GitHub/rStan/")
source("functions.R")

rating_data0 <- read.csv("ua.base",sep="\t", header=F)
names(rating_data0) <- c("id","item","rating")
rating_data0 <- rating_data0[,1:3]

test_data0 <- read.csv("ua.test",sep="\t", header=F)
names(test_data0) <- c("id","item","rating")
test_data0 <- test_data0[,1:3]

filter_size <- 10000000
rating_data <- subset(rating_data0, id<=filter_size & item <= filter_size)
test_data <- subset(test_data0, id<=filter_size & item <= filter_size)

iter_list <- c(20,50,100)
chain_list <- c(1,2,5,10)
d_list = c(2,5,10,20)
mu_init_list = c(0,0.1,0.5,1)
execution_data <- NULL
m_pred_list <- list()

for (iter in iter_list) {
  for (chains in chain_list) {
    for (d in d_list) {
      for (mu_init in mu_init_list) {
        start_time <- Sys.time()
        source("execute.R")
        time_elapsed <- Sys.time() - start_time
        
        exec_data_instance <- data.frame(
          iter = iter, chains = chains, d = d,
          mse = mse_pred, time = time_elapsed
        )
        execution_data <- rbind(execution_data, exec_data_instance)
        # m_pred_list <- unlist(list(m_pred_list, list(m_pred)), recursive=FALSE)
        
        print(paste0("Iteration: ", iter, ", Chains: ", chains, 
                     ", d: ", d, ", MSE: ", mse_pred))
        save.image("~/GitHub/rStan/2015-12-08_Workspace.RData")
      }
    }
  }
}

# save.image("~/GitHub/rStan/2015-12-08_Workspace.RData")
# load("~/GitHub/rStan/2015-12-08_Test_Workspace.RData")

execution_data$dimension <- paste("Dimension = ",execution_data$d)
execution_data$dimension <- factor(execution_data$dimension, 
                                   levels = unique(execution_data$dimension))

# ggplot(execution_data, 
#        aes(x=as.character(iter),y=mse,fill=as.character(chains))) +
#   geom_bar(stat="identity",position="dodge") + facet_wrap(~dimension) +
#   scale_fill_brewer("Number of Chains", palette="Paired") + 
#   scale_x_discrete("Number of Iterations") +
#   scale_y_continuous("Mean Squared Error")

# install.packages("xtable")
# library(xtable)
# xtable(execution_data[,1:4])

system("python email2.py")


