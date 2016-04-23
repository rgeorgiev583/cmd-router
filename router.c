#define _XOPEN_SOURCE 500 /* Enable certain library functions (strdup) on linux.  See feature_test_macros(7) */

#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <libgen.h>

#include "ini.h"

#define HT_SIZE 1000
#define ARG_SIZE 1000

typedef struct state_t {
    int argc;
    char *name, **args, **argv;
} state_t;

int handle_conf(void* user, const char* section, const char* name, const char* value)
{
    state_t* state = user;

    if (!strcmp(section, "cmdproxy") && !strcmp(name, state->args[0]))
        state->name = strdup(value);
    else if (!strcmp(section, state->args[0]) && !strcmp(name, state->args[1]))
    {
        state->args[0] = state->name;
        char* arg_ws = strdup(value);
        char* arg = strtok(arg_ws, " ");
        size_t i = 1;

        do
            state->args[i++] = arg;
        while (arg = strtok(NULL, " "));

        for (int j = 2; j < state->argc; j++)
            state->args[i++] = state->argv[j];

        execvp(state->args[0], state->args);
    }

    return 1;
}

int main(int argc, char** argv)
{
    char* args[ARG_SIZE];
    args[0] = basename(argv[0]);
    args[1] = argv[1];

    state_t state = {
        .name = args[0],
        .args = args,
        .argc = argc,
        .argv = argv
    };

    ini_parse("/etc/cmdproxy.conf", handle_conf, &state);

    if (argv[0] != args[0])
        free(args[0]);
    if (argv[1] != args[1])
        free(args[1]);
}
