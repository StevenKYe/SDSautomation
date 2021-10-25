# -*- coding: utf-8 -*-
"""
Created on Sat Oct 16 15:45:32 2021

@author: YeK
plot the SBSgain at different distance to the substrate
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
plt.style.use(['science','no-latex'])


SDSgain = pd.read_csv('SDSgain_sweep.csv')

fig, subplots = plt.subplots(1, 1, dpi=400, figsize=(6, 3))
for i in np.arange(7):
    subplots.plot(SDSgain.iloc[:, 0], SDSgain.iloc[:, i+15], label=SDSgain.columns[i+15]+'nm')
subplots.set_xlabel('Acoustic frequncy (GHz)')
subplots.set_ylabel('Brillouin gain (m-1 W-1)')
subplots.set_title('Brillouin gain of the SDS at different locations')
subplots.legend()

fig2, subplots2 = plt.subplots(1, 1, dpi=400, figsize=(6, 3))
t = np.linspace(140, 350, 22)
gain = SDSgain.max(axis=0)
subplots2.plot(t, gain[1:])
subplots2.set_xlabel('Distance to the center of the chip (nm)')
subplots2.set_ylabel('Brillouin gain (m-1 W-1)')
subplots2.set_title('Brillouin gain of the SDS at different locations')
subplots2.legend()