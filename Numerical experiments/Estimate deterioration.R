
#### Set of global parameters ####
library(rlfsm)

m<-45; M<-60; N<-200
p<-.4; p_prime<-.2
t1<-1; t2<-2; k<-2

NmonteC<-3e2
sigma<-0.3

### Grid for alphas and Hs continuous case

by_hs<-0.05; by_als<-0.1
 hs<-seq(0.5+by_hs,1-by_hs,by=by_hs)
als<-seq(1+by_als,2-by_als,by=by_als)
####

test<-list()
dimns <-list(hs,als)

mtrx_contin_l<-matrix(data = NA, nrow = length(hs), ncol = length(als), dimnames=dimns)
mtrx_contin_h<-matrix(data = NA, nrow = length(hs), ncol = length(als), dimnames=dimns)
mtrx_gen_l<-matrix(data = NA, nrow = length(hs), ncol = length(als), dimnames=dimns)
mtrx_gen_h<-matrix(data = NA, nrow = length(hs), ncol = length(als), dimnames=dimns)


##### A function for NA/ NaN / error filtering
# returns 1 if everything is OK
Errfilter<-function(res){
    b1<-ifelse(is.character(res), 0, 1)
    b2<-ifelse(length(grep('NA',res))>0, 0, 1)
    b3<-ifelse(length(grep('NAN',res))>0, 0, 1)
    b1*b2*b3
}
####


#### The experiment #######

for(ind_hs in (1:length(hs))) {

    for(ind_als in (1:length(als))) {
        res<-data.frame()

        res<-foreach (j_ind = 1:NmonteC, .combine = rbind, .packages='stabledist', .inorder=FALSE) %dopar% {

            pathL <- path(N=N,m=m,M=M,alpha=als[ind_als],H=hs[ind_hs],sigma=sigma,freq='L')
            pathH <- path(N=N,m=m,M=M,alpha=als[ind_als],H=hs[ind_hs],sigma=sigma,freq='H')

            ConEstLow<-ContinEstim(t1=t1,t2=t2,p=p,k=2,path=pathL$lfsm,freq='L')
            GenEstLow<-GenLowEstim(t1=t1,t2=t2,p=p,path=pathL$lfsm,freq='L')

            ConEstHigh<-ContinEstim(t1=t1,t2=t2,p=p,k=2,path=pathH$lfsm,freq='H')
            GenEstHigh<-GenHighEstim(p=p,p_prime=p_prime,path=pathH$lfsm,freq='H',low_bound=0.01,up_bound=2)

            rcol<-cbind(CEL=Errfilter(ConEstLow),
                        GEL=Errfilter(GenEstLow),
                        CEH=Errfilter(ConEstHigh),
                        GEH=Errfilter(GenEstHigh))
            rcol
        }

        suc_rate<-colSums(res)/NmonteC

        mtrx_contin_l[ind_hs,ind_als]<-suc_rate['CEL']
        mtrx_gen_l[ind_hs,ind_als]<-suc_rate['GEL']
        mtrx_contin_h[ind_hs,ind_als]<-suc_rate['CEH']
        mtrx_gen_h[ind_hs,ind_als]<-suc_rate['GEH']
    }

}

###########################


### Writing the tables ####

write.csv(mtrx_gen_h, file = "mtrx_gen_h.csv")
write.csv(mtrx_gen_l, file = "mtrx_gen_l.csv")

write.csv(mtrx_contin_h, file = "mtrx_contin_h.csv")
write.csv(mtrx_contin_l, file = "mtrx_contin_l.csv")
###########################

