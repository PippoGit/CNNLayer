import numpy as np

# constants
NUM_BIT_INTEGER = 8
CLOCK_PERIOD    = '8 ns'
RESET_TIME      = '12 ns'


# script to generate a testbench given a Cin Matrix and a Flt Matrix
def generate_testbench(cin, flt):
    mem_size       = (cin.shape(1) - flt.shape(1) + 1) * (cin.shape(2) - flt.shape(2) +1)
    mem_address    = ceil(log(2, flt.size))
    cnn_output_bit = NUM_BIT_INTEGER*2 + ceil(log(2, flt.size))

    return



def main():
    cin = np.array([
        [1, 2, 3, 4, 5],
        [1, 2, 3, 4, 5],
        [1, 2, 3, 4, 5],
        [1, 2, 3, 4, 5],
        [1, 2, 3, 4, 5]
    ])

    flt = np.array([
        [1, 2, 3],
        [1, 2, 3],
        [1, 2, 3]
    ])
    
    generate_testbench(cin, flt)

if __name__ == '__main__':
    main()
