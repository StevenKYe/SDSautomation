# -*- coding: utf-8 -*-
"""
Created on Sat Oct 16 15:45:32 2021

@author: YeK
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
plt.style.use(['science','no-latex'])


"""
Full range plot
"""
SDSgain = pd.read_csv('SDSgain.csv')
fig, subplots = plt.subplots(1, 1, dpi=200, figsize=(6, 4))
subplots.plot(SDSgain['freq_acous'], SDSgain['up@225nm'], label='t=225nm')
subplots.plot(SDSgain['freq_acous'], SDSgain['up@630nm'], label='t=630nm')
subplots.set_xlabel('Acoustic frequncy (GHz)')
subplots.set_ylabel('Brillouin gain (m-1W-1)')
subplots.legend()

"""
zoom-in plot
"""
SDSgain = SDSgain[(SDSgain.iloc[:, 0] > 13.519) & (SDSgain.iloc[:, 0] < 13.64)]
fig, subplots = plt.subplots(1, 1, dpi=200, figsize=(6, 4))
subplots.plot(SDSgain['freq_acous'], SDSgain['up@630nm'], label='225nm')
subplots.set_xlabel('Acoustic frequncy (GHz)')
subplots.set_ylabel('Brillouin gain (m-1W-1)')
subplots.legend()
subplots.set_xlim(13.515,13.645)
subplots.set_ylim(0,1)