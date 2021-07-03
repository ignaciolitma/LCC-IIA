library(caret)      # createDataPartition
library(rpart)      # rpart
library(rpart.plot) # rpart.plot
library(e1071)      # confusionMatrix

# Leemos el dataset original
dataSetOriginal <- read.csv("glass.data")

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

# Convertimos a factor la columna de las clases.
dataSet[, "Clase"] <- as.factor(dataSet[, "Clase"])

# Contadores para elegir la mejor metrica
ginni = 0
information = 0
sumaGinni = 0
sumaInformation = 0
semillas = 50

for (seed in seq(0, semillas)) {
    # Establecemos una semilla.
    set.seed(seed)

    # Dividimos el dataset en datos de entrenamiento y prueba.
    indices <- createDataPartition(dataSet[, "Clase"], p = .8, list = FALSE)
    entrenamiento <- dataSet[indices,]
    prueba <- dataSet[-indices,]

    # Creamos modelos a partir de los datos de entrenamiento.
    informationFit <- rpart(Clase ~ ., # Aluminio + Magnesio + Bario + R.I + Sodio,
                            data = entrenamiento, parms = list(split = "information"))
    ginniFit <- rpart(Clase ~ ., # Aluminio + Magnesio + Bario + R.I + Sodio,
                      data = entrenamiento, parms = list(split = "gini"))

    # Podamos los arboles
    podaI <- prune(informationFit, cp = 0.01)
    podaG <- prune(ginniFit, cp = 0.01)

    # Probamos los modelos en los datos de prueba.
    prediccionI <- predict(informationFit, prueba, type = "class")
    prediccionG <- predict(ginniFit, prueba, type = "class")
    prediccionPodaI <- predict(podaI, prueba, type = "class")
    prediccionPodaG <- predict(podaG, prueba, type = "class")

    # Calculamos estadisticas.
    matrizI <- confusionMatrix(prediccionI, prueba[, "Clase"])
    matrizG <- confusionMatrix(prediccionG, prueba[, "Clase"])
    matrizPodaI <- confusionMatrix(prediccionPodaI, prueba[, "Clase"])
    matrizPodaG <- confusionMatrix(prediccionPodaG, prueba[, "Clase"])

    if (matrizPodaI$overall["Accuracy"] > matrizI$overall["Accuracy"]) {
        cat("ATENCION: Poda mejor que information.\n")
    }
    if (matrizPodaG$overall["Accuracy"] > matrizG$overall["Accuracy"]) {
        cat("ATENCION: Poda mejor que ginni\n")
    }

    cat("[", seed, "] ")
    if (matrizG$overall["Accuracy"] >= matrizI$overall["Accuracy"]) {
        cat("Ginni Accuracy:\t\t", matrizG$overall["Accuracy"], "\n")
        ginni <- ginni + 1
        sumaGinni <- sumaGinni + matrizG$overall["Accuracy"]
    } else {
        cat("Information Accuracy:\t", matrizI$overall["Accuracy"], "\n")
        information <- information + 1
        sumaInformation <- sumaInformation + matrizI$overall["Accuracy"]
    }

    # Dibujamos el arbol
    # rpart.plot(fit)
}

# Decidimos la mejor metrica
promedioG = sumaGinni / ginni
promedioI = sumaInformation / information
cat("\n")
if (promedioG >= promedioI) {
    cat("Mejor metrica: ginni.\n")
    cat("Accuracy promedio:", promedioG, "\n")
} else {
    cat("Mejor metrica: information.\n")
    cat("Accuracy promedio:", promedioI, "\n")
}
