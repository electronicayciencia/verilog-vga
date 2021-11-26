#!/usr/env/python3

# Calculate the Gowin rPLL settings to get desired frequency.

# clock input in MHz
CLKIN = 24

CLKINDIV_UPPER_FREQ = 400
CLKINDIV_LOWER_FREQ = 3

CLKOUT_UPPER_FREQ = 450
CLKOUT_LOWER_FREQ = 3.125


CLKINDIV_VALUES = range(1, 64)
CLKFBDIV_VALUES = range(1, 64)
CLKOUTDIV_VALUES = range(2, 128)

possible_freqs = {}


for clkindiv in CLKINDIV_VALUES:
    clk = CLKIN / clkindiv
    
    if not (CLKINDIV_LOWER_FREQ <= clk <= CLKINDIV_UPPER_FREQ):
        continue

    for clkfbdiv in CLKFBDIV_VALUES:
        clkout = clk * clkfbdiv

        if not (CLKOUT_LOWER_FREQ <= clkout <= CLKOUT_UPPER_FREQ):
            continue

        if round(clkout,3) not in possible_freqs:
            possible_freqs[round(clkout,3)] = []
        
        possible_freqs[round(clkout,3)].append([clkindiv,clkfbdiv,'-'])

        for clkoutdiv in CLKOUTDIV_VALUES:
            clkoutd = clkout / clkoutdiv

            if round(clkoutd,3) not in possible_freqs:
                possible_freqs[round(clkoutd,3)] = []
            
            possible_freqs[round(clkoutd,3)].append([clkindiv,clkfbdiv,clkoutdiv])



for key, value in sorted(possible_freqs.items(), key=lambda x: x[0]): 
    print("{} : {}".format(key, value))

