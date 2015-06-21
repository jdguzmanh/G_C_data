Los datos iniciales son almacenados en G_C_data
The initial data are stored in G_C_data


- MyHeader: Almacena los nombres de todos los encabezados que se encuentran en el archivo features.txt
			Stores the names of all the headings found in the file features.txt

			#lee el archivo con el nombre de las variables.
			#reads the file named variables.
			MyHeader <- read.table('./G_C_data/UCI HAR Dataset/features.txt', sep=" ")

- Mywidths: Calculo de con 16 y -16 para determinar que variables se cargaran para el analisis, 16 es el largo de las columnas en los archivos train y test
			Calculation of 16 and -16 to determine which variables will be loaded for analysis, 16 is the length of the columns in the train and test files
			
			#Determina las variables que en el nombre continen 'mean()' o 'std()' y forma un vector con el 0´s y 16´s (largo del campo).
			#Determining the variables in the continental name 'mean ()' or 'std ()' and form a table with 0'sy 16's (along the field).
			Mywidths <- 16*grepl("std()", MyHeader[,2])+16*grepl("mean()", MyHeader[,2])

			#Remplaza los 0 con -16 para indicar que campos se importaran y cuales se saltan.
			#Replace the 0 with -16 to indicate which fields are imported and are skipped.
			Mywidths <- replace(Mywidths, Mywidths==0,-16)  


- HeaderVal: 	Selecciona los encabezados que contienen "std()" o "mean()" en MyHeader, que son las variables a analizar
				Select headers containing "std ()" or "mean ()" on myHeader, which are the variables to be analyzed

			##Se deterinan los nombres de los campos a importar
			#The names of the fields to import deterinan
			HeaderVal <- grepl("std()", MyHeader[,2])|grepl("mean()", MyHeader[,2])


- train: 	Almacena los resultados de train
			Stores the results of train
- test: 	Almacena los resultados de test
			Stores the results of test

			##Se importa el archivo de las lecturas, unicamente para las variables que se analizaran (STD y MEAN), se agregan los nombres de las columnas 
			#File reads, only for variables that were analyzed (STD and MEAN) is imported, the names of the columns are added
			train <- read.fwf('./G_C_data/UCI HAR Dataset/train/X_train.txt', widths = Mywidths,  col.names=MyHeader[,2][HeaderVal])
			test <- read.fwf('./G_C_data/UCI HAR Dataset/test/X_test.txt', widths = Mywidths,  col.names=MyHeader[,2][HeaderVal])


- Trainsubject: Almacena los datos de './UCI HAR Dataset/train/subject_train.txt' que contiene los valores de los sujetos para cada observación de train
				Stores './UCI HAR Dataset/train/subject_train.txt' containing the values of the subjects for each observation train
- Testsubject: 	Almacena los datos de  './UCI HAR Dataset/test/subject_test.txt' que contiene los valores de los sujetos para cada observación de train
				Stores data './UCI HAR Dataset/test/subject_test.txt' containing the values of the subjects for each observation train

			## Se carga el archivos de sujetos
			#Loading the files subject 
			Trainsubject <- read.table('./G_C_data/UCI HAR Dataset/train/subject_train.txt', sep=" ", col.names=c('subject'))
			Testsubject <- read.table('./G_C_data/UCI HAR Dataset/test/subject_test.txt', sep=" ", col.names=c('subject'))

- TrainAct: Almacena los datos de './UCI HAR Dataset/train/y_train.txt' que contiene los valores de las actividades para cada observación de train
			Stores data './UCI HAR Dataset / train / y_train.txt' containing the values of the activities for each observation train
- TestAct: 	Almacena los datos de './UCI HAR Dataset/test/y_test.txt' que contiene los valores de las actividades para cada observación de test
			Stores data './UCI HAR Dataset / test / y_test.txt' containing the values of the activities for each observation test


			## Se carga el archivos de actividades
			#Loading the files activities 
			TrainAct <- read.table('./G_C_data/UCI HAR Dataset/train/y_train.txt', sep=" ", col.names=c('subject'))
			TestAct <- read.table('./G_C_data/UCI HAR Dataset/test/y_test.txt', sep=" ", col.names=c('subject'))

- train2: 	Nueva estructura para almacenar sujetos y actividad en el mismo dataframe
			New structure for storing subjects and activity in the same dataframe
- test2: 	Nueva estructura para almacenar sujetos y actividad en el mismo dataframe
			New structure for storing subjects and activity in the same dataframe	
			
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

- GlobalData: 	Almancena el resultado final para exportalo a un archivo txt separado por ";"
				Almancena the end result to export it to a txt file separated by ";"

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
			  ## exporta el resultado
			  ## export the result
			  write.table('GlobalData.txt',  sep=';', dec=',')


