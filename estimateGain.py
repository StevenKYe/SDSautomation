# -*- coding: utf-8 -*-
"""
Created on Mon Oct 25 10:54:06 2021

@author: YeK
"""
import numpy as np
from scipy.constants import pi, c
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

def estGain(n, p12, lamb, rho, f_acous, fwhm):
    '''
    Calculate the estimated Brillouin gain of the bulk material

    Parameters
    ----------
    n : float64
        refractive index of the bulk material.
    p12 : float64
        electrostrictive coefficient.
    lamb : float64
        operating wavelength.
    rho : float64
        density of the bulk material.
    f_acous : float64
        Brillouin shift frequency.
    fwhm : float64
        FWHM of the material.

    Returns
    -------
    Estimated Brillouin gain.

    '''
    return 4 * pi * n**8 * p12**2 / (c * lamb**3 * rho * f_acous * fwhm)


# Calculation update 26/10/2021
# est_nitride = estGain(1.98, 0.047, 1550 * 10**(-9),
#                       3020, 20.84*10**9, 50*10**6)
# est_silica = estGain(1.48, 0.27, 1550 * 10**(-9),
#                      2240, 10.752*10**9, 50*10**6)

# Calculation update 03/11/2021
est_silica =  0.95 * estGain(1.45, 0.27, 1550 * 10**(-9),
                     2203, 10*10**9, 34*10**6)
est_chalco = 0.95 * estGain(2.37, 0.24, 1550 * 10**(-9),
                     3200, 7.7*10**9, 34*10**6)


linewidth = np.linspace(50, 300, 40)
Aeff = np.linspace(3,10, 40)
X, Y = np.meshgrid(linewidth, Aeff)

maxGain = 0.95 * estGain(1.45, 0.27, 1550 * 10**(-9),
                     2203, 10*10**9, X*10**6)/(Y*10**(-12))

z_min, z_max = np.abs(maxGain).min(), np.abs(maxGain).max()
fig, ax = plt.subplots(figsize=(6,4),dpi=200)
c = ax.pcolormesh(X, Y, maxGain, cmap='RdBu', vmin=z_min, vmax=z_max)
ax.set_title('Maximum Brillouin gain estimation of the SDS')
# set the limits of the plot to the limits of the data
ax.axis([linewidth.min(), linewidth.max(), Aeff.min(), Aeff.max()])
ax.set_xlabel('Linewidth (MHz)')
# ax.set_xticklabels([0, 100, 200, 300, 400, 500])
ax.set_ylabel('Effective mode area ($\mu m^2$)')
fig.colorbar(c, ax=ax)
