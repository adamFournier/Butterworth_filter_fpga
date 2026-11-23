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



##############################
## extraction des poles
####################################


# z: zeros, p:poles, k:gain

z_low, p_low, k_low = signal.tf2zpk(b_low, a_low) # passe bas

print("poles passe bas : ", abs(p_low))


N=20

for n in range(1, N):

    print(n)
    trunc_a_low = np.trunc(a_low * 10**(N-n)) / 10**(N-n)
    trunc_b_low = np.trunc(b_low * 10**(N-n)) / 10**(N-n)

    z_low, p_low, k_low = signal.tf2zpk(trunc_b_low, trunc_a_low) # passe bas

    print("poles passe bas : ", abs(p_low) < 1, "n=",N-n)



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
plot_poles_zeros(z_low, p_low, "Pôles et zéros : filtre passe-bas")



##############################
## signaux filtrés
####################################


signal_filtre_f1 = signal.filtfilt(b_low, a_low, s)


# Amplitude

plt.figure()
plt.plot(t,signal_filtre_f1)
plt.title("signal filtr2 f1")



plt.show()





