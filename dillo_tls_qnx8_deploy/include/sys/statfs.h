#ifndef _SYS_STATFS_H
#define _SYS_STATFS_H

#include <sys/statvfs.h>

/* QNX compatibility for statfs */
#define statfs statvfs
#define f_type f_fsid
#define f_bsize f_bsize
#define f_blocks f_blocks
#define f_bfree f_bfree
#define f_bavail f_bavail
#define f_files f_files
#define f_ffree f_ffree

#endif
