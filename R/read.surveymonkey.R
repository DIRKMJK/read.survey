#' Read Surveymonkey file
#'
#' This function will open an xlsx or csv file containing the export of a Surveymonkey survey and deal with problems arising from the fact that variable information is included in the second row.
#' @param filename Name of the file to be opened.
#' @param format Format of the file. Defaults to xlsx.
#' @param convert Because Surveymonkey uses the second row for answer categories and other information, numeric variables will be converted to factors. If convert is set to TRUE, numeric variables containing only numbers will be converted (back) to numeric. Note that this need not always be the desired behaviour. Defaults to FALSE.
#' @return dataframe
#' @keywords 'Surveymonkey'
#' @export
#' @examples 
#' download.file('http://help.surveymonkey.com/servlet/servlet.FileDownload?file=01530000002hfBp', 'test.xlsx', method = 'curl') # Surveymonkey example export file
#' data <- read.surveymonkey('test.xlsx', convert = TRUE)

read.surveymonkey <- function(filename, format = 'xlsx', convert = FALSE){
  if (format == 'xlsx'){
    library(xlsx)
    data <- read.xlsx(filename, 1)
  }
  else if (format == 'csv') {
    data <- read.csv(filename)
  }
  else {
    print("Format needs to be 'csv' or 'xlsx'")
  }
  prefix <- ''
  for (i in 1:length(names(data))){
    if (substr(names(data)[i],1,2) == 'NA'){
      if(prefix == ''){
        prefix <- names(data)[i-1]
        names(data)[i-1] <- paste(prefix, data[1,i-1], sep = '_')        
      }
      else if(substr(names(data)[i-1],1,nchar(prefix)) != prefix) {
        prefix <- names(data)[i-1]
        names(data)[i-1] <- paste(prefix, data[1,i-1], sep = '_')
      }
      names(data)[i] <- paste(prefix, data[1,i], sep = '_')
    }    
  }
  data <- data[-1,]
  for (i in 1:length(names(data))){
    if (convert) {
      n <- TRUE
      for (j in 2: length(data[,i])) {
        if (!grepl('^[0-9]+$',gsub('\\.','',data[j,i])) & !is.na(data[j,i])) {
          n <- FALSE
        }
      }
      if(n){
        data[,i] <- as.numeric(as.character(data[,i]))
      }  
    }    
  }
  return (data)
}