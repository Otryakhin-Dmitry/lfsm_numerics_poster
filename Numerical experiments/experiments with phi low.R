### Results of experiments: phi_low doesn't converge to the exp(...).
# Based on 2.12

> m<-256
> M<-600
> 
> List<-path(N=1e5,m=256,M=600,alpha=0.6,H=0.8,
+            sigma=1,freq='L',disable_X=FALSE,
+            levy_increments=NULL,seed=NA)

>            
> X<-List$lfsm
> phi(t=1,k=2,X=X,H=H,freq='L')
[1] 0.0005951575
> exp(-(abs(Norm_alpha(h_kr,alpha=0.6,k=2,r=1,H=0.8,l=0))^alpha))
Error in abs(Norm_alpha(h_kr, alpha = 0.6, k = 2, r = 1, H = 0.8, l = 0)) : 
  non-numeric argument to mathematical function
> exp(-(abs(Norm_alpha(h_kr,alpha=0.6,k=2,r=1,H=0.8,l=0)$result)^alpha))
[1] 0.0004202545
> 
> 
> 
> 
> nn<-1e2
> List<-path(N=nn,m=256,M=600,alpha=0.6,H=0.8,
+            sigma=1,freq='L',disable_X=FALSE,
+            levy_increments=NULL,seed=NA)
>            
> X<-List$lfsm
> phi(t=1,k=2,X=X,H=H,freq='L')
[1] -0.1183154
> exp(-(abs(Norm_alpha(h_kr,alpha=0.6,k=2,r=1,H=0.8,l=0)$result)^alpha))
[1] 0.0004202545
> nn<-1e3
> List<-path(N=nn,m=256,M=600,alpha=0.6,H=0.8,
+            sigma=1,freq='L',disable_X=FALSE,
+            levy_increments=NULL,seed=NA)
>            
> X<-List$lfsm
> phi(t=1,k=2,X=X,H=H,freq='L')
[1] 0.0163448
> nn<-1e4
> List<-path(N=nn,m=256,M=600,alpha=0.6,H=0.8,
+            sigma=1,freq='L',disable_X=FALSE,
+            levy_increments=NULL,seed=NA)
>            
> X<-List$lfsm
> phi(t=1,k=2,X=X,H=H,freq='L')
[1] 0.001522045
> 
> 
> 
> 
> nn<-1e6
> List<-path(N=nn,m=256,M=600,alpha=0.6,H=0.8,
+            sigma=1,freq='L',disable_X=FALSE,
+            levy_increments=NULL,seed=NA)

>            
> X<-List$lfsm
> phi(t=1,k=2,X=X,H=H,freq='L')
[1] 0.0005771539
> exp(-(abs(Norm_alpha(h_kr,alpha=0.6,k=2,r=1,H=0.8,l=0)$result)^alpha))
[1] 0.0004202545
> 
                                                
