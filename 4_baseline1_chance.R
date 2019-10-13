## ----[4] baseline 1- chance----------------------------------------------
# relevant packages 
library(dplyr)
library(magrittr)
library(caret)

# load data 
load("/Volumes/My Passport for Mac/___hertie/2019-fall/e1291-ml/df_ideo_test.RDa")

# for reproducibility 
set.seed(1984)

# chance string 
class_ideo <- c("center",
              "leanleft",
              "leanright",
              "left",
              "right")
class_ideology_chance <- sample(rep(class_ideo,2000),size=10000,replace=FALSE)


# create df for confusion matrix 
df1_ideo_confmat <- data.frame(cbind(df1_ideo,class_ideology_chance))
df1_ideo_confmat <- df1_ideo_confmat[,c("class_ideology_chance","class_ideology")]
names(df1_ideo_confmat) <- c("pred","actual")
table(df1_ideo_confmat$pred,df1_ideo_confmat$actual)
tab_ideo_confmat <- table(df1_ideo_confmat$pred,df1_ideo_confmat$actual)
caret::confusionMatrix(tab_ideo_confmat)

# manually calculating precision, recall, F1 for intuition; uploading separate script to double check my work  

## false positives and false negatives for each 
center.fp=426+402+428+412
center.fn=418+400+406+401
leanleft.fp=418+387+395+412
leanleft.fn=426+399+416+362
leanright.fp=400+399+413+385
leanright.fn=402+387+381+420
left.fp=406+416+381+380
left.fn=428+395+413+371
right.fp=401+362+420+371
right.fn=412+412+385+380

## precision, recall, f1 for each individual category 
center.p=375/(375+center.fp)
center.r=375/(375+center.fn)
center.f1=2*((center.p*center.r)/(center.p+center.r))

leanleft.p=397/(397+leanleft.fp)
leanleft.r=397/(397+leanleft.fn)
leanleft.f1=2*((leanleft.p*leanleft.r)/(leanleft.p+leanleft.r))

leanright.p=410/(410+leanright.fp)
leanright.r=410/(410+leanright.fn)
leanright.f1=2*((leanright.p*leanright.r)/(leanright.p+leanright.r))

left.p=393/(393+left.fp)
left.r=393/(393+left.fn)
left.f1=2*((left.p*left.r)/(left.p+left.r))

right.p=411/(411+right.fp)
right.r=411/(411+right.fn)
right.f1=2*((right.p*right.r)/(right.p+right.r))

## precision, recall, f1 for the whole model (averaging each score)
mean(center.p,leanleft.p,leanright.p,left.p,right.p) # precision 
mean(center.r,leanleft.r,leanright.r,left.r,right.r) # recall 
mean(center.f1,leanleft.f1,leanright.f1,left.f1,right.f1) # f1 score 

