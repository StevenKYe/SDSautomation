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


SDSgain = pd.read_csv('SDSgain_sweep.csv',index_col=None)
fig, subplots = plt.subplots(1, 1, dpi=400, figsize=(6, 3))
subplots.plot(SDSgain.iloc[:,0], SDSgain.iloc[:,1], label='-500 nm')
subplots.plot(SDSgain.iloc[:,0], SDSgain.iloc[:,2], label='-389 nm')
subplots.plot(SDSgain.iloc[:,0], SDSgain.iloc[:,3], label='-278 nm')
subplots.plot(SDSgain.iloc[:,0], SDSgain.iloc[:,4], label='55 nm')
subplots.plot(SDSgain.iloc[:,0], SDSgain.iloc[:,5], label='167 nm')
subplots.plot(SDSgain.iloc[:,0], SDSgain.iloc[:,6], label='278 nm')
subplots.plot(SDSgain.iloc[:,0], SDSgain.iloc[:,7], label='389 nm')
subplots.set_xlabel('Acoustic frequncy (GHz)')
subplots.set_ylabel('Brillouin gain (m-1W-1)')
subplots.legend()
