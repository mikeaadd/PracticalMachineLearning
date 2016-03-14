library(readr)
library(caret)
library(rattle)
library(doParallel)

trainingurl = "/Users/josephaddonisio/Downloads/Cousera/Machine Learning/pml-training.csv"
validationurl = "/Users/josephaddonisio/Downloads/Cousera/Machine Learning/pml-testing.csv"

train = read.csv(trainingurl,  na.strings=c("#DIV/0!", "NA","") )
validation = read.csv(validationurl, na.strings = c("", "NA","#DIV/0!"))


train.na = apply(train, 2, function (x) sum(is.na(x))/19622)
NA.vars = which(train.na > .95)
other.vars = which(names(train) %in% c('X', 'user_name', 'raw_timestamp_part_1', 'raw_timestamp_part_2', 'cvtd_timestamp', 'new_window', 'num_window'))

train = train[,-c(NA.vars, other.vars)]

table(train$classe)

set.seed(2282016)
index <- createDataPartition(train$classe, p=0.6, list = FALSE)
training <- train[index,]
testing <- train[-index,]

tree.model = train(classe ~ .,method="rpart",data=training)
fancyRpartPlot(tree.model$finalModel, sub = "")

tree.prediction <- predict(tree.model, testing)
confusionMatrix(tree.prediction, testing$classe)



registerDoParallel()
ctrl <- trainControl(classProbs=TRUE, savePredictions=TRUE, allowParallel=TRUE, number = 5)

rf.model = train(classe ~ ., method = "rf", data = training, trControl = ctrl, importance = TRUE)

rf.prediction <- predict(rf.model, testing)
confusionMatrix(rf.prediction, testing$classe)

var.imp = varImp(rf.model)
var.imp
plot(var.imp, top = 8)

final.prediction <- predict(rf.model, validation, type = "class")