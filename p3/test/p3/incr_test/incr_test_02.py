#bin/python
import subprocess, pty, os, time
from subprocess import Popen, PIPE


s1 = ""
s2 = ""
s3 = ""

waiting_time = 0.05



pid_1,fd_1 = pty.fork()
if pid_1 == 0:
    subprocess.run('bin/myshell')
    exit(0)


s1 += os.read(fd_1, 10000).decode('utf-8')
os.write(fd_1, b"incr 1\n")
time.sleep(waiting_time)
s1 += os.read(fd_1, 10000).decode('utf-8')

pid_2,fd_2 = pty.fork()
if pid_2 == 0:
    subprocess.run('bin/myshell')
    exit(0)

s2 += os.read(fd_2, 10000).decode('utf-8')

os.write(fd_2, b"incr 1\n")
time.sleep(waiting_time)
s2 += os.read(fd_2, 10000).decode('utf-8')

os.write(fd_1, b"incr 1\n")
time.sleep(waiting_time)
s1 += os.read(fd_1, 10000).decode('utf-8')



pid_3,fd_3 = pty.fork()
if pid_3 == 0:
    subprocess.run('bin/myshell')
    exit(0)

s3 += os.read(fd_3, 10000).decode('utf-8')
os.write(fd_3, b"incr 1\n")
time.sleep(waiting_time)
s3 += os.read(fd_3, 10000).decode('utf-8')

os.write(fd_1, b"incr 1\n")
time.sleep(waiting_time)
s1 += os.read(fd_1, 10000).decode('utf-8')

time.sleep(waiting_time)
os.write(fd_1, b"exit\n")
os.write(fd_2, b"exit\n")
time.sleep(waiting_time)

os.write(fd_3, b"incr 1\n")
time.sleep(waiting_time)
s3 += os.read(fd_3, 10000).decode('utf-8')


f1 = open("test/output_01.txt", "w")
f2 = open("test/output_02.txt", "w")
f3 = open("test/output_03.txt", "w")
e1 = open("test/expected_output_01.txt", "w")
e2 = open("test/expected_output_02.txt", "w")
e3 = open("test/expected_output_03.txt", "w")
f1.write(s1)
f1.flush()
f1.close()
f2.write(s2)
f2.flush()
f2.close()
f3.write(s3)
f3.flush()
f3.close()

e1.write("""@> incr 1
open shells: 1
increment counter (local): 1
increment counter address (local): 0x55ef4d18e108
increment counter (global): 1
increment counter address (global): 0x7fc8ee281004
@> incr 1
open shells: 2
increment counter (local): 2
increment counter address (local): 0x55ef4d18e108
increment counter (global): 3
increment counter address (global): 0x7fc8ee281004
@> incr 1
open shells: 3
increment counter (local): 3
increment counter address (local): 0x55ef4d18e108
increment counter (global): 5
increment counter address (global): 0x7fc8ee281004""")

e2.write("""@> incr 1
open shells: 2
increment counter (local): 1
increment counter address (local): 0x55ef4d18e108
increment counter (global): 2
increment counter address (global): 0x7fc8ee281004""")

e3.write("""@> incr 1
open shells: 3
increment counter (local): 1
increment counter address (local): 0x55ef4d18e108
increment counter (global): 4
increment counter address (global): 0x7fc8ee281004
@> incr 1
open shells: 1
increment counter (local): 2
increment counter address (local): 0x55ef4d18e108
increment counter (global): 6
increment counter address (global): 0x7fc8ee281004""")