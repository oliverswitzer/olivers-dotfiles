// t7run: tiny launcher that LaunchAgents start so macOS (TCC) has ONE stable,
// signed binary to grant Full Disk Access to. Child processes it spawns are
// attributed to t7run, so they can read/write the external T7 volume.
//
// Usage: t7run <program> [args...]
// It spawns (not execs) the child so t7run stays the "responsible process",
// forwards SIGTERM/SIGINT/SIGHUP, and exits with the child's status.
#include <spawn.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <sys/wait.h>

extern char **environ;
static volatile pid_t child = 0;

static void forward(int sig) { if (child > 0) kill(child, sig); }

int main(int argc, char *argv[]) {
    if (argc < 2) { fprintf(stderr, "usage: t7run <program> [args...]\n"); return 64; }
    signal(SIGTERM, forward); signal(SIGINT, forward); signal(SIGHUP, forward);
    pid_t pid;
    int rc = posix_spawnp(&pid, argv[1], NULL, NULL, &argv[1], environ);
    if (rc != 0) { fprintf(stderr, "t7run: spawn %s failed: %s\n", argv[1], strerror(rc)); return 126; }
    child = pid;
    int status;
    while (waitpid(pid, &status, 0) < 0) { if (errno != EINTR) { perror("t7run: waitpid"); return 1; } }
    if (WIFEXITED(status)) return WEXITSTATUS(status);
    if (WIFSIGNALED(status)) return 128 + WTERMSIG(status);
    return 1;
}
