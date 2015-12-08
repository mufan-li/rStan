data {
  int<lower=1> N;
  int<lower=1> M;
  int<lower=1> L;
  real m[L];
  int d;
  int row_index[L];
  int col_index[L];
  
  real alpha;
  real beta_0;
  vector[d] mu_0;
  int<lower=1> nu_0;
  cov_matrix[d] W_0;
}
parameters {
  vector[d] mu_u;
  vector[d] mu_v;
  cov_matrix[d] sigma_u;
  cov_matrix[d] sigma_v;
  matrix[N,d] u;
  matrix[M,d] v;
}
// transformed parameters {
//   matrix[N,N] Y;
//   Y <- u * v';
// }
model {
  int i;
  int j;
  // inverse(matrix m)
  sigma_u ~ inv_wishart(nu_0,W_0);
  sigma_v ~ inv_wishart(nu_0,W_0);
  
  mu_u ~ multi_normal(mu_0,sigma_u / beta_0^d);
  mu_v ~ multi_normal(mu_0,sigma_v / beta_0^d);
  
  for (n in 1:N)
    u[n] ~ multi_normal(mu_u,sigma_u);
    
  for (n in 1:M)
    v[n] ~ multi_normal(mu_v,sigma_v);
    
  for (n in 1:L) {
    i <- row_index[n];
    j <- col_index[n];
    m[n] ~ normal( u[i] * v[j]', 1/alpha);
  }
}


