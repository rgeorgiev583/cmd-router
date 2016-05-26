#define _XOPEN_SOURCE 500 /* Enable certain library functions (strdup) on linux.  See feature_test_macros(7) */

#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <libgen.h>

#include "ini.h"

#define ARG_SIZE 1000

typedef struct state_t {
    int argc;
    char *argstr, **args, **argv;
} state_t;

int handle_cmd(void* user, const char* section, const char* name, const char* value)
{
    state_t* state = user;

    if (!strcmp(name, state->args[1]))
    {
        state->args[0] = strdup(section);
        state->argstr = strdup(value);
        char* arg = strtok(state->argstr, " ");
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

int main(int argc, char* argv[])
{
    char* args[ARG_SIZE];
    args[0] = basename(argv[0]);
    args[1] = argv[1];

    state_t state = {
        .argstr = NULL,
        .args = args,
        .argc = argc,
        .argv = argv
    };

    char* cmd_filename = malloc(strlen(args[0]) + 23);
    sprintf(cmd_filename, "/etc/cmdproxy/%s.command", args[0]);
    ini_parse(cmd_filename, handle_cmd, &state);
    free(cmd_filename);

    if (state.argstr)
        free(state.argstr);
    if (argv[0] != args[0])
        free(args[0]);
    if (argv[1] != args[1])
        free(args[1]);
}
