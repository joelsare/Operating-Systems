#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <dirent.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <mqueue.h>
#include <stdatomic.h>
#include <sys/mman.h>
#include <pthread.h>


#define MAX_SIZE 8192
#define MSG_QUEUE_MAX 10
#define ERROR_CHECK(x) do { \
  if ((intptr_t)x == (intptr_t)-1) { \
    perror("myshell"); \
  } \
}while(0)

#define ERROR_CHECKO(x) do { \
  if ((intptr_t)x != (intptr_t)0) { \
    perror("myshell"); \
  } \
}while(0)

typedef struct {
int count;
int in;
int out;
char buffer[MSG_QUEUE_MAX][MAX_SIZE];
pthread_mutex_t mutex;
pthread_cond_t full;
pthread_cond_t empty;
} pc_buffer_t;

typedef struct {
  atomic_int num_shells;
  atomic_int num_increments;
  pc_buffer_t shared_buf;
} myshell_shared_data_t;

char name [] = "Joel";
char command [4097];
int echo = 0;
char buf[4097];
char hist [4096][4097];
int curCommand = 0;
char *words[2000];
int terminal = 0;
mqd_t mq;
char sharedBuffer[MSG_QUEUE_MAX][MAX_SIZE];
int count = 0;
myshell_shared_data_t *shared_data;
int shm_fd = 0;
int localVal = 0;
int lastPID = 0;

int pipefd[2];

void initalize() {
  int oflags = O_CREAT | O_RDWR;
  mode_t mode = S_IRWXU | S_IRWXG | S_IRWXO;
  struct mq_attr attr;
  attr.mq_maxmsg = 10;
  attr.mq_msgsize = MAX_SIZE;
  ERROR_CHECK(mq_open("/myshell_joelsare_mqueue", oflags, mode, &attr));
}

int split(char str[], char*words[]) {
  int i = 1;
  if ((words[0] = strtok(str, " \n\t"))==NULL) {
    return 0;
  }
  while ((words[i]=strtok(NULL, " \n\t"))!=NULL) {
    i++;
  }
  return i;
}

void removeAll(char directory[]) {
  DIR * dir;
  struct dirent * d;
  dir = opendir(directory);
  chdir(directory);

  if (dir) {
    while ((d = readdir(dir)) != NULL) {
      if (strcmp(d->d_name, ".") != 0 && strcmp(d->d_name, "..") != 0) {
        if (remove(d->d_name) !=0) {
          if (errno == ENOTEMPTY) {
            removeAll(d->d_name);
          }
        }
      }
    }
  }

  closedir(dir);
  chdir("..");
  rmdir(directory);
}

void listCurrent() {
  DIR * dir;
  struct dirent * d;

  if (getcwd(buf, sizeof(buf)) != NULL) {
    dir = opendir(buf);
    if (dir) {
      while ((d = readdir(dir)) != NULL) {
        printf("%s\n", d->d_name);
      }
      closedir(dir);
    }
  }
}

void myPrint(char word[]) {
  write(STDOUT_FILENO, word, strlen(word));
  write(STDOUT_FILENO, "\n", strlen(word));
}

