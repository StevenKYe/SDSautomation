import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

df = pd.read_csv(r'..\uptoDateResults.csv', names=[
                 'tg', 'tint', 'tc', 'w', 'gain', 'freq'])
rounds = np.zeros(len(df))

for i in np.arange(len(df)):
    if i < 20:
        rounds[i] = 1
    else:
        rounds[i] = int(i/10)

df['rounds'] = rounds

fig, subplots = plt.subplots(1, 1, figsize=(6, 4), dpi=200)
subplots.scatter(df['rounds'], df['gain'])