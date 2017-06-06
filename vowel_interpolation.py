import sys
import numpy as np
import wave
import math
from scipy.signal import lfilter, hamming
from scikits.talkbox import lpc
from matplotlib import pyplot as plt

### DEFINE FUNCTIONS ###
def get_LPC(x, Npoles):
    # Get Hamming window.
    N = len(x)
    win = np.hamming(N)


    # Apply window and high pass filter.

    x = x * win
    x = lfilter([1., -0.63], 1, x)

    # Get LPC.
    A, e, k = lpc(x, Npoles)
    return(A) 




### PROGRAM ###

file_path = 'data/full-sentence.wav'

# Read from file.
spf = wave.open(file_path, 'r')

# Get file as numpy array.
sig = spf.readframes(-1)
sig = np.fromstring(sig, 'Int16')

# Get first vowel
flagA = 2000
flagB = 2000 + 512*4
firstVowel = sig[flagA:flagB]

#Basic variables
Nwin = 512 
N = len(firstVowel) 
Nframes = N / Nwin
Npoles = 25

A = np.empty([Nframes , Npoles + 1]) # to store LPC
e = A
k = A

# Plot to verify
#   plt.figure()
#   plt.plot(firstVowel);
#   plt.grid(True)
#   plt.show();

# Reshape to get 4 lines of signal
Wvowel = firstVowel.reshape(Nframes,Nwin)

### COMPUTING LPCs ###
for i in xrange(4):
    A[i, :] = get_LPC(Wvowel[i, :], Npoles)

