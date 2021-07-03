library(caret)      # createDataPartition
library(rpart)      # rpart
library(rpart.plot) # rpart.plot
library(e1071)      # confusionMatrix
library(stringr)    # str_c
library(gtools)     # combinations
dataSetOriginal <- read.csv("E:\\repos\\LCC-IIA\\TP4\\glass.data")

# Eliminamos la columna de los indices.
dataSet <- dataSetOriginal[, -1]

# Ponemos nombre a las variables
colnames(dataSet)[1]  <- "R.I"
colnames(dataSet)[2]  <- "Sodio"
colnames(dataSet)[3]  <- "Magnesio"
colnames(dataSet)[4]  <- "Aluminio"
colnames(dataSet)[5]  <- "Silicio"
colnames(dataSet)[6]  <- "Potasio"
colnames(dataSet)[7]  <- "Calcio"
colnames(dataSet)[8]  <- "Bario"
colnames(dataSet)[9]  <- "Hierro"
colnames(dataSet)[10] <- "Clase"

for(i in seq(1,9)){
  combinaciones <- combinations(9,i,names(dataSet[-10]))
  for(j in 1:nrow(combinaciones)){
    combinacion <- combinaciones[j,]
    print(str_c(combinacion, collapse = " + "))
  }
}
