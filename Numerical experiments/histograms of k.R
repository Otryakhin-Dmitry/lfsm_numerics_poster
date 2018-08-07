Monte_k<-function(alpha, H){
  
  data<-foreach(SP_ind = (1:NmonteC), .combine = rbind) %dopar% {
    
    S_Path<-path(N=1e3,m=m,M=M,alpha=alpha,H=H,
                 sigma=sigma,freq=fr,disable_X=FALSE,
                 levy_increments=NULL)
    
    
    alpha_0<-alpha_hat(t1=t1,t2=t2,k=1,path=S_Path$lfsm,H=NULL,freq='L')
    if(alpha_0<=0) k_new<-NA else k_new<-2+floor(alpha_0^(-1))
    c(k_new=k_new, alpha=alpha, H=H)
  }

  data
}




#### Going over alphas and Hs ####
d<-data.frame()

for(ind_hs in (1:length(hs))) {
  for(ind_als in (1:length(als))) {
    
    d<-rbind(d,Monte_k(alpha=als[ind_als], H=hs[ind_hs]))
    
  }
}

ggplot(data=d, aes(k_new)) + geom_histogram(binwidth = 1, fill = 'darkgreen') +
facet_grid(alpha~H) + coord_cartesian(xlim = c(0, 13)) +
theme_bw() 

# test
test<-Monte_k(alpha=0.3, H=0.2)
hist(test[,1], xlim = c(0,13),breaks = 200)
