library(RevoScaleR)
file.name <- "YearPredictionMSD.txt";
rxOptions(sampleDataDir = "C:\\Users\\SI01017988\\Documents\\06-SQL\\5-BlogPosts\\37");
sampleDataDir <- rxGetOption("sampleDataDir");
inputFile <- file.path(sampleDataDir, "YearPredictionMSD.txt");
outputFile <- file.path(sampleDataDir, "YearPredictMSD.xdf");

#create class RxXdfData
YearMSD <- rxImport( inData = inputFile, outFile = outputFile, overwrite=TRUE);

#create class RxXdfData


#YearMSD <- rxResultsDF(rxImport( inData = inputFile, outFile = outputFile, overwrite=TRUE))
YearMDS_2 <- rxFactors(inData = YearMSD, sortLevels = TRUE,factorInfo = c("V1"))


###################################################



library(RevoScaleR)
file.name <- "YearPredictionMSD.txt";
rxOptions(sampleDataDir = "C:\\Users\\SI01017988\\Documents\\06-SQL\\5-BlogPosts\\37");
sampleDataDir <- rxGetOption("sampleDataDir");
inputFile <- file.path(sampleDataDir, "YearPredictionMSD.txt");
outputFile <- file.path(sampleDataDir, "YearPredictMSD.xdf");

rxHistogram(~F(V1), data = outputFile)


###################################################



library(RevoScaleR)
library(dplyr)
file.name <- "YearPredictionMSD.txt";
rxOptions(sampleDataDir = "C:\\Users\\SI01017988\\Documents\\06-SQL\\5-BlogPosts\\37");
sampleDataDir <- rxGetOption("sampleDataDir");
inputFile <- file.path(sampleDataDir, "YearPredictionMSD.txt");
outputFile <- file.path(sampleDataDir, "YearPredictMSD.xdf");

#CT <- rxCrossTabs(N(V2)~F(V1), data = "YearPredictMSD.xdf")
#CT <- rxCrossTabs(V2~F(V1), data = "YearPredictMSD.xdf")
#CT <- rxCrossTabs(V2~V1, data = "YearPredictMSD.xdf")
#rxCrossTabs(V2~F(V1), data = outputFile)
CT <- rxCrossTabs(V2~F(V1), data = outputFile)
CT1 <- data.frame(CT$sums$V2)
names <- dimnames(CT1)
CT1 <- data.frame(names[1])
CT2 <- data.frame(CT$sums)
CT3 <- data.frame(CT$counts)
df_f <- cbind(CT2, CT3, CT1)
colnames(df_f)[1] <- "sum"
colnames(df_f)[2] <- "count"
colnames(df_f)[3] <- "year"

#df_f$yearN <- as.integer(df_f$year)
#df_f %>% filter(yearN >= 78)


df_f %>%
  filter(year == c("2000","2001","2002"))


#select only couple of years with rxDataStep
rxDataStep(inData=outputFile, outFile="C:\\Users\\SI01017988\\Documents\\06-SQL\\5-BlogPosts\\37\\YearPredictMSD_Year.xdf", overwrite=TRUE, transforms=list(LateYears = V1 > 1999))

rxCrossTabs(V2~F(LateYears), data = "C:\\Users\\SI01017988\\Documents\\06-SQL\\5-BlogPosts\\37\\YearPredictMSD_Year.xdf")