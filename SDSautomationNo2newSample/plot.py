# -*- coding: utf-8 -*-
"""
Created on Sat Oct 16 15:45:32 2021

@author: YeK
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
plt.style.use(['science','no-latex'])



SDSgain = pd.read_csv('SBSgain.csv')
SDSgain.columns = ['freq_acous', 'gain']
SDSgain1 = pd.read_csv('SBSgain1.csv')
SDSgain1.columns = ['freq_acous', 'gain']
fig, subplots = plt.subplots(1, 1, dpi=200, figsize=(6, 3))
subplots.plot(SDSgain.freq_acous, SDSgain.gain, linewidth=2)
# subplots.plot(SDSgain1.freq_acous, SDSgain1.gain, linewidth=2)
subplots.set_xlabel('Acoustic frequency (GHz)')
subplots.set_ylabel('Brillouin gain (m-1W-1)')
subplots.legend()
