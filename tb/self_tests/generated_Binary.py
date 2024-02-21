import os
import sys

CODE = 'utf-8'

def filter_binary_text(input_file, output_file):
    with open(input_file, 'r', encoding=CODE) as infile:
        with open(output_file, 'w', encoding=CODE) as outfile:
            for line in infile:
                # 去除行尾换行符
                print(line)
                line = line.strip()
                binary_line = str('')
                for ch in line:
                    # 注释内容
                    if ch == "#":
                        break
                    if (ch == '0') or (ch == '1'):
                        binary_line += ch
                # 该行存在
                if binary_line:
                    outfile.write(binary_line + '\n')

arguments = sys.argv

if len(sys.argv) != 3:
    print("Usage: python generated_Binary.py <inputfile> <outputfile>")
    sys.exit(1)

input_file = sys.argv[1]
output_file = sys.argv[2]
filter_binary_text(input_file, output_file)
print(f"已从 '{input_file}' 中提取二进制内容并写入 '{output_file}'")
