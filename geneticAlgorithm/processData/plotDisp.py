# -*- coding: utf-8 -*-
"""
Created on Fri Oct 29 15:41:51 2021

@author: YeK
Plot 3D image of the acoustic mode
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import re
from scipy import interpolate
import scipy.fftpack as ft
from matplotlib.colors import LinearSegmentedColormap
plt.style.use(['science', 'no-latex'])

cmap = pd.read_csv('heatCamera.txt', skiprows=1, sep=' ', names=['r','g','b'])
cmapList = []

for _, rows in cmap.iterrows():
    cmapRow = rows.to_list()
    cmapList.append(cmapRow)

heatCamera = LinearSegmentedColormap.from_list('heatCamera', cmapList)

df = pd.read_csv('disp.txt', names=['x', 'y', 'disp'])
x = df['x'].values.reshape(1001, 1001)
y = df['y'].values.reshape(1001, 1001)
# Convert the Ex to complex number format
disp = df['disp'].values.reshape(1001, 1001)
    
# fig, subplots = plt.subplots(1,1,figsize=(4,4), dpi=200)
# cf0 = subplots.pcolormesh(x, y, disp, cmap=heatCamera)
# subplots.set_xticks([])
# subplots.set_yticks([])

fig1 = plt.figure(figsize=(6,4), dpi=200)
ax = plt.subplot(111, projection='3d')
ax.xaxis.pane.fill = False
ax.xaxis.pane.set_edgecolor('white')
ax.yaxis.pane.fill = False
ax.yaxis.pane.set_edgecolor('white')
ax.zaxis.pane.fill = False
ax.zaxis.pane.set_edgecolor('white')
ax.grid(False)
ax.axis('off')
ax.view_init(azim=-10)
ax.plot_surface(x, y, disp, cmap='inferno')
fig1.savefig('demo.png', transparent=True)