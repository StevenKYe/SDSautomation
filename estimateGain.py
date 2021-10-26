# -*- coding: utf-8 -*-
"""
Created on Mon Oct 25 10:54:06 2021

@author: YeK
"""
import numpy as np
from scipy.constants import pi, c


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


Aeff = 1.002 * 10**(-11)
est_nitride = estGain(1.98, 0.047, 1550 * 10**(-9),
                      3020, 20.84*10**9, 50*10**6)
est_silica = estGain(1.48, 0.27, 1550 * 10**(-9),
                     2240, 10.752*10**9, 50*10**6)
