import numpy as np

L = 64  # define table length
dt = 2 * np.pi / L
t = np.arange(0, L) * dt

sine_table = np.sin(t)

# convert sine table to fixed-point representation with signed values, 16 bits, with maximum value of 1 and minimum value of -1
sine_table_Q14 = np.round(sine_table * 2 ** 14).astype(int)

table_string = ", ".join(sine_table_Q14.astype(str))

# display sine table
print(table_string)
