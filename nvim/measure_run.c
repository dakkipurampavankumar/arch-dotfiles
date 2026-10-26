/*
 * measure_run - bare metal execution profiler
 * Usage: measure_run <command> [args...]
 *
 * Measures wall-clock time (nanosecond precision) and peak RSS
 * via fork/exec + wait4. Forwards the child's exit code.
 */
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/resource.h>
#include <time.h>

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: measure_run <command> [args...]\n");
        return 1;
    }

    struct timespec t0, t1;
    clock_gettime(CLOCK_MONOTONIC, &t0);

    pid_t pid = fork();
    if (pid < 0) {
        perror("fork");
        return 1;
    }

    if (pid == 0) {
        /* child — become the target program */
        execvp(argv[1], &argv[1]);
        perror(argv[1]);
        _exit(127);
    }

    /* parent — wait and collect stats */
    int status;
    struct rusage ru;
    wait4(pid, &status, 0, &ru);
    clock_gettime(CLOCK_MONOTONIC, &t1);

    double ms = (t1.tv_sec - t0.tv_sec) * 1000.0
              + (t1.tv_nsec - t0.tv_nsec) / 1e6;
    long peak_kb = ru.ru_maxrss;  /* KB on Linux */

    fprintf(stderr,
        "\n\033[90m══════════════════════════════\033[0m\n"
        "\033[33m⏱  Time  : \033[1;37m%.2f ms\033[0m\n"
        "\033[36m💾 Memory : \033[1;37m%.2f MB\033[0m (peak RSS)\n"
        "\033[90m══════════════════════════════\033[0m\n",
        ms, peak_kb / 1024.0);

    /* forward child's exit code */
    if (WIFEXITED(status))
        return WEXITSTATUS(status);
    return 1;
}
