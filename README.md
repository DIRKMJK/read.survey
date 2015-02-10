# read.survey

## Install
<code>library(devtools)</code><br>
<code>install_github('dirkmjk/read.survey')</code>

## Example

<code>download.file('http://help.surveymonkey.com/servlet/servlet.FileDownload?file=01530000002hfBp', 'test.xlsx', method = 'curl') # Surveymonkey example export file</code><br>
<code>data <- read.surveymonkey('test.xlsx', convert = TRUE)</code>
