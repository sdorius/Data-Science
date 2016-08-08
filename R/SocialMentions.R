##############################################################################
#                                 Social Mentions                            #
##############################################################################
#' @title
#' Social Mentions
#' 
#' @description 
#' Get Strength, Sentiment, Passion and Reach of a term in Blogs, MicroBlogs, 
#' Bookmarks, Images or all of the sources.
#' 
#' @param term - term which we intend to get the data
#' @param source - list of source of a term for which we intended to get the data 
#' @param time.frame - get only the results based on the mentioned timeframe.
#'
#' @return 
#' A data frame consisting of data related to the term belonging to a source 
#' with in the given time frame is returned.
#' 
#' @details 
#' \code{term} is any character string
#' \code{source} can be Blogs, MicroBlogs, Bookmarks, Images, all or list of all
#'  of the mentioned sources.
#' \code{time.frame} can be h, 12h, 24h, w, m or all. Meaning in respective order
#' Last Hour, Last 12 Hours, Last Day, Last Week, Last Month or Anytime.      
#'
#' @examples
#' socialMention("United_States")
#' 
#' source <- "blogs"
#' time.frame <- "12h"
#' socialMention("India", source, time.frame)
#'
#' @references
#' 
#' 
#' @seealso
#' \code{\link{}}
#'
#' @keywords
#' Social Mentions
#'
#' @import 
#' rvest
#'
#' @export
#'  
#' @author
#' Abhinav Yedla \email{abhinavyedla@gmail.com}

socialMention <- function(term, source = "all", time.frame = "all") {
  
  
  #Checking parameters
  if (missing(term)){
    stop("Please enter the term and try again")
  }else {
    #Replace space with + 
    term <- gsub(" ","+",x = term,fixed = TRUE)
  }
  
  if(length(unlist(time.frame)) > 1){
    stop("Please provide single time frame")
  }
  
  #Initialize varaiables
  df <- data.frame()
  
  #length of the source list
  n <- length(unlist(source)) 
  
  #Iterate over the number of elements in the source
  for (i in 1 : n) {
    #Url to be pinged for data
    url <- paste0("http://www.socialmention.com/search?q=",
                  term,
                  "&t=",
                  source[i],
                  "&tspan=",time.frame)
    
    #Ping twice so that dynamic content is loaded
    doc <- read_html(url)
   
    Sys.sleep(2)
    
    doc <- read_html(url)
    
    #Prepare the xpath expressions
    xpath <-
      "//div[@class = 'box_analytics']/div[@class = 'score']//text()"
    
    #Next two command will retrieve the requried data from entire html document
    data.XML.nodeset <- html_nodes(doc, xpath = xpath)
    data <- html_text(data.XML.nodeset)
    
  
    #Restoring the spaces
    term <- gsub("+"," ",x = term,fixed = TRUE)
    
    #Temporary data set for stroing  one iteration data
    temp.df <-
      data.frame(list(Sys.Date(),
                      source[i],
                      term,
                      data[1],
                      data[3],
                      data[4],
                      data[6]
                     ),check.names = FALSE)
    
    temp.df$TimeFrame <- time.frame
    
    colnames(temp.df) <-
      c("Date",
        "Source",
        "Term",
        "Strength",
        "Sentiment",
        "Passion",
        "Reach",
        "TimeFrame")
    
    #Bind the data by rows for one consolidated data set
    df <- rbind(df, temp.df)
  }
  return(df)
}