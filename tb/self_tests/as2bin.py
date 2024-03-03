import re
import sys

CODE = 'utf-8'

def extract_machine_code(disassembly_file):
    machine_codes = []
    with open(disassembly_file, 'r') as f:
        with open(output_file, 'w', encoding=CODE) as outfile:
            for line in f:
                # 使用正则表达式匹配机器码
                match = re.match(r'\s*[0-9a-f]+:\s+([0-9a-f]+)', line)
                if match:
                    machine_code = match.group(1)
                    binary_string = bin(int(machine_code, 16))[2:].zfill(32)
                    machine_codes.append(binary_string)
                    outfile.write(binary_string + '\n')
                    

    return machine_codes

# 命令行参数
input_file = sys.argv[1]
output_file = sys.argv[2]

if len(sys.argv) != 3:
    print("Usage: python generated_Binary.py <inputfile-.o> <outputfile-.lst>")
    sys.exit(1)

codes = extract_machine_code(input_file)

# 打印提取的机器码
for code in codes:
    print(code)