void process_command(char command[]) {
  strcpy(hist[curCommand++], command);
  if (strcmp(command, "author") == 0) {
    printf("Name: %s\n", name);
  }
  else if (strstr(command, "hist") != NULL) {
    if (strcmp(command, "hist") == 0) {
      for (int i = 0; i < curCommand; i++) {
        printf("%s\n", hist[i]);
      }
    }
    else if (strcmp(command, "hist -c") == 0) {
      curCommand = 0;
    }
    else {
      fprintf(stderr, "usage: hist [-c]\n");
    }
  }
  else if (strstr(command, "cdir") != NULL) {
    if(strcmp(command, "cdir") == 0) {
      if (getcwd(buf, sizeof(buf)) != NULL) {
        printf("%s\n", buf);
      }
    }
    else {
      int numWords = split(command, words);
      if (numWords == 2) {
        if (chdir(words[1]) != 0) {
          if (errno == ENOTDIR) {
            perror("cdir");
          }
          else if (errno == ENOENT) {
            perror("cdir");
          }
        }
      }
      else {
        printf("usage: cdir [directory]\n");
      }
    }
  }
  else if (strstr(command, "create") != NULL) {
    int numWords = split(command, words);
    if (numWords == 2 && strcmp(words[1], "-d") != 0) {
      FILE * fp;
      if ((fp = fopen(words[1], "r"))) {
        fclose(fp);
        fprintf(stderr, "create: file exists\n");
      }
      else {
        fp = fopen(words[1], "w");
        fclose(fp);
      }
    }
    else if (numWords == 3 && strcmp(words[1], "-d") == 0) {
      DIR * dir;
      dir = opendir(words[2]);
      if (dir == NULL) { 
        mkdir(words[2], 0755);
      }
      else {
        fprintf(stderr, "create: file exists\n");
      }
      closedir(dir);
    }
    else {
      fprintf(stderr, "usage: create [-d] name\n");
    }
  }
  else if (strstr(command, "delete") != NULL) {
    int numWords = split(command, words);
    if (numWords == 2 && strcmp(words[1], "-r") != 0) {
      if (rmdir(words[1]) != 0) {
        if (errno == ENOTEMPTY) {
          fprintf(stderr, "delete: Directory not empty\n");
        }
        else if (errno == ENOTDIR) {
          remove(words[1]);
        }
      }
    }
    else if (numWords == 3 && strcmp(words[1], "-r") == 0) {
        if (rmdir(words[2]) != 0) {
          if (errno == ENOTEMPTY) {
            removeAll(words[2]);
          }
          else if (errno == ENOTDIR) {
            remove(words[2]);
          }
      }
    }
    else {
      fprintf(stderr, "usage: delete [-r] name\n");
    }
  }
  else if (strstr(command, "list") != NULL) {
    listCurrent();
  }
  else if (strstr(command, "myecho") != NULL) {
    int numWords = split(command, words);
    if (numWords <= 1) {
      fprintf(stderr, "usage: myecho string1 [... stringN]\n");
    }
    else {
      for (int i = 1; i < numWords; i++) {
        printf("%s ",words[i]);
      }
      printf("\n");
    }
  }
  else if (strstr(command, "redirect") != NULL) {
    int numWords = split(command, words);
    if (numWords == 3) {
      if (strcmp(words[1], "-") !=0) {
        freopen(words[1], "r", stdin);
      }
      freopen(words[2], "w", stdout);
    }
    else if (numWords == 2 && strcmp(words[1], "-") !=0) {
      freopen(words[1], "r", stdin);
    }
    else {
      fprintf(stderr, "usage: redirect input [output]\n");
    }
  }
  else if (strstr(command, "pid")) {
    int numWords = split(command, words);
    if (numWords == 1) {
      printf("%d\n",getpid());
    }
    else if (numWords == 2 && strcmp(words[1], "-p") == 0) {
      printf("%d\n", getppid());
    }
    else {
      fprintf(stderr, "usage: pid [-p]\n");
    }
  }
  else if (strcmp(command, "fork") == 0) {
    pid_t pid = fork();
    if (pid == -1) {
      //error
    }
    else if (pid == 0) {
      //child
    }
    else {
      //parent
      waitpid(pid, NULL, 0);
    }
  }
  else if (strstr(command, "exec") != NULL) {
    int numWords = split(command, words);
    if (numWords == 1) {
      fprintf(stderr, "usage: exec prog [arg1, arg2 ...]\n");
    }
    else {
      char * args[numWords-1];
      memcpy(args,words+1,sizeof(char*)*(numWords));
      args[numWords-1] = NULL;
      execvp(words[1], args);
    }
  }
  else if (strstr(command, "fg") != NULL) {
    int numWords = split(command, words);
    if (numWords == 1) {
      fprintf(stderr, "usage: fg prog [arg1, arg2 ...]\n");
    }
    else {
      pid_t pid = fork();
      if (pid == -1) { //error
      }
      else if (pid == 0) { //child
        char * args[numWords-1];
        memcpy(args,words+1,sizeof(char*)*(numWords));
        args[numWords-1] = NULL;
        execvp(words[1], args);
      }
      else { //parent
        waitpid(pid, NULL,0);
      }
    }
  }
  else if (strstr(command, "bg") != NULL) {
    int numWords = split(command, words);
    if (numWords == 1) {
      fprintf(stderr, "usage: bg prog [arg1, arg2 ...]\n");
    }
    else {
      pid_t pid = fork();
      if (pid == -1) { //error
      }
      else if (pid == 0) { //child
        char * args[numWords-1];
        memcpy(args,words+1,sizeof(char*)*(numWords));
        args[numWords-1] = NULL;
        execvp(words[1], args);
      }
      else { //parent
      }
    }
  }
  else if (strstr(command, "pipe")!=NULL) {
    int numWords = split(command, words);
    int mid =0;
    for (int i=0;i<numWords; i++) {
      if (strcmp(words[i], "|") == 0) {
        mid = i;
      }
    }

    pipe(pipefd);
    pid_t pid = fork();
    if (pid == -1) { //error
    }
    else if (pid == 0) { //child
      close(pipefd[0]);
      char * firstArgs[mid-1];
      memcpy(firstArgs,words+1,sizeof(char*)*(mid));
      firstArgs[mid-1] = NULL;

      dup2(pipefd[1], STDOUT_FILENO);
      execvp(words[1], firstArgs);
      close(pipefd[1]);
    }
    else { //parent
      wait(NULL);
      close(pipefd[1]);
      char * secondArgs[numWords-mid-1];
      memcpy(secondArgs,words+mid+1,sizeof(char*)*(numWords));
      secondArgs[numWords-mid-1] = NULL;  

      dup2(pipefd[0], STDIN_FILENO); 
      execvp(words[mid + 1], secondArgs);
      close(pipefd[0]);
    }
  }
  else if (strstr(command, "sendh") != NULL) {
    ERROR_CHECKO(pthread_mutex_lock(&shared_data->shared_buf.mutex));
    split(command, words);
      if (strlen(words[1]) >= MAX_SIZE) {
        fprintf(stderr, "send: message should contain no more than 8192 characters\n");
        return;
    }

    int loc = shared_data->shared_buf.in % 10;

    memcpy(shared_data->shared_buf.buffer[loc], words[1], MAX_SIZE);
    shared_data->shared_buf.in++;
    shared_data->shared_buf.count++;
    ERROR_CHECKO(pthread_mutex_unlock(&shared_data->shared_buf.mutex));
  }
  else if (strstr(command, "receiveh") != NULL) {
    ERROR_CHECKO(pthread_mutex_lock(&shared_data->shared_buf.mutex));
    printf("%s\n",shared_data->shared_buf.buffer[shared_data->shared_buf.out % 10]);
    shared_data->shared_buf.out++;
    shared_data->shared_buf.count--;
    ERROR_CHECKO(pthread_mutex_unlock(&shared_data->shared_buf.mutex));
  }
  else if (strstr(command, "send") != NULL) {
    int numWords = split(command, words);
    int prio = 0;
    if (numWords == 3) {
      prio = atoi(words[2]);
    }

    if (strlen(words[1]) >= MAX_SIZE) {
      fprintf(stderr, "send: message should contain no more than 8192 characters\n");
      return;
    }

    mq = mq_open("/myshell_joelsare_mqueue", O_WRONLY);
    int s = mq_send(mq, words[1], MAX_SIZE, prio);
    if (s < 0) {
      perror("error sending");
    }
    mq_close(mq);
  }
  else if (strstr(command, "receive") != NULL) {
    mq = mq_open("/myshell_joelsare_mqueue", O_RDONLY);
    char buffer[MAX_SIZE + 1];
    int s = mq_receive(mq, buffer, MAX_SIZE, NULL);
    if (s < 0) {
      perror("error sending");
    }

    printf("%s\n", buffer);
    mq_close(mq);
  }
  else if (strstr(command, "incr") != NULL) {
    int numWords = split(command, words);
    if (numWords != 2) {
      fprintf(stderr, "usage: incr N\n");
      return;
    }
    atomic_int value = atoi(words[1]);
    if (value <= 0) {
      fprintf(stderr, "usage: incr N where N is an integer strictly greater than 0\n");
      return;
    }
    int oflags = O_RDWR;
    int prot = PROT_READ | PROT_WRITE;
    size_t size = sizeof(myshell_shared_data_t);
    shm_fd = shm_open("myshell_joelsare_shm" , oflags , 0);
    ERROR_CHECK(shm_fd);
    shared_data = mmap(0, size, prot, MAP_SHARED, shm_fd, 0);
    ERROR_CHECK(shared_data);
    atomic_fetch_add(&shared_data->num_increments, value);
    localVal += value;

    printf("open shells: %u\n", shared_data->num_shells);
    printf("increment counter (local): %u\n", localVal);
    printf("increment counter address (local): %p\n", &localVal);
    printf("increment counter (global): %u\n", shared_data->num_increments);
    printf("increment counter address (global): %p\n", &shared_data->num_increments);
  }
  else {
    fprintf(stderr, "Unrecognized command: %s\n", command);
  }

  if (echo == 1 && terminal) {
    printf("%s\n", command);
  }
}

