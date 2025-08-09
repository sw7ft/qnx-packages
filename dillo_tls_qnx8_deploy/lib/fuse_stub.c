#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fuse.h>

/* FUSE function stubs */
int fuse_main_real(int argc, char *argv[], const struct fuse_operations *op, size_t op_size, void *user_data) {
    printf("FUSE main called - not implemented\n");
    return -1;
}

int fuse_is_lib_option(const char *opt) {
    return 0;
}

int fuse_version(void) {
    return 26;
}

int fuse_parse_cmdline(struct fuse_args *args, char **mountpoint, int *multithreaded, int *foreground) {
    *mountpoint = strdup("/tmp/sshfs_mount");
    *multithreaded = 0;
    *foreground = 1;
    return 0;
}

struct fuse_chan *fuse_mount(const char *mountpoint, struct fuse_args *args) {
    printf("FUSE mount called for: %s\n", mountpoint);
    return (struct fuse_chan *)1; // dummy pointer
}

int fuse_chan_fd(struct fuse_chan *ch) {
    return 0;
}

struct fuse *fuse_new(struct fuse_chan *ch, struct fuse_args *args, const struct fuse_operations *op, size_t op_size, void *user_data) {
    printf("FUSE new called\n");
    return (struct fuse *)1; // dummy pointer
}

void fuse_unmount(const char *mountpoint, struct fuse_chan *ch) {
    printf("FUSE unmount called for: %s\n", mountpoint);
}

struct fuse_session *fuse_get_session(struct fuse *f) {
    return (struct fuse_session *)1; // dummy pointer
}

int fuse_set_signal_handlers(struct fuse_session *se) {
    return 0;
}

void fuse_destroy(struct fuse *f) {
    printf("FUSE destroy called\n");
}

int fuse_daemonize(int foreground) {
    if (!foreground) {
        return daemon(0, 0);
    }
    return 0;
}

int fuse_loop_mt(struct fuse *f) {
    printf("FUSE loop_mt called - not implemented\n");
    return -1;
}

int fuse_loop(struct fuse *f) {
    printf("FUSE loop called - not implemented\n");
    return -1;
}

void fuse_remove_signal_handlers(struct fuse_session *se) {
    printf("FUSE remove signal handlers called\n");
}
