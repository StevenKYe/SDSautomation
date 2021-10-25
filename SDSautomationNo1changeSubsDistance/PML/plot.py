# -*- coding: utf-8 -*-
"""
Created on Sat Oct 16 15:45:32 2021

@author: YeK
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
plt.style.use(['science','no-latex'])


SDSgain = pd.read_csv('SDSgain.csv')
SDSgain1 = pd.read_csv('..\singlePoint(225&630nm)\SDSgain.csv')
SDSgain2 = pd.read_csv('SDSgain_630nm.csv')
SDSgain3 = pd.read_csv('SDSgain_630b.csv')

SDSgain = SDSgain[(SDSgain.iloc[:, 0] > 13.519) & (SDSgain.iloc[:, 0] < 13.64)]
SDSgain1 = SDSgain1[(SDSgain1.iloc[:, 0] > 13.519) & (SDSgain1.iloc[:, 0] < 13.64)]

fig, subplots = plt.subplots(1, 1, dpi=200, figsize=(6, 3))
subplots.plot(SDSgain.iloc[:,0], SDSgain.iloc[:,1], label='225nm (PML)')
subplots.plot(SDSgain1.iloc[:,0], SDSgain1.iloc[:,1], label='225nm (boundary)')
subplots.set_xlabel('Acoustic frequncy (GHz)')
subplots.set_ylabel('Brillouin gain (m-1W-1)')
subplots.set_title('Brillouin gain with PML layer/actual boundary')
subplots.legend()
subplots.set_xlim(13.515,13.645)
subplots.set_ylim(0,1)