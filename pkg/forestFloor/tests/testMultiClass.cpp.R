library(randomForest)
library(forestFloor)
require(utils)

data(iris)
iris
X = iris[,!names(iris) %in% "Species"]
Y = iris[,"Species"]
as.numeric(Y)
rf.test42 = randomForest(X,Y,keep.forest=T,replace=F,keep.inbag=T,samp=15,ntree=100)
ff.test42 = forestFloor(rf.test42,X,F,F)
pred = sapply(1:3,function(i) apply(ff.test42$FCarray[,,i],1,sum))+1/3
rfPred = predict(rf.test42,type="vote",norm.votes=T)
rfPred[is.nan(rfPred)] = 1/3
if(cor(as.vector(rfPred),as.vector(pred))^2<0.99) stop("fail testMultiClass")
attributes(ff.test42)
args(forestFloor:::plot.forestFloor_multiClass)
plot(ff.test42,compute_GOF=F,plot_GOF=T,cex=.7,
     colLists=list(c("#FF0000A5"),
                   c("#00FF0050"),
                   c("#0000FF35")))

show3d(ff.test42,1:2,3:4,compute_GOF=T)
#plot all effect 2D only
pars = plot_simplex3(ff.test42,Xi=c(1:3),restore_par=F,zoom.fit=NULL,var.col=NULL,fig.cols=2,fig.rows=1,
               fig3d=F,includeTotal=T,auto.alpha=.4,set_pars=T)
pars = plot_simplex3(ff.test42,Xi=0,restore_par=F,zoom.fit=NULL,var.col=alist(alpha=.3,cols=1:4),
               fig3d=F,includeTotal=T,auto.alpha=.8,set_pars=F)



for (I in ff.test42$imp_ind[1:4])  {
  #plotting partial OOB-CV separation(including interactions effects), coloured by true class
  pars = plot_simplex3(ff.test42,Xi=I,restore_par=F,zoom.fit=NULL,var.col=NULL,fig.cols=4,fig.rows=2,
                 fig3d=F,includeTotal=F,label.col=1:3,auto.alpha=.3,set_pars = (I==ff.test42$imp_ind[1]))
  #plotting partial OOB-CV separation(including interactinos effects), coloured by varaible value
  pars = plot_simplex3(ff.test42,Xi=I,restore_par=F,zoom.fit=T,var.col=alist(order=F,alpha=.8),
                 fig3d=F,includeTotal=(I==4),auto.alpha=.3,set_pars=F)
}

