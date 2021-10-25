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
SDSgain = SDSgain[(SDSgain.iloc[:, 0] > 13.519) & (SDSgain.iloc[:, 0] < 13.64)]

fig, subplots = plt.subplots(1, 1, dpi=400, figsize=(6, 3))
for i in np.arange(11):
    subplots.set_xlabel('Acoustic frequncy (GHz)')
    subplots.set_ylabel('Brillouin gain (m-1 W-1)')
    subplots.set_title('Brillouin gain of the SDS at different locations')
    subplots.set_xlim(13.515,13.645)
    subplots.set_ylim(0,1)
    subplots.plot(SDSgain.iloc[:, 0], SDSgain.iloc[:, i+1], label=SDSgain.columns[i+1]+'nm')
    subplots.legend()
    plt.savefig(str(SDSgain.columns[i+1]) + '.png')
    plt.cla()
    
