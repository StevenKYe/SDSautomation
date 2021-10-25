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
for i in np.arange(6):
    subplots.plot(SDSgain.iloc[:, 0], SDSgain.iloc[:, 2*i+1], label=SDSgain.columns[2*i+1]+'nm')
subplots.set_xlabel('Acoustic frequncy (GHz)')
subplots.set_ylabel('Overlap between the optical and acoustic fields')
subplots.set_title('Overlap of the fields at different locations')
subplots.legend()
