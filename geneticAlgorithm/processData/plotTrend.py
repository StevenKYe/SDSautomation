import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
plt.style.use(['science', 'no-latex'])

df = pd.read_csv(r'..\uptoDateResults.csv', names=[
                 'tg', 'tint', 'tc', 'w', 'gain', 'freq'])
rounds = np.zeros(len(df))

for i in np.arange(len(df)):
    if i < 20:
        rounds[i] = 1
    else:
        rounds[i] = int(i/10)

df['rounds'] = rounds

# fig, subplots = plt.subplots(1, 1, figsize=(6, 4), dpi=200)
# subplots.scatter(df['rounds'], df['gain'], color='#0C5DA5')
# subplots.set_title('Brillouin gain trend of the SDS variants')
# subplots.set_xlabel('Evolution rounds of the genetic algorithm')
# subplots.set_xticks(np.arange(1,11,1))
# subplots.set_ylabel('Brillouin gain (m-1W-1)')


fig, subplots = plt.subplots(1, 1, figsize=(6, 4), dpi=200)
subplots.scatter(df['rounds'], df['freq'], color='#0C5DA5')
subplots.set_title('Brillouin shift frequency trend of the SDS variants')
subplots.set_xlabel('Evolution rounds of the genetic algorithm')
subplots.set_xticks(np.arange(1,11,1))
subplots.set_ylabel('Brillouin shfit frequency (GHz)')