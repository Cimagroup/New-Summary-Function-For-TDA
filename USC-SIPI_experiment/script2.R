require("TDA")
source('entropySummary_new.R')
source('NormaL1_new.R')
source('betti_curve_new.R')

#Each type of noisy image will have a folder
folders = c("grey","gauss", "poisson", "sandp")
# The domain of the functions will be from 0 to 1 with 5000 steps
tseq <- seq(0,1,1/1000)

nes_list <- list(list(), list(), list(), list())
betti_list <- list(list(), list(), list(), list())
sil_list <- list(list(), list(), list(), list())
sil2_list <- list(list(), list(), list(), list())


for (i in seq(length(folders))){
  aux <- 0
  for (j in dir(paste("diagrams_txt/",folders[i],"/", sep = ""))){
    aux <-  aux+1
    #We read the diagram and adapt them to the input format of the functions.
    #The first column is the dimension.
    dgm<- read.table(paste("diagrams_txt/",folders[i],"/",j, sep = ""))
    dgm[,3] <- dgm[,2]
    dgm[,2] <- dgm[,1]
    dgm[,1] <- 0
    #We change the infinity by a the maximum value of the domain: 1.
    dgm[which(dgm[, 3] == 'Inf'), 3] <- 1
    
    #Plot barcodes
    jpeg(paste("diagrams_plot",folders[i],gsub(".txt", ".jpg",gsub("img", "bar",j)), sep="/"))
    plot.diagram(dgm, barcode = TRUE)
    dev.off()
    
    #And calculate the curves
    nes <- entropySummary_new(barcode = dgm, domain = tseq)
    nes <- nes/NormaL1_new(nes, domain = tseq)
    betti <- betti_curve_new(barcode = dgm, domain = tseq)
    betti <- betti/NormaL1_new(betti, tseq)
    sil <- silhouette(dgm, p = 1, tseq, dimension = 0)
    sil <- sil/NormaL1_new(sil, tseq)
    sil2 <- silhouette(dgm, p = 2, tseq, dimension = 0)
    sil2 <- sil2/NormaL1_new(sil2, tseq)
    
    nes_list[[i]] <- c(nes_list[[i]], list(nes))
    betti_list[[i]] <- c(betti_list[[i]], list(betti))
    sil_list[[i]] <- c(sil_list[[i]], list(sil))
    sil2_list[[i]] <- c(sil2_list[[i]], list(sil2))
    
    jpeg(paste("nes/",folders[i],gsub(".txt", ".jpg", j), sep="/"))
    plot(tseq, nes, type = "l")
    dev.off()
    jpeg(paste("betti/",folders[i],gsub(".txt", ".jpg", j), sep="/"))
    plot(tseq, betti, type = "l")
    dev.off()
    jpeg(paste("silhouette_p1/",folders[i],gsub(".txt", ".jpg", j), sep="/"))
    plot(tseq, sil, type = "l")
    dev.off()
    jpeg(paste("silhouette_p2/",folders[i],gsub(".txt", ".jpg", j), sep="/"))
    plot(tseq, sil2, type = "l")
    dev.off()
  }
}

save.image(file = "script2.RData")
