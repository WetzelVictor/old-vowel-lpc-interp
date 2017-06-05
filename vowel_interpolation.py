import sys
import numpy as np
import wave
import math
from scipy.signal import lfilter, hamming
from scikits.talkbox import lpc
from matplotlib import pyplot as plt

### DEFINE FUNCTIONS ###
def get_LPC(x):
    # Get Hamming window.
    N = len(x)
    win = np.hamming(N)


    # Apply window and high pass filter.

    x = x * w
    x = lfilter([1., -0.63], 1, x1)

    # Get LPC.
    A, e, k = lpc(x1, 8)
    return(A, e, k)

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

A = np.empty([Nframes, Nwin]) # to store LPC
e = A
k = A

# Plot to verify
plt.figure()
plt.plot(firstVowel);
plt.grid(True)
plt.show();

# Loop through vowel to get LPCs
Wvowel = firstVowel.reshape(N/Nwin,Nwin)
