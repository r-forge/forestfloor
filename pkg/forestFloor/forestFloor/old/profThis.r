Rprof()
library(randomForest)
library(forestFloor)
X=data.frame(replicate(4,runif(15000,-150,150)))
p=with(X,X1+X2)
y=exp(p)/(1+exp(p))
y=round(y,0)
rfo = randomForest(X,y,keep.inbag=T,sampsize=1000,ntree=500)
ff = forestFloor2(rfo,X)

plot(ff,colour_by="PCA")
show3d(ff)
Rprof(NULL)