#ifndef _GLIB_H_
#define _GLIB_H_

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

typedef void* gpointer;
typedef char gchar;
typedef int gint;
typedef unsigned int guint;
typedef int gboolean;

#define TRUE 1
#define FALSE 0

/* Simple hash table implementation */
typedef struct {
    void **keys;
    void **values;
    int size;
    int capacity;
} GHashTable;

/* Simple pointer array */
typedef struct {
    void **pdata;
    int len;
    int capacity;
} GPtrArray;

/* Simple linked list */
typedef struct _GList {
    void *data;
    struct _GList *next;
    struct _GList *prev;
} GList;

/* Function type definitions */
typedef int (*GHRFunc)(void*, void*, void*);
typedef unsigned int (*GHashFunc)(const void*);
typedef int (*GEqualFunc)(const void*, const void*);

/* Memory functions */
#define g_malloc malloc
#define g_free free
#define g_strdup strdup
#define g_new(type, count) ((type*)malloc(sizeof(type) * (count)))
#define g_new0(type, count) ((type*)calloc((count), sizeof(type)))

/* String functions */
char* g_strdup_printf(const char* format, ...);
char* g_strndup(const char* str, size_t n);
void g_strfreev(char** str_array);

/* Hash table functions */
GHashTable* g_hash_table_new(GHashFunc hash_func, GEqualFunc key_equal_func);
GHashTable* g_hash_table_new_full(GHashFunc hash_func, GEqualFunc key_equal_func, void* key_destroy_func, void* value_destroy_func);
void* g_hash_table_lookup(GHashTable* hash_table, const void* key);
int g_hash_table_insert(GHashTable* hash_table, void* key, void* value);
int g_hash_table_remove(GHashTable* hash_table, const void* key);
int g_hash_table_size(GHashTable* hash_table);
int g_hash_table_foreach_remove(GHashTable* hash_table, GHRFunc func, void* user_data);

/* Array functions */
GPtrArray* g_ptr_array_new(void);
void g_ptr_array_add(GPtrArray* array, void* data);
void g_ptr_array_free(GPtrArray* array, int free_seg);

/* List functions */
GList* g_list_append(GList* list, void* data);
GList* g_list_first(GList* list);
GList* g_list_delete_link(GList* list, GList* link);

/* Utility functions */
unsigned int g_str_hash(const void* v);
int g_str_equal(const void* v1, const void* v2);

/* Pointer conversion */
#define GUINT_TO_POINTER(u) ((void*)(unsigned long)(u))
#define MIN(a,b) ((a)<(b)?(a):(b))

#endif

/* Additional missing functions */
int g_hash_table_lookup_extended(GHashTable* hash_table, const void* lookup_key, void** orig_key, void** value);
#define GPOINTER_TO_UINT(p) ((unsigned int)(unsigned long)(p))

