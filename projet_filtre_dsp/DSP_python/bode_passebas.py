

import numpy as np
import matplotlib.pyplot as plt




freq = np.array([1e3, 1.5e3, 2e3, 2.5e3, 3e3, 3.5e3, 4e3, 4.5e3, 4.7e3, 4.8e3, 4.9e3, 5e3, 5.5e3, 6e3, 6.5e3, 7e3, 7.5e3, 8e3, 8.5e3, 9e3, 9.5e3, 10e3, 11e3, 12e3, 13e3, 14e3, 15e3, 20e3, 30e3, 40e3])
gain = np.array([-10.4, -10.4, -10.3, -10.1, -9.9, -9.5, -8.9, -8.2, -7.9, -7.7, -7.5, -7.4, -6.4, -5.6, -4.4, -3.4, -2.3, -1.3, -0.4, 0.5, 1.4, 2.2, 3.8, 5.4, 6.8, 8, 9.4, 14.7, 21.3, 27])

gain_db = -gain - 10.5


plt.figure(figsize=(8, 5))

plt.semilogx(freq, gain_db, linewidth=2)

plt.xlabel("Fréquence (Hz)")
plt.ylabel("Amplitude (dB)")
plt.title("Diagramme de Bode passe bas fc=5kHz ")

plt.grid(True, which="both", linestyle="--")

plt.tight_layout()
plt.axvline(x=5e3, color='r', linestyle='--', linewidth=1)
plt.axhline(y=-3, color='g', linestyle='--', linewidth=1)

plt.legend(["fc = 5 kHz", "-3 dB"])

plt.axvline(x=5e3, color='r', linestyle='--', linewidth=1)
plt.axhline(y=-3, color='g', linestyle='--', linewidth=1)
plt.show()






