USE SQLR;
GO

CREATE PROCEDURE [dbo].[SP_YearMSD_CrossTab]
AS
BEGIN
	DECLARE @RScript nvarchar(max)
		SET @RScript = N'
				library(RevoScaleR)
				sampleDataDir <- rxGetOption("sampleDataDir");
				inputFile <- file.path(sampleDataDir, "YearPredictionMSD.txt");
				outputFile <- file.path(sampleDataDir, "YearPredictMSD.xdf");

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
				OutputDataSet <- df_f'



	  EXEC sp_execute_external_script 
					   @language = N'R'
					  ,@script = @RScript
					  --,@input_data_1 = N'SELECT 1'				  
		WITH result SETS ( (
							  SumOf DECIMAL(10,2)
							 ,CountOf DECIMAL(10,2)
							 ,YearOf INT
							 )
						 )
END;
GO



/*
-- Internal check

EXEC sp_execute_external_script 
	 @language = N'R'
	--,@script = N'OutputDataSet <- InputDataSet'
	,@script = N'OutputDataSet<- data.frame(rxGetOption("sampleDataDir"))'
	,@input_data_1 = N'SELECT 1'				  
WITH result SETS ((Options_get NVARCHAR(MAX)));

*/
