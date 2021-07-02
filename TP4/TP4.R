library(caret)
library(rpart)
library(rattle)
library(rpart.plot)
library(e1071)
dataSetOriginal <- read.csv("E:\\repos\\LCC-IIA\\TP4\\glass.data") # esto estamos seguro 
dataSet <- dataSetOriginal[,-1]

colnames(dataSet)[1] <- "R.I"
colnames(dataSet)[2] <- "Sodio"
colnames(dataSet)[3] <- "Magnesio"
colnames(dataSet)[4] <- "Aluminio" #importante para la clasificacion
colnames(dataSet)[5] <- "Silicio"
colnames(dataSet)[6] <- "Potasio"
colnames(dataSet)[7] <- "Calcio"
colnames(dataSet)[8] <- "Bario"
colnames(dataSet)[9] <- "Hierro"
colnames(dataSet)[10] <- "Clase"

dataSet[,"Clase"] <- as.factor(dataSet[,"Clase"]) #
clasificacion <- createFolds(t(dataSet[,10]), k=5, ) # Dividimos el data set en 5 grupos para obter el 80% de entrenamiento.

#grupoEntrenamiento <- dataSet[clasificacion[[3]], ] # obtenemos los valores del dataset del grupo 3

entrenamiento <- dataSet[setdiff(seq(1:dim(dataSet)[1]), clasificacion[[3]]), ] 
entrenamientoFit <- rpart(Clase~Aluminio+Magnesio+Bario+R.I+Sodio, data = entrenamiento, parms = list(split = "gini"))
prediccion <- predict(entrenamientoFit, dataSet[clasificacion[[3]], -10], type="class")
confusionMatrix(prediccion, dataSet[clasificacion[[3]],10])
fancyRpartPlot(entrenamientoFit, caption=NULL)
plot(dataSet[,4], dataSet[,3], type="p", col=dataSet[,"Clase"])


poda <- prune(entrenamientoFit, cp=0.01)
prediccionPoda <- predict(poda, dataSet[clasificacion[[3]], -10], type="class")
confusionMatrix(prediccionPoda, dataSet[clasificacion[[3]],10])

summary(entrenamientoFit)
dataSet

# X13.64    X0.00    X0.06    X1.10    X4.49    X8.75 X1.52101 