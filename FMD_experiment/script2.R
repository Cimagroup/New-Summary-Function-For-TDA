#Save NES-function, Betti curve and silhouette as a csv file.
rm(list=ls())
load("script2.RData")
nn <- c()
labels <- c()

for (i in seq(length(categories))){
  nn <- c(nn, length(nes_list[[i]]))
  labels <- c(labels, rep(i-1, nn[i]))
}
myData <- data.frame(labels) 
for (l in seq(255)){
  aux <- c()	
  for (i in seq(length(categories))){
    for (j in seq(nn[i])){
      aux <- c(aux, nes_list[[i]][[j]][[l]])
    }
  }
  myData[paste("nes",as.character(l), sep="")] <- aux
}

for (l in seq(255)){
  aux <- c()	
  for (i in seq(length(categories))){
    for (j in seq(nn[i])){
      aux <- c(aux, betti_list[[i]][[j]][[l]])
    }
  }
  myData[paste("betti",as.character(l), sep="")] <- aux
}
for (l in seq(255)){
  aux <- c()	
  for (i in seq(length(categories))){
    for (j in seq(nn[i])){
      aux <- c(aux, sil_list[[i]][[j]][[l]])
    }
  }
  myData[paste("sil",as.character(l), sep="")] <- aux
}

write.csv(myData, "script2.csv", row.names=FALSE)
save.image(file = "script2.RData")