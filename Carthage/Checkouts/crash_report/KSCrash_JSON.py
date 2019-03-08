#! /usr/bin/env python3
import os
import sys
import json

def main() :
    #Get Var 
    input_crash = sys.argv[1]
    input_dSYM = sys.argv[2]
    output_crash = sys.argv[3]

    # Check Var
    input_vaild = True

    crash = input_crash.replace('\\','')
    while (os.path.splitext(crash)[1] != '.json') :
        input_vaild = False

    dSYM = input_dSYM.replace('\\', '')
    while (os.path.splitext(dSYM)[1] != '.dSYM') :
        input_vaild = False

    if not input_vaild:
        print("Input Var Not Crorrect")
        print("Use Script Like: python3 KSCrash_JSON.py input_crash.json input_app.dSYM output")
        return

    report = output_crash.replace('\\','')

    if os.path.exists(report):
        print('Output File exists. You want to rewrite it? Y or N')
        is_rewrite = sys.stdin.readline()[:-1].strip()
        if not is_rewrite == 'Y' :
            return
        os.remove(report) 

    # Crash Read Operation
    with open(crash) as f:
        crash_data = json.load(f)

    crash_uuid = crash_data["system"]["app_uuid"]
    
    # dSYM File Process
    dSYM = input_dSYM.replace('\\', '')
    name_right = dSYM.find('.app')
    app_name = dSYM[:name_right]
    for uuid_line in os.popen('dwarfdump --uuid ' + dSYM).readlines():
        print(uuid_line)
        left_position = uuid_line.find('(')
        right_position = uuid_line.find(')')
        dSYM_arch = uuid_line[left_position + 1:right_position]
        if left_position > 6:
            dSYM_uuid = uuid_line[6:left_position]
            break
    
    # Check UUID
    dSYM_uuid = dSYM_uuid.replace(' ','')
    if not dSYM_uuid==crash_uuid:
        print('UUID Not Equal')
        return

    crash_threads = crash_data["crash"]["threads"]

    # atos process
    command_base = 'xcrun atos -arch ' + dSYM_arch + ' -o ' + dSYM + '/Contents/Resources/DWARF/' + app_name + ' -l '

    for thread in crash_threads:
        index = 'thread ' + str(thread['index']) + ' \n \n'
        with open(report, 'a') as report_file:
            report_file.write(index)
        
        for instruction in thread['backtrace']['contents']:
            object_addr = hex(instruction['object_addr'])
            symbol_addr = hex(instruction['symbol_addr'])

            command = command_base + ' ' + object_addr + ' ' + symbol_addr
            output = os.popen(command).read()
            with open(report, 'a') as report_file:
                report_file.write(output)

        with open(report, 'a') as report_file:
            report_file.write('\n \n')
    return

if __name__ == '__main__' : main()
