#lee el archivo con el nombre de las variables.
#reads the file named variables.
MyHeader <- read.table('./G_C_data/UCI HAR Dataset/features.txt', sep=" ")

#En analisis previo se determina que el archivo es de largo fijo y cada campo tiene un largo de 16
#In previous analysis determined that the file is fixed length and each field has a length of 16

#Determina las variables que en el nombre continen 'mean()' o 'std()' y forma un vector con el 0´s y 16´s (largo del campo).
#Determining the variables in the continental name 'mean ()' or 'std ()' and form a table with 0'sy 16's (along the field).
Mywidths <- 16*grepl("std()", MyHeader[,2])+16*grepl("mean()", MyHeader[,2])


#Remplaza los 0 con -16 para indicar que campos se importaran y cuales se saltan.
#Replace the 0 with -16 to indicate which fields are imported and are skipped.
Mywidths <- replace(Mywidths, Mywidths==0,-16)  

##Se deterinan los nombres de los campos a importar
#The names of the fields to import deterinan
HeaderVal <- grepl("std()", MyHeader[,2])|grepl("mean()", MyHeader[,2])

##Se importa el archivo de las lecturas, unicamente para las variables que se analizaran (STD y MEAN), se agregan los nombres de las columnas 
#File reads, only for variables that were analyzed (STD and MEAN) is imported, the names of the columns are added
train <- read.fwf('./G_C_data/UCI HAR Dataset/train/X_train.txt', widths = Mywidths,  col.names=MyHeader[,2][HeaderVal])
test <- read.fwf('./G_C_data/UCI HAR Dataset/test/X_test.txt', widths = Mywidths,  col.names=MyHeader[,2][HeaderVal])


library(plyr)

## Se carga el archivos de sujetos
#Loading the files subject 
Trainsubject <- read.table('./G_C_data/UCI HAR Dataset/train/subject_train.txt', sep=" ", col.names=c('subject'))
Testsubject <- read.table('./G_C_data/UCI HAR Dataset/test/subject_test.txt', sep=" ", col.names=c('subject'))

## Se carga el archivos de actividades
#Loading the files activities 
TrainAct <- read.table('./G_C_data/UCI HAR Dataset/train/y_train.txt', sep=" ", col.names=c('subject'))
TestAct <- read.table('./G_C_data/UCI HAR Dataset/test/y_test.txt', sep=" ", col.names=c('subject'))


## En el archivo de variables se adicionan las colummnas tipo , la columnna tipo es poblada con train y subject y activity se crean vacias
#In the file of the type colummnas variables are added, the columnna type is populated with train and subject and activity are created empty
train2 <- mutate(train, type ='train', subject = NA, activity = NA)
test2 <- mutate(test,  type ='test', subject = NA, activity = NA)

##se unen los dataframe de las variables, los sujetos y las actividades.
#the dataframe variables, subjects and join activities
train2[,'subject'] <- Trainsubject
train2[,'activity'] <- TrainAct

test2[,'subject'] <- Testsubject
test2[,'activity'] <- TestAct

library(tidyr)


GlobalData <- 

##Une los dos conjuntos de datos
## Connect the two data sets
	rbind(train2, test2) %>%

	##Transpone las variables y crea las columnas variable y val, la primera tiene el nombre y la segunda el valor
	## Transposes the variables and make the val variable and columns, the first has the name and the second value
	gather( variable, val, 1:79) %>%
	##Agupa el dataframe por las columnas prueba, type, subject, activity, variable
	## Agupa the test dataframe by columns, type, subject, activity variable
	group_by( type, subject, activity, variable) %>%
	##Calcula el promedio para cada grupo
	## Calculate the average for each group
	summarise( meandef=mean(val) )%>%
  ##Muestra el resultado
  ## Shows the result
  print
