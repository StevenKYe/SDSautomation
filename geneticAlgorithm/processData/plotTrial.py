# -*- coding: utf-8 -*-
"""
Created on Fri Oct 29 15:41:51 2021

@author: YeK
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import re
from scipy import interpolate
import scipy.fftpack as ft
plt.style.use(['science', 'no-latex'])

df = pd.read_csv('electricField.csv', names=['x', 'y', 'Ex', 'Ey', 'Ez', 'normE'])
x = df['x'].values.reshape(200, 200)
y = df['y'].values.reshape(200, 200)
# Convert the Ex to complex number format
Ex = df['Ex']
ExReal = np.zeros(len(Ex))
ExImag = np.zeros(len(Ex))
for m in np.arange(len(Ex)):
    singleEx = complex(Ex[m].replace('i', 'j'))
    ExReal[m] = singleEx.real
    ExImag[m] = singleEx.imag
    
ExReal = ExReal.reshape(200, 200)
ExImag = ExImag.reshape(200, 200)
fig, subplots = plt.subplots(1,1,figsize=(12, 17))
cf0 = subplots.pcolormesh(x, y, ExReal)
fig.colorbar(cf0)