#install.packages("RODBC")

#INITIALIZE LIBRARIES
library(RODBC)
library("parallel")
library("randomForest")
library("rpart")
library("e1071")
library("randomForest")
library("gbm")

#Set Globals
setwd("C:\\Users\\Administrator\\Documents\\GitHub\\MLSP")

#GET DATA
myconn = odbcConnect("MLSP")
train = sqlQuery(myconn, "select * from train")
close(myconn) 
train.input = cbind(train[2],sapply(train[3:412], as.numeric))

#model = glm(Class~., data=train.input)
model = svm(Class~., data=train.input)
#model = randomForest(Class~., data=train.input)
#model = gbm(Class~., data=train.input)
# Predicted.Train = cbind(train, predicted = round(predict(model, train.input, interval="predict", type="response"), digits=4))
# out = c("Id", "Class", "predicted")§
# Predicted.Train = Predicted.Train[out]

myconn = odbcConnect("MLSP")
test = sqlQuery(myconn, "select * from test")
close(myconn)
test.input = sapply(test[2:411], as.numeric)

Predicted.Test = cbind(test, predicted = round(predict(model, test.input, interval="predict", type="response"), digits=10))
out = c("Id", "predicted")
write.csv(Predicted.Test[out], "data\\resultsSVM.csv", row.names = FALSE)