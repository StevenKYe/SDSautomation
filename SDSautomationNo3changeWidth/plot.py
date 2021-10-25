# -*- coding: utf-8 -*-
"""
Created on Sat Oct 16 15:45:32 2021

@author: YeK
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
plt.style.use(['science','no-latex'])


SDSgain2600 = pd.read_csv('singlePoint(2600nm)\SBSgain2600nm.csv', header=None)
SDSgain2700 = pd.read_csv('singlePoint(2700nm)\SBSgain2700nm.csv', header=None)
SDSgain2600.columns = ['freq', 'SBSgain']
SDSgain2700.columns = ['freq', 'SBSgain']
# fig, subplots = plt.subplots(1, 1, dpi=200, figsize=(8, 6))
# subplots.plot(SDSgain_2800.freq_acous, SDSgain_2800.gain, linewidth=2, label='w:2800nm')
# subplots.plot(SDSgain_2800.freq_acous, SDSgain_2900.gain, linewidth=2, label='w:2900nm')
# subplots.set_xlabel('Acoustic frequency (GHz)')
# subplots.set_ylabel('Brillouin gain (m-1W-1)')
# subplots.legend()
