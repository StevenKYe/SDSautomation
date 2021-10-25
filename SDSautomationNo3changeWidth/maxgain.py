# -*- coding: utf-8 -*-
"""
Created on Sat Oct 25 15:45:32 2021
get the maximum gain
@author: YeK
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import re
import glob
plt.style.use(['science', 'no-latex'])


fileList = glob.glob('results\*\*.csv')
maxgain = pd.DataFrame({'width': [], 'gain': [], 'freq': []})

for file in fileList:
    label = re.search(r'\d+', file).group(0)
    dataSingle = pd.read_csv(file, header=None)
    gain = max(dataSingle.iloc[:, 1])
    index = dataSingle.iloc[:, 1].idxmax()
    freq = dataSingle.iloc[index, 0]
    maxgain = maxgain.append(
        {'width': int(label), 'gain': gain, 'freq': freq}, ignore_index=True)

fig, subplots = plt.subplots(1, 1, dpi=200, figsize=(6, 4))
subplots.plot(maxgain.width, maxgain.gain, 'blue')
subplots.set_xlabel('width of SDS (nm)')
subplots.set_ylabel('Brillouin gain (m-1W-1)')
# subplots.set_title('Max Brillouin gain of the SDS with different width')
subplots2 = subplots.twinx()
subplots2.plot(maxgain.width, maxgain.freq, 'red')
subplots2.set_ylabel('Shift frequency (GHz)')
plt.savefig('maxgain.png')
