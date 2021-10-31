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

df = pd.read_csv('optics.csv', names=['x', 'y', 'fz', 'normE'])
x = df['x'].values.reshape(200, 200)
y = df['y'].values.reshape(200, 200)
normE = df['normE'].values.reshape(200, 200)
# Convert the Ex to complex number format
fz = df['fz']
fzReal = np.zeros(len(fz))
fzImag = np.zeros(len(fz))
for m in np.arange(len(fz)):
    singlefz = complex(fz[m].replace('i', 'j'))
    fzReal[m] = singlefz.real
    fzImag[m] = singlefz.imag

fzReal = fzReal.reshape(200, 200)
fzImag = fzImag.reshape(200, 200)
fig, subplots = plt.subplots(1, 1, figsize=(12, 17))
cf0 = subplots.pcolormesh(x, y, normE, cmap='rainbow')
fig.colorbar(cf0)
