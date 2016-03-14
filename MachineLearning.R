library(readr)

trainingurl = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
validationurl = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"

train2 = read_csv(trainingurl, na = c("", "NA","#DIV/0!"))
train = read.csv("C:\\Users\\EDMike\\Downloads\\pml-training.csv", na.strings=c("#DIV/0!", "NA","") )
validation = read_csv(testingurl, na = c("", "NA","#DIV/0!"))


train.na = apply(train, 2, function (x) sum(is.na(x))/19622)
NA.vars = which(train.na > .95)
others.vars = which(names(train) %in% c('X', 'user_name', 'raw_timestamp_part_1', 'raw_timestamp_part_2', 'cvtd_timestamp', 'new_window', 'num_window'))

train = train[,-c(removed.vars2,other.vars)]

table(train$classe)

set.seed(2282016)
index <- createDataPartition(train$classe, p=0.6, list = FALSE)
training <- train[index,]
testing <- train[-index,]

tree.model = train(classe ~ .,method="rpart",data=training)
fancyRpartPlot(tree.model$finalModel, sub = "")

rf.model = train(classe ~ ., method = "rf", data = training )