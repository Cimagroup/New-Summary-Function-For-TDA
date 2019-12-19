betti_curve_new <- function(barcode, domain, normalized = "False",
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
  
  ES <- matrix(0, nrow = 1, ncol = length(domain))
  
  for(i in seq_len(n)) {
    tmp <- pmax(pmin(domain - left[i], right[i] - domain), 0)
    tmp[tmp > 0] <- 1
    ES <- ES + tmp
  }
  
  return(ES)
}