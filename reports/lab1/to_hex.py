
with open("sym_codes1.txt", encoding="utf-8") as file:
    file_values = [line.split(':') for line in file]

    bin_codes = tuple(
        str(hex(int('0b' + l[-1].rstrip().replace(' ', ''), 2))).lstrip('0x').rjust(5, '0') + 'h' for l in file_values)

    my_string = '0h,' * 5 + ','.join(bin_codes)
    print(f"text dw {my_string}; строчка ('АЛЕКСЕИ ХАЛЕЕВ 21-ВМЗ-4')\nconst len {5 + len(bin_codes)};Длина строки")
