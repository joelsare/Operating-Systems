#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <dirent.h>
#include <sys/stat.h>

char name [] = "Joel";
char command [4097];
int echo = 0;
char buf[4097];
char hist [4096][4097];
int curCommand = 0;
char *words[2000];
int terminal = 0;

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
    if (strcmp(command, "exit") !=0) {
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
    }
  if (isatty(fileno(stdin))) {
    terminal = 1;
  }

  while (1) {
    print_prompt();
    if (get_command() == 1) {
      return 0;
    }
    if (strlen(command) > 4095) {
      printf("command too long\n");
      continue;
    }
    strtok(command, "\n");

    if (strcmp("exit", command) == 0) {
      printf("exit\n");
      return 0;
    }

    process_command(command);
  }
  return 0;
}