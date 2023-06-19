# -*- coding: utf-8 -*-
"""
In this file your task is to write the solver function!

"""
def solver(t,w):
    """
    Parameters
    ----------
    t : TYPE: float
        DESCRIPTION: the angle theta
    w : TYPE: float
        DESCRIPTION: the angular speed omega

    Returns
    -------
    F : TYPE: float
        DESCRIPTION: the force that must be applied to the cart
    or
    
    None :if we have a division by zero

    """    
    theta = {"NVB": [-50, -25, -40], "NB": [-40, -10, -25], "N": [-20, 0, -10], "ZO": [-5, 5, 0], "P": [0, 20, 10],
             "PB": [10, 40, 25], "PVB": [25, 50, 40]}
    
    omega = {"NB": [-10, -3, -8], "N": [-6, 0, -3], "ZO": [-1, 1, 0], "P": [0, 6, 3], "PB": [3, 10, 8]}
    
    force = {'NVB+NB': 'NVVB', 'NVB+N': 'NVVB', 'NVB+ZO': 'NVB', 'NVB+P': 'NB', 'NVB+PB': 'N',
             'NB+NB': 'NVVB', 'NB+N': 'NVB', 'NB+ZO': 'NB', 'NB+P': 'N', 'NB+PB': 'Z', 'N+NB': 'NVB', 'N+N': 'NB', 'N+ZO': 'N',
             'N+P': 'Z', 'N+PB': 'P', 'ZO+NB': 'NB', 'ZO+N': 'N', 'ZO+ZO': 'Z', 'ZO+P': 'P', 'ZO+PB': 'PB',
             'P+NB': 'N', 'P+N': 'Z', 'P+ZO': 'P', 'P+P': 'PB', 'P+PB': 'PVB', 'PB+NB': 'Z', 'PB+N': 'P', 'PB+ZO': 'PB',
             'PB+P': 'PVB', 'PB+PB': 'PVVB', 'PVB+NB': 'P', 'PVB+N': 'PB', 'PVB+ZO': 'PVB', 'PVB+P': 'PVVB', 'PVB+PB': 'PVVB'}
    
    products = {'NVVB': -32, 'NVB': -24, 'NB': -16, 'N': -8, 'Z': 0, 'P': 8, 'PB': 16, 'PVB': 24, 'PVVB': 32}
    



    miutheta = {}
    miuomega = {}
    force_membership = {}

    for i in theta:
        miutheta[i] = 0
        if theta[i][0] <= t <= theta[i][1]:
            miutheta[i] = max(0, min((t - theta[i][0]) / (theta[i][2] - theta[i][0]), 1, (theta[i][1] - t) / (theta[i][1] - theta[i][2])))
    
    for i in omega:
        miuomega[i] = 0
        if omega[i][0] <= w <= omega[i][1]:
            miuomega[i] = max(0, min((w - omega[i][0]) / (omega[i][2] - omega[i][0]), 1, (omega[i][1] - w) / (omega[i][1] - omega[i][2])))    
    
    for i in theta:
        for j in omega:
            val = min(miutheta[i], miuomega[j])
            new_key = i + '+' + j
            if  force[new_key] not in force_membership or force_membership[force[new_key]] < val:
                force_membership[force[new_key]] = val
    
    s = 0
    p = 0
    for i in force_membership:
        s += force_membership[i]
        p += force_membership[i] * products[i]

    try:
        F = p / s
    #in case division by zero
    except:
        F = 0
        
    return F




