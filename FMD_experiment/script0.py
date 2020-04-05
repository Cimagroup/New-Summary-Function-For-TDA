#We read images as grayscale and calculate their barcodes and persistence
#image. We save barcodes as .txt files to read them in R and save
#peristent images as a csv. 

import numpy as np
from skimage import io
from skimage import img_as_ubyte
from ripser import lower_star_img
import os
from persim import PersImage
import pandas as pd

categories = ['foliage', 'glass', 'leather', 'metal', 'paper', 'plastic', 
              'stone', 'water', 'wood', 'fabric']

              
folder = './imgs/'
data_persim = pd.DataFrame()

for archivo in os.listdir(folder):
    img=io.imread(folder + archivo, as_gray = True)
    img = img_as_ubyte(img)
    dgm = lower_star_img(img)
    np.savetxt('./barcodes_txt/' + archivo[:-4] + ".txt", dgm)
    
    pim = PersImage(verbose=False)
    dgm = array([array([float(x[0]), float(x[1])]) for x in dgm])
    dgm[len(dgm)-1][1] = 255
    mat = pim.transform(dgm)
    for k in range(len(categories)):
        if categories[k] in archivo:
            auxrow = [k]
    for i in range(len(mat)):
        for j in range(len(mat[i])):
            auxrow.append(mat[i][j])
    data_persim = pd.DataFrame([auxrow]).append(data_persim, ignore_index=True)
    
data_persim.to_csv('db_persim.csv')
