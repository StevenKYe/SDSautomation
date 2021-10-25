# -*- coding: utf-8 -*-
"""
Created on Sat Oct 16 15:45:32 2021

@author: YeK
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
plt.style.use(['science','no-latex'])


SDSgain2300 = pd.read_csv('singlePoint(2300nm)\SBSgain2300nm.csv', header=None)
SDSgain2400 = pd.read_csv('singlePoint(2400nm)\SBSgain2400nm.csv', header=None)
SDSgain2500 = pd.read_csv('singlePoint(2500nm)\SBSgain2500nm.csv', header=None)
SDSgain2600 = pd.read_csv('singlePoint(2600nm)\SBSgain2600nm.csv', header=None)
SDSgain2700 = pd.read_csv('singlePoint(2700nm)\SBSgain2700nm.csv', header=None)
SDSgain2800 = pd.read_csv('singlePoint(2800nm)\SBSgain2800nm.csv', header=None)
SDSgain = pd.concat([SDSgain2300, SDSgain2400.iloc[:, 1], SDSgain2500.iloc[:, 1],
                     SDSgain2600.iloc[:, 1], SDSgain2700.iloc[:, 1], SDSgain2800.iloc[:, 1]], axis=1)

fig, subplots = plt.subplots(1, 1, dpi=200, figsize=(6, 4))
for i in np.arange(len(SDSgain.columns - 1)):
    subplots.plot(SDSgain.iloc[:, 0], SDSgain.iloc[:, i+1], label = str(2300 + i*100)+'nm')
    subplots.set_xlabel('Acoustic frequency (GHz)')
    subplots.set_ylabel('Brillouin gain (m-1W-1)')
    subplots.set_title('Brillouin gain of 180/450/180 nm SDS with different width')
    subplots.legend()
