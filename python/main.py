import numpy as np 
import matplotlib.pyplot as plt 
from scipy import signal
from scipy.signal import dlti, dimpulse


#generation signal
Fe = 1e6
Te = 1/Fe
T = 0.01
N = int(np.round(T / Te))
t = np.linspace(0, T, N)

f1 = 1e3
f2 = 1e4
A1 = 2
A2 = 1

s = A1 * np.sin(2 * np.pi * f1 * t) + A2 * np.sin(2 * np.pi * f2 * t)

plt.figure()
plt.plot(t,s)
plt.title("signal temporel")


#TFD
fft = np.fft.fft(s)
frequences = np.fft.fftfreq(N, d=Te)

plt.figure()
plt.plot(frequences, np.abs(fft))
plt.title("Spectre fréquentiel")


plt.figure()
plt.semilogx(frequences, np.abs(fft))
plt.title("Spectre fréquentiel echelle log")


## filtre

###############################
#  filtre passe-bas fc = 10kHz pour selectionner f1 = 1kHz
###############################
fc = 5e3  
b_low, a_low = signal.butter(3 , fc,btype='lowpass', fs=Fe) # ordre 4
print('a_low : ', a_low)
print('b_low : ', b_low)

print('a_low_vhdl 20 bits fractionaire : ', np.round(a_low*2**20))
print('b_low_vhdl 20 bits fractionaire: ', np.round(b_low*2**20))
print('a_low_vhdl 28 bits fractionaire : ', np.round(a_low*2**28))
print('b_low_vhdl 28 bits fractionaire: ', np.round(b_low*2**28))
# Réponse fréquentielle
w_low, h_low = signal.freqz(b_low, a_low, fs=Fe)

# Amplitude
plt.figure()
plt.plot(w_low, 20 * np.log10(np.abs(h_low) + 1e-12))
plt.axvline(fc, color='r', linestyle='--', label="fc = 10 kHz")
plt.title("Réponse fréquentielle passe bas(gain)")
plt.xlabel("Fréquence (Hz)")
plt.ylabel("Amplitude (dB)")
plt.grid()
plt.legend()
# Phase
plt.figure()
plt.plot(w_low, np.angle(h_low))
plt.title("Phase passe bas")
plt.xlabel("Fréquence (Hz)")
plt.ylabel("Phase (rad)")


###############################
#  filtre passe-bande fc1,fc2 = 9kHz, 11kHz   , pour selectionner f2 = 10kHz
###############################


fc1,fc2 = 9e3, 11e3


b_band, a_band = signal.butter(2, [fc1, fc2], btype='bandpass', fs=Fe)
print('a_band : ', a_band)
print('b_band : ', b_band)

print('a_band_vhdl 20 bits fractionaire : ', np.round(a_band*2**20))
print('b_band_vhdl 20 bits fractionaire: ', np.round(b_band*2**20))

print('a_band_vhdl 28 bits fractionaire : ', np.round(a_band*2**28))
print('b_band_vhdl 28 bits fractionaire: ', np.round(b_band*2**28))
# Réponse fréquentielle
w_band, h_band = signal.freqz(b_band, a_band, fs=Fe)

# Amplitude
plt.figure()
plt.plot(w_band, 20 * np.log10(np.abs(h_band) + 1e-12))
plt.axvline(fc1, color='r', linestyle='--', label="fc1 = 9 kHz")
plt.axvline(fc2, color='r', linestyle='--', label="fc2 = 11 kHz")
plt.title("Réponse fréquentielle passe bande(gain)")
plt.xlabel("Fréquence (Hz)")
plt.ylabel("Amplitude (dB)")
plt.grid()
plt.legend()
# Phase
plt.figure()
plt.plot(w_band, np.angle(h_band))
plt.title("Phase passe bande")
plt.xlabel("Fréquence (Hz)")
plt.ylabel("Phase (rad)")


##############################
## extraction des poles
####################################


# z: zeros, p:poles, k:gain

z_low, p_low, k_low = signal.tf2zpk(b_low, a_low) # passe bas

z_band, p_band, k_band = signal.tf2zpk(b_band, a_band) # passe bande

print("poles passe bas : ", abs(p_low))
print("poles passe bande : ", abs(p_band))

N=20

for n in range(1, N):

    print(n)
    trunc_a_low = np.trunc(a_low * 10**(N-n)) / 10**(N-n)
    trunc_b_low = np.trunc(b_low * 10**(N-n)) / 10**(N-n)

    z_low, p_low, k_low = signal.tf2zpk(trunc_b_low, trunc_a_low) # passe bas

    print("poles passe bas : ", abs(p_low) < 1, "n=",N-n)

    trunc_a_band = np.trunc(a_band * 10**(N-n)) / 10**(N-n)
    trunc_b_band = np.trunc(b_band * 10**(N-n)) / 10**(N-n)

    z_band, p_band, k_band = signal.tf2zpk(trunc_b_band, trunc_a_band) # passe bas
    print("poles passe bande : ", abs(p_band) < 1, "n=",N-n)




# Fonction pour tracer pôles et zéros
def plot_poles_zeros(z, p, title):
    plt.figure(figsize=(6,6))
    plt.scatter(np.real(z), np.imag(z), marker='o', facecolors='none', edgecolors='b', label='Zeros')
    plt.scatter(np.real(p), np.imag(p), marker='x', color='r', label='Poles')
    plt.title(title)
    plt.xlabel('Re')
    plt.ylabel('Im')
    plt.grid(True)
    plt.axhline(0, color='black', linewidth=0.5)
    plt.axvline(0, color='black', linewidth=0.5)
    # Cercle unité (utile pour stabilité filtre discret)
    theta = np.linspace(0, 2*np.pi, 400)
    plt.plot(np.cos(theta), np.sin(theta), 'k--', alpha=0.5)
    plt.axis('equal')
    plt.legend()
    

# Tracer les filtres
#plot_poles_zeros(z_low, p_low, "Pôles et zéros : filtre passe-bas")
plot_poles_zeros(z_band, p_band, "Pôles et zéros : filtre passe-bande")


##############################
## signaux filtrés
####################################


signal_filtre_f1 = signal.filtfilt(b_low, a_low, s)

signal_filtre_f2 = signal.filtfilt(b_band, a_band, s)

# Amplitude

plt.figure()
plt.plot(t,signal_filtre_f1)
plt.title("signal filtr2 f1")

plt.figure()
plt.plot(t,signal_filtre_f2)
plt.title("signal filtr2 f2")

plt.show()





