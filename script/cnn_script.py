import numpy as np
from datetime import datetime
import math 
import time


# constants
NUM_BIT_INTEGER = 8
MAX_NUMBER      = 2**(NUM_BIT_INTEGER-1) - 1 
CLOCK_PERIOD    = '8 ns'
RESET_TIME      = '12 ns'


def vhdl_matrix_literal(matrix):
    vhdl_mat = '('
    for i in range(0, matrix.shape[0]):
        vhdl_mat += '(' + ', '.join([('"' + np.binary_repr(val, NUM_BIT_INTEGER) + '"') for val in matrix[i]]) + ')' + (', ' if i < matrix.shape[0]-1 else '')
    vhdl_mat += ')'
    return vhdl_mat


def commented_matrix_hex(matrix, numbit):
    result = ''
    for i in range(0, matrix.shape[0]):
        result += '--     ' + '    '.join([str(hex(int(val))) for val in matrix[i]]) +  '\n'
    return result

def commented_matrix(matrix):
    result = ''
    for i in range(0, matrix.shape[0]):
        result += '--     ' + '    '.join([(str(int(val))) for val in matrix[i]]) +  '\n'
    return result


def conv(cin, flt):
    hs = cin.shape[1] - flt.shape[1] + 1
    vs = cin.shape[0] - flt.shape[0] + 1
    result = np.zeros((vs, hs))

    for i in range(vs):
        for j in range(hs):
            result[i][j] = (flt.flatten()*cin[i:i+flt.shape[0], j:j+flt.shape[1]].flatten()).sum()

    return result            


def zip_parameters(cin, flt, addr_len, output_bit, start_simulation_time, end_simulation_time, simulation_cases):
    param = {
        'id'                    : str(int(round(time.time() * 1000)))[-6:],
        'clock_period'          : CLOCK_PERIOD,
        'reset_time'            : RESET_TIME,
        'input_width'           : str(cin.shape[1]),
        'input_height'          : str(cin.shape[0]),
        'filter_width'          : str(flt.shape[1]),
        'filter_height'         : str(flt.shape[0]),
        'address_length'        : str(addr_len),
        'start_simulation_time' : str(start_simulation_time),
        'end_simulation_time'   : str(end_simulation_time),
        'simulation_cases'      : simulation_cases,
        'cin_matrix'            : vhdl_matrix_literal(cin),
        'flt_matrix'            : vhdl_matrix_literal(flt),
        'cnn_output_bit'        : str(output_bit),
        'cin_matrix_numeric'    : commented_matrix(cin),
        'flt_matrix_numeric'    : commented_matrix(flt),
        'res_matrix_numeric'    : commented_matrix_hex(conv(cin, flt), output_bit),
        'res_dec_matrix_numeric': commented_matrix(conv(cin, flt))
    }
    return param


# script to generate a testbench given a Cin Matrix and a Flt Matrix
def generate_testbench(cin, flt):
    mem_size       = (cin.shape[0] - flt.shape[0] + 1) * (cin.shape[1] - flt.shape[1] + 1)
    mem_address    = math.ceil(math.log(mem_size, 2))
    cnn_output_bit = NUM_BIT_INTEGER*2 + math.ceil(math.log(flt.size, 2))

    start_sim_time = mem_size + 5  # safe margin 5 should be enough
    end_sim_time   = start_sim_time + mem_size + 10 # safe margin 10 should be enough

    cases = ''
    for case in range(1, mem_size):
        cases += '        when ' + str(case + start_sim_time) + ' => mem_rd_addr_s <= ' + '"' + np.binary_repr(case, mem_address) + '"' + ';\n'

    with open('template.vhd', 'r') as template_file:
        template = template_file.read()

    param = zip_parameters(cin, flt, mem_address, cnn_output_bit, start_sim_time, end_sim_time, cases)
    for k, v in param.items():
        template = template.replace('{' + k +'}', v)

    with open('testbench_' + str(cin.size) + 'x' + str(flt.size) + '_' + datetime.now().strftime("%m%d%Y-%H%M%S") + '.vhd', 'w') as output:
        output.write(template)
    return


def generate_random_testbench(cin_shape, flt_shape):
    generate_testbench(cin=np.random.randint(MAX_NUMBER+1, size=cin_shape),
                       flt=np.random.randint(MAX_NUMBER+1, size=flt_shape))
    return


def main():
    cin = np.array([
        [1, 1, 1, 0, 0],
        [0, 1, 1, 1, 0],
        [0, 0, 1, 1, 1],
        [0, 0, 1, 1, 0],
        [0, 1, 1, 0, 0]
    ])

    flt = np.array([
        [1, 0, 1],
        [0, 1, 0],
        [1, 0, 1]
    ])
    generate_testbench(cin, flt)
    generate_random_testbench((20, 10), (2, 3))
    return


if __name__ == '__main__':
    main()
