"""
Created on Sat Dec 14 12:45:10 2019

@author: cimagroup
"""

import os

import numpy as np
import matplotlib.pyplot as plt
from skimage import io
from skimage import img_as_ubyte
from ripser import lower_star_img
from persim import plot_diagrams

#os.chdir("/home/cimagroup/cuadernos4")

#%%
#Calcualte the list of images
imgs_name = []
aux=0
img_list = []
for archivo in sorted(os.listdir('misc')):
    imgs_name.append(archivo)
    img=io.imread('./misc/'+ archivo, as_gray = True)
    if any([any(img[x,:]>1) for x in range(img.shape[0])]):
        img = img/255
    img_list.append(img)
    #We need to transform image to uint 8 to save them with io.imgsave
    img = img_as_ubyte(img)
    #write units with a 0 to makes the alphabetical order coincide with the numerical order.
    if aux < 10:
        io.imsave("./images/grey/img0"+str(aux)+".png", img)
    else:
        io.imsave("./images/grey/img"+str(aux)+".png", img)
    aux += 1

#%%
    
#Create a funtion to apply noisy to images
def noisy(noise_typ,image):
   if noise_typ == "gauss":
      row, col = image.shape
      mean = 0
      var = 0.0001
      sigma = var**0.5
      gauss = np.random.normal(mean,sigma,(row,col))
      gauss = gauss.reshape(row,col)
      noisy = image + gauss
      return noisy
   elif noise_typ == "sandp":
      row, col = image.shape
      s_vs_p = 0.5
      amount = 0.001
      noisy = np.copy(image)
      # Salt mode
      num_salt = np.ceil(amount * image.size * s_vs_p)
      coords = [np.random.randint(0, i - 1, int(num_salt))
              for i in image.shape]
      noisy[coords] = 1

      # Pepper mode
      num_pepper = np.ceil(amount* image.size * (1. - s_vs_p))
      coords = [np.random.randint(0, i - 1, int(num_pepper))
              for i in image.shape]
      noisy[coords] = 0
      return noisy
   elif noise_typ == "poisson":
      vals = len(np.unique(image))
      vals = 2 ** np.ceil(np.log2(vals))
      noisy = np.random.poisson(image * vals) / float(vals)
      return noisy
    
#%%
    
#Apply noise to the images
gauss_list = []
sandp_list = []
poisson_list = []

aux = 0
for img in img_list:
    gauss = noisy("gauss", img)
    gauss[gauss>1] = 1
    gauss[gauss<0] = 0
    sandp = noisy("sandp", img)
    poisson = noisy("poisson", img)
    poisson[poisson>1] = 1
    poisson[poisson<0] = 0
    
    gauss_list.append(gauss)
    sandp_list.append(sandp)
    poisson_list.append(poisson)
    
    #We transform the images to uint8 to use io.imsave
    gauss = img_as_ubyte(gauss)
    sandp = img_as_ubyte(sandp)
    poisson = img_as_ubyte(poisson)

    if aux < 10:
        io.imsave("./images/gauss/gauss0"+str(aux)+".png", gauss)
        io.imsave("./images/sandp/sandp0"+str(aux)+".png", sandp)
        io.imsave("./images/poisson/poisson0"+str(aux)+".png", poisson)
    else:
        io.imsave("./images/gauss/gauss"+str(aux)+".png", gauss)
        io.imsave("./images/sandp/sandp"+str(aux)+".png", sandp)
        io.imsave("./images/poisson/poisson"+str(aux)+".png", poisson)
    aux += 1

#%%
#Calcualte the diagrams
aux = 0
for img in img_list:
    dgm = lower_star_img(img)
    if aux < 10:
        np.savetxt("./diagrams_txt/grey/img0"+str(aux)+".txt", dgm)  
    else:
        np.savetxt("./diagrams_txt/grey/img"+str(aux)+".txt", dgm)
    aux += 1
    
aux = 0
for img in gauss_list:
    dgm = lower_star_img(img)
    if aux < 10:
        np.savetxt("./diagrams_txt/gauss/gauss0"+str(aux)+".txt", dgm)
    else:
        np.savetxt("./diagrams_txt/gauss/gauss"+str(aux)+".txt", dgm)
    aux += 1
    
aux = 0
for img in sandp_list:
    dgm = lower_star_img(img)
    if aux < 10:
        np.savetxt("./diagrams_txt/sandp/sandp0"+str(aux)+".txt", dgm)
    else:
        np.savetxt("./diagrams_txt/sandp/sandp"+str(aux)+".txt", dgm)
    aux += 1
    
aux = 0
for img in poisson_list:
    dgm = lower_star_img(img)
    if aux < 10:
        np.savetxt("./diagrams_txt/poisson/poisson0"+str(aux)+".txt", dgm)
    else:
        np.savetxt("./diagrams_txt/poisson/poisson"+str(aux)+".txt", dgm)
    aux += 1
