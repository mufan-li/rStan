# Initialize data and related parameters

# # number of rows
# N = 3
# # number of columns
# M = 3
# # available data in vector
# m = c(3,2,5,6,4,10,6,15)
# # matrix(c(1,2,3),3,1) %*% matrix(c(3,2,5),1,3)
# # length of data
# L = length(m)
# # corresponding data indices in matrix
# row_index = c(1,1,1,2,2,2,3,3)
# col_index = c(1,2,3,1,2,3,2,3)
# # rank of factorization
# d = 2

N = max(rating_data$id)
M = max(rating_data$item)
m = rating_data$rating
L = length(m)
row_index = rating_data$id
col_index = rating_data$item
d = 2

# # additional prior parameters
alpha = 2
beta_0 = 1
mu_0 = as.vector(rep(2,d))
nu_0 = d
W_0 = diag(d)

# stan model
matrix_fit <- stan(file="matrix.stan",
                   data=c("N","M","L","d","m","row_index","col_index",
                          "alpha","beta_0","mu_0","nu_0","W_0"),
                   iter=iter,chains=chains)

# construct matrix
m_out <- create_matrix(m,row_index,col_index,N,M)
# find mean
matrix_fit_df <- as.data.frame(matrix_fit)
m_pred <- gen_prediction(matrix_fit_df, N, M, d)
mse_pred <- calc_mse(m_out,m_pred)

# mu_u <- gen_out_matrix(matrix_fit_mean, "mu_u", d, 1)
# sigma_u <- gen_out_matrix(matrix_fit_mean, "sigma_u", d, d)

# test_df <- data.frame(x = 1:nrow(matrix_fit_df), y = matrix_fit_df[,25])
# ggplot(test_df,aes(x=x,y=y))+geom_point()
