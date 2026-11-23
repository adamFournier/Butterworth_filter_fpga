

import numpy as np
import matplotlib.pyplot as plt




freq = np.array([5e3, 5.5e3, 6e3, 6.5e3, 7e3, 7.5e3, 8e3, 8.2e3, 8.4e3, 8.7e3, 9e3, 9.2e3, 9.4e3, 9.6e3, 9.8e3, 10e3, 10.2e3, 10.8e3, 11e3, 11.2e3, 11.4e3, 11.6e3, 12e3, 12.5e3, 13e3, 13.5e3, 14e3, 14.5e3, 15e3, 16e3, 17e3, 18e3])
gain = np.array([26, 22.5, 19.2, 15.2, 12.1, 8.1, 4.2, 1.4, -1.3, -4.3, -7.9, -9.2, -10.1, -10.3, -10.4, -10.4, -10.4, -8.8, -7, -5, -3.4, -2.1, 1, 4.5, 7, 9.6, 11.8, 13.7, 15.2, 18.5, 21, 23])

gain_db = -gain -10.4


plt.figure(figsize=(8, 5))

plt.semilogx(freq, gain_db, linewidth=2)

plt.xlabel("Fréquence (Hz)")
plt.ylabel("Amplitude (dB)")
plt.title("Diagramme de Bode passe bande fc1=9kHz fc2=11kHz")

plt.grid(True, which="both", linestyle="--")

plt.tight_layout()



plt.axvline(x=9e3, color='r', linestyle='--', linewidth=1, label="fc = 9 kHz")
plt.axvline(x=11e3, color='r', linestyle='--', linewidth=1, label="fc = 11 kHz")
plt.axhline(y=-3, color='g', linestyle='--', linewidth=1, label="-3 dB")

plt.legend()
plt.show()







