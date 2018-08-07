
#### Set of global parameters ####
library(rlfsm)
registerDoParallel(2)
library(gridExtra)
library(ggplot2)


m<-45#25
M<-90#60


p<-.4
p_prime<-.2
t1<-1
t2<-2
k<-4
fr<-'L'
t<-1


# alpha<-1.8
# H<-0.8
sigma<-0.3


NmonteC<-5e2
LofF<-NULL



phis_on_k<-function(alpha, H){
  
  data<-foreach(SP_ind = (1:NmonteC), .combine = rbind) %dopar% {
    
    S_Path<-path(N=1e3,m=m,M=M,alpha=alpha,H=H,
                 sigma=sigma,freq=fr,disable_X=FALSE,
                 levy_increments=NULL)
    
    
    d<-foreach(k_ind = seq(1,8,by=1), .combine = rbind) %do% {
      
      #alpha_vect<-alpha_hat(t1=1,t2=2,k=k_ind,path=S_Path$lfsm,H=H,freq=fr)
      phi_vect<-phi(t=t1,k=k_ind,path=S_Path$lfsm,H=H,freq=fr)
      exp_vect<-tryCatch(
                         exp(-(abs(sigma*Norm_alpha(h_kr,alpha=alpha,k=k_ind,r=1,H=H,l=0)$result)^alpha)),
                         error=function(c) NA)
      
      c(sample_num=SP_ind, k=k_ind, phi_exper=phi_vect, phi_theor=exp_vect)
    }
    d
  }

  data
  
}

## Computations on the grid ##

#by_hs<-0.1; 
by_als<-0.4
#hs<-seq(0+by_hs,1-by_hs,by=by_hs)
hs<-c(0.3,0.5,0.7,0.9)
#als<-seq(0+by_als,2-by_als,by=by_als)
als<-seq(0.2,1.8,by=by_als)


pl<-data.frame()

for(ind_hs in (1:length(hs))) {
  for(ind_als in (1:length(als))) {
    
    pl<-rbind(pl,
              cbind(phis_on_k(alpha=als[ind_als], H=hs[ind_hs]),alpha=als[ind_als],H=hs[ind_hs]))
    
  }
}


pl_log<-pl
pl_log$phi_theor<-log(pl_log$phi_theor)
pl_log$phi_exper<-log(pl_log$phi_exper)

pl_log$k<-factor(pl_log$k)
ggp <- ggplot(pl_log) +
  geom_boxplot(aes(x = k, y = phi_exper), color='blue') +
  geom_point(aes(x = k, y = phi_theor), inherit.aes = FALSE, size = 2, shape = 4, color='green3') +
  scale_y_continuous(limits = c(-200,0)) +
  facet_grid(alpha~H, scales = "free") +
  ggplot2::theme_bw() + labs(x = "k") #labs(x = "k", y = "phi")
ggp


## Show errors when H=0.9 & alpha=0.2
pl_log[pl_log$H == 0.9 & pl_log$alpha == 0.2,]

