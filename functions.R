# functions
library(rstan)

# create a matrix with missing entries as NA
create_matrix <- function(m,row_index,col_index,N,M) {
  m_out <- matrix(NA,N,M)
  L <- length(m)
  for (n in 1:L) {
    i <- row_index[n]
    j <- col_index[n]
    m_out[i,j] <- m[n]
  }
  return(m_out)
}

# find the mean of each column in the data frame
df_col_mean <- function(df) {
  df_out <- df[1,]
  for (i in 1:ncol(df)) {
    df_out[,i] <- median(df[,i])
  }
  return(df_out)
}

# recreate an output variable from one row of output data frame
gen_out_matrix <- function(df, name, d1, d2) {
  strlen <- nchar(name)
  name_list <- names(df)[substr(names(df),1,strlen+1) == paste0(name,"[")]
  
  parse_value <- paste0(name,"<- matrix(0,d1,d2)")
  eval(parse(text = parse_value))
  
  for (each_name in name_list) {
    parse_value <- paste0(each_name,"<-","df[,\"",each_name,"\"]")
    eval(parse(text = parse_value))
  }
  parse_value <- paste0("return(",name,")")
  eval(parse(text = parse_value))
}

gen_prediction <- function(fit_df, N, M, d) {
  matrix_fit_mean <- df_col_mean(matrix_fit_df)
  # construct output variables
  u <- gen_out_matrix(matrix_fit_mean, "u", N, d)
  v <- gen_out_matrix(matrix_fit_mean, "v", M, d)
  return(u %*% t(v))
}

calc_mse <- function(m_out, m_pred) {
  return(mean((m_out - m_pred)^2,na.rm=T))
}




