library(rattle)
library(rpart.plot)
dataSetOriginal <- read.csv("E:\\repos\\LCC-IIA\\TP4\\glass.data") # esto estamos seguro 
dataSet <- dataSetOriginal[,-1]
dataSet[,10] <- as.factor(dataSet[,10]) #
columna3 <- createFolds(t(dataSet[,10]), k=3) # Dividimos el data set en 5 grupos
grupoEntrenamiento <- dataSet[columna3[[3]], ] # obtenemos los valores del dataset del grupo 3
entrenamiento <- dataSet[setdiff(seq(1:dim(dataSet)[1]), columna3[[3]]), ] 
entrenamientoFit <- rpart(X1.1~. , data = entrenamiento, parms = list(split = "gini"))
poda <- prune(entrenamientoFit, cp=0.1)
summary(entrenamientoFit)
fancyRpartPlot(poda, caption=NULL)
dataSet

# X13.64    X0.00    X0.06    X1.10    X4.49    X8.75 X1.52101 