void print_prompt() {
  printf("@> ");
}

int get_command() {
  if (fgets(command, 4097, stdin) == NULL) {
    return 1;
  }
  if(!terminal) {
    if (strcmp(command, "exit") !=0 && strstr(command, "fg") == NULL) {
      printf("%s", command);
    }
  }
  return 0;
}

int main(int argc, char *argv[]) {
  if (argc > 1) {
      if (strcmp(argv[1], "--echo") == 0) {
        echo = 1;
      }
      else if(strcmp(argv[1], "--init") == 0) {
        if (argc != 3) {
          initalize(); 
        }

        //init shared memory
        int oflags = O_CREAT | O_RDWR;
        mode_t mode = S_IRWXU | S_IRWXG | S_IRWXO;
        int prot = PROT_READ | PROT_WRITE;
        size_t size = sizeof(myshell_shared_data_t);
        shm_fd = shm_open("myshell_joelsare_shm" , oflags , mode);
        ERROR_CHECK(shm_fd);
        ERROR_CHECK(ftruncate(shm_fd , sizeof(myshell_shared_data_t)));
        shared_data = mmap(0, size, prot, MAP_SHARED, shm_fd, 0);
        ERROR_CHECK(shared_data);

        //init locks
        pthread_mutexattr_t mtx_at;
        ERROR_CHECKO(pthread_mutexattr_init(&mtx_at));
        ERROR_CHECKO(pthread_mutexattr_setpshared(&mtx_at, PTHREAD_PROCESS_SHARED));
        ERROR_CHECKO(pthread_mutex_init(&shared_data->shared_buf.mutex, &mtx_at));

        pthread_condattr_t cnd_at;
        ERROR_CHECKO(pthread_condattr_init(&cnd_at));
        ERROR_CHECKO(pthread_condattr_setpshared(&cnd_at, PTHREAD_PROCESS_SHARED));
        ERROR_CHECKO(pthread_cond_init(&shared_data->shared_buf.full, &cnd_at));
        ERROR_CHECKO(pthread_cond_init(&shared_data->shared_buf.empty, &cnd_at));

        exit(0);
      }
      else if (strcmp(argv[1], "--destroy") == 0) {
        ERROR_CHECK(mq_unlink("/myshell_joelsare_mqueue"));

        ERROR_CHECK(shm_unlink("myshell_joelsare_shm"));

        exit(0);
      }
    }
  if (isatty(fileno(stdin))) {
    terminal = 1;
  }

  int oflags = O_RDWR;
  int prot = PROT_READ | PROT_WRITE;
  mode_t mode = S_IRWXU | S_IRWXG | S_IRWXO;
  int val = shm_open("myshell_joelsare_shm" , oflags , mode);
  if (val != -1) {
    size_t size = sizeof(myshell_shared_data_t);
    shm_fd = shm_open("myshell_joelsare_shm" , oflags , 0);
    ERROR_CHECK(shm_fd);
    shared_data = mmap(0, size, prot, MAP_SHARED, shm_fd, 0);
    ERROR_CHECK(shared_data);
    atomic_fetch_add(&shared_data->num_shells, 1);
  }

  while (1) {
    print_prompt();
    if (get_command() == 1) {
      if (shm_fd != 0) {
        atomic_fetch_add(&shared_data->num_shells, -1);
        if (shared_data->num_shells == 0) {
          atomic_fetch_add(&shared_data->num_increments, -1 * shared_data->num_increments);
        }
      }
      return 0;
    }
    if (strlen(command) > 4095) {
      printf("command too long\n");
      continue;
    }
    strtok(command, "\n");

    if (strcmp("exit", command) == 0) {
      printf("exit\n");
      if (shm_fd != 0) {
        atomic_fetch_add(&shared_data->num_shells, -1);
        if (shared_data->num_shells == 0) {
          atomic_fetch_add(&shared_data->num_increments, -1 * shared_data->num_increments);
        }
      }
      return 0;
    }
    process_command(command);
  }
  return 0;

}