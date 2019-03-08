#coding=utf-8

import sqlite3
import time
import datetime
import sys
reload(sys)
sys.setdefaultencoding("utf-8")

def timestamp_string(timestamp):
    miliSeconds = timestamp - int(timestamp)
    #print "seconds:" + str(timestamp) + " to mili seconds: " + str(miliSeconds)
    timeObj = time.localtime(timestamp)
    dateStr = time.strftime("%Y%m%d %H:%M:%S", timeObj)
    dateStr = dateStr + ".%3d " % (miliSeconds * 1000)
    dateStr = dateStr + time.strftime("%z", timeObj)
    return dateStr

def level_string(level):
    if level == 0:
        return "[VERBOSE]"
    if level == 1:
        return "[INFO]"
    if level == 2:
        return "[DEBUG]"
    if level == 3:
        return "[WARNING]"
    if level == 4:
        return "[ERROR]"
    if level == 5:
        return "[FATAL]"
    return "[UNKNOWN]"

def tag_string(tag):
    return tag.ljust(10) + ", "


def process(input, output):
    connection = sqlite3.connect(input)
    cursor = connection.cursor()
    
    sql = "select * from log_item"
    print "sql is: " + sql
    cursor.execute(sql)

    items = cursor.fetchall()

    f = open(output, "w")
    
    for item in items:
        ID = item[0]
        date = item[1]
        level = item[2]
        tag = item[3]
        trace = item[4]
        content = item[5]

        log = ""
        log += str(ID) + ", "
        log += timestamp_string(float(date) * 0.001) + ", "
        log += level_string(level) + ", " + "\t"
        log += tag_string(tag)
        log += trace + ", " + "\t"
        log += content + "\n"

        f.write(log)

    cursor.close()
    f.close()


if __name__ == '__main__':

    if len(sys.argv) < 2:
        print "Please use: python anylysis_sqlite.py <input file path> <output file path>"
        abort()


    input_file = sys.argv[1]
    output_file = sys.argv[2]

    process(input_file, output_file)







