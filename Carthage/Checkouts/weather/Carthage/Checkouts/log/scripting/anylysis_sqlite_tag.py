#coding=utf-8

import sqlite3
import time
import datetime
import sys
reload(sys)
sys.setdefaultencoding("utf-8")


def get_time_str(timestamp):
    miliSeconds = timestamp - int(timestamp)
    #print "seconds:" + str(timestamp) + " to mili seconds: " + str(miliSeconds)
    timeObj = time.localtime(timestamp)
    dateStr = time.strftime("%Y%m%d %H:%M:%S", timeObj)
    dateStr = dateStr + ".%3d " % (miliSeconds * 1000)
    dateStr = dateStr + time.strftime("%z", timeObj)
    return dateStr

def main(input, out, tag):
    con = sqlite3.connect(input)
    cursor = con.cursor()
    sql = "select * from log_item where TAG =='" + str(tag) + "'"
    print sql
    cursor.execute(sql)
    values = cursor.fetchall()

    f=open(out, "w")
    for line in values:
        date = line[1]
        if isinstance(line[1], int):
            date = get_time_str(float(line[1]) * 0.001)
        f.write(str(line[0])+ "， " +date+ "， " +str(line[2])+ "， " +str(line[3])+ "， " +str(line[4])+ "， " +str(line[5]))
        f.write('\n')#显示写入换行
    cursor.close()
    f.close()

if __name__ == '__main__':

    if len(sys.argv) >= 3:
        input_file = sys.argv[1]
        out_file = sys.argv[2]
        tag = sys.argv[3]

    print "=============输入文件路径================", input_file
    print "=============输出文件路径================", out_file
    print "=============tag================", tag 

    main(input_file, out_file, tag)
