# -*- coding: utf-8 -*-
"""
Created on Sat Oct 16 15:45:32 2021
grep all csv files in current directory with regular expression, and plot the results
@author: YeK
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import re
import glob
plt.style.use(['science','no-latex'])


fileList = glob.glob('results\*\*.csv')
fig, subplots = plt.subplots(1, 1, dpi=200, figsize=(6, 4))
data = []
for file in fileList:
    label = re.search(r'\d+nm', file).group(0)
    dataSingle = pd.read_csv(file, header=None)
    dataSingle.columns = ['freq'+str(label), 'SBSgain'+str(label)]
    data.append(dataSingle)
    subplots.plot(dataSingle.iloc[:,0], dataSingle.iloc[:,1], label=str(label))
    subplots.set_xlabel('Acoustic frequency (GHz)')
    subplots.set_ylabel('Brillouin gain (m-1W-1)')
    subplots.set_title('Brillouin gain of 180/450/180 nm SDS at ' + str(label))
    directory = re.search(r'^\w+\\\w+\(\d+\w+\)\\', file).group(0)
    plt.savefig(directory+'SBSgain'+str(label)+'.png')
    plt.cla()