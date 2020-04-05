entropySummary_new <- function(barcode, domain, normalized = "False",
                              dimension.value = -1){
  
  if (dimension.value != -1 ){
    valid.intervals <- which(barcode[, 1] == dimension.value)
    n <- length(valid.intervals)
  } else {
    n <- dim(barcode)[1]
    valid.intervals <- 1 : n
  }
  
  infty.intervals <- which(barcode[, 3] == 'Inf')
  barcode[infty.intervals, 3] <- barcode[infty.intervals, 2]
  
  left <- barcode[, 2]
  right <- barcode[, 3]
  s <- right - left
  s <- s/(sum(s))
  aux <- which(s>0)
  s[aux] <- -s[aux]*log2(s[aux])
  
  
  ES <- matrix(0, nrow = 1, ncol = length(domain))
  
  for(i in seq_len(n)) {
    tmp <- pmax(pmin(domain - left[i], right[i] - domain), 0)
    tmp[tmp > 0] <- 1
    ES <- ES + s[i] * tmp
  }
  
  return(ES)
}