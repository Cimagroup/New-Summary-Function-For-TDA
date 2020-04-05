# Read the barcodes and save them as images. Calculate NES-function, 
# Betti curve and slhouettes for p=1,5,10. Save them as lists and images.
require("TDA")
source('entropySummary_new.R')
source('NormaL1_new.R')
source('betti_curve_new.R')


categories = c('foliage', 'glass', 'leather', 'metal', 'paper', 'plastic', 'stone',
             'water', 'wood', 'fabric')
# The domain of the functions will be from 0 to 255 with 1 step
tseq <- seq(255)

nes_list <- list()
betti_list <- list()
sil1_list <- list()
sil5_list <- list()
sil10_list <- list()

for (i in seq(length(categories))){
  nes_list <- c(nes_list, list(list()))
  betti_list <- c(betti_list, list(list()))
  sil1_list <- c(sil1_list, list(list()))
  sil5_list <- c(sil5_list, list(list()))
  sil10_list <- c(sil10_list, list(list()))
  for (j in dir("barcodes_txt/")){
    if (grepl(categories[i], j)){
      #We read the diagram and adapt them to the input format of the functions.
      #The first column is the dimension.
      dgm<- read.table(paste("barcodes_txt/","/",j, sep = ""))
      dgm[,3] <- dgm[,2]
      dgm[,2] <- dgm[,1]
      dgm[,1] <- 0
      #We change the infinity by a the maximum value of the domain: 255.
      dgm[which(dgm[, 3] == 'Inf'), 3] <- 255
      
      #Plot barcodes
      jpeg(paste("barcodes_img", gsub(".txt", ".jpg", j), sep="/"))
      plot.diagram(dgm, barcode = TRUE)
      dev.off()
      
      #And calculate the curves
      nes <- entropySummary_new(barcode = dgm, domain = tseq)
      nes <- nes/NormaL1_new(nes, domain = tseq)
      betti <- betti_curve_new(barcode = dgm, domain = tseq)
      betti <- betti/NormaL1_new(betti, tseq)
      sil1 <- silhouette(dgm, p = 1, tseq, dimension = 0)
      sil1 <- sil1/NormaL1_new(sil1, tseq)
      sil5 <- silhouette(dgm, p = 5, tseq, dimension = 0)
      sil5 <- sil5/NormaL1_new(sil5, tseq)
      sil10 <- silhouette(dgm, p = 10, tseq, dimension = 0)
      sil10 <- sil10/NormaL1_new(sil10, tseq)
      
      nes_list[[i]] <- c(nes_list[[i]], list(nes))
      betti_list[[i]] <- c(betti_list[[i]], list(betti))
      sil1_list[[i]] <- c(sil1_list[[i]], list(sil1))
      sil5_list[[i]] <- c(sil5_list[[i]], list(sil5))
      sil10_list[[i]] <- c(sil10_list[[i]], list(sil10))
      
      jpeg(paste("nes/",gsub(".txt", ".jpg", j), sep="/"))
      plot(tseq, nes, type = "l")
      dev.off()
      jpeg(paste("betti/",gsub(".txt", ".jpg", j), sep="/"))
      plot(tseq, betti, type = "l")
      dev.off()
      jpeg(paste("silhouette1/",gsub(".txt", ".jpg", j), sep="/"))
      plot(tseq, sil1, type = "l")
      dev.off()
      jpeg(paste("silhouette5/",gsub(".txt", ".jpg", j), sep="/"))
      plot(tseq, sil5, type = "l")
      dev.off()
      jpeg(paste("silhouette10/",gsub(".txt", ".jpg", j), sep="/"))
      plot(tseq, sil10, type = "l")
      dev.off()
    }
  }
}

save.image(file = "script2.RData")