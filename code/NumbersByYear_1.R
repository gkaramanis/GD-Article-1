NumbersByYear_1_int <- function(d,num){
  analysisData <- d[!is.na(get(sprintf("analysisCat_%s",num)))]
  analysisData[,incidentYear:=get(sprintf("analysisYear_%s",num))]
  analysisData[,analysisName:=get(sprintf("analysisCat_%s",num))]
  
  agg <- analysisData[!is.na(incidentYear),
                      .(
                        N=.N
                      ),keyby=.(
                        analysisName,
                        incidentYear
                      )]
  
  return(agg)
}

NumbersByYear_1 <- function(d){
  
  res <- vector("list", length=sum(stringr::str_detect(names(d),"^analysisCat_[0-9]+")))
  for(i in seq_along(res)){
    res[[i]] <- NumbersByYear_1_int(d,num=i)
    x <- res[[i]][1,]
    for(j in names(x)){
      x[,(j):=NA]
    }
    res[[i]] <- rbind(res[[i]],x)
  }
  
  res <- rbindlist(res)
  
  openxlsx::write.xlsx(res, file=
                         file.path(FOLDERS$results_today,"analyses_1","NumbersByYear.xlsx"))
}