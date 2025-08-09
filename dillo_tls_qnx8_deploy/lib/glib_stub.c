#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "/accounts/1000/shared/misc/include/glib.h"

/* String functions */
char* g_strdup_printf(const char* format, ...) {
    va_list args;
    va_start(args, format);
    int len = vsnprintf(NULL, 0, format, args);
    va_end(args);
    
    char* result = malloc(len + 1);
    va_start(args, format);
    vsnprintf(result, len + 1, format, args);
    va_end(args);
    return result;
}

char* g_strndup(const char* str, size_t n) {
    size_t len = strlen(str);
    if (len > n) len = n;
    char* result = malloc(len + 1);
    memcpy(result, str, len);
    result[len] = '\0';
    return result;
}

void g_strfreev(char** str_array) {
    if (!str_array) return;
    for (int i = 0; str_array[i]; i++) {
        free(str_array[i]);
    }
    free(str_array);
}

/* Hash table functions - simple implementation */
GHashTable* g_hash_table_new(GHashFunc hash_func, GEqualFunc key_equal_func) {
    GHashTable* ht = malloc(sizeof(GHashTable));
    ht->capacity = 16;
    ht->size = 0;
    ht->keys = calloc(ht->capacity, sizeof(void*));
    ht->values = calloc(ht->capacity, sizeof(void*));
    return ht;
}

GHashTable* g_hash_table_new_full(GHashFunc hash_func, GEqualFunc key_equal_func, void* key_destroy_func, void* value_destroy_func) {
    return g_hash_table_new(hash_func, key_equal_func);
}

void* g_hash_table_lookup(GHashTable* hash_table, const void* key) {
    for (int i = 0; i < hash_table->size; i++) {
        if (hash_table->keys[i] && strcmp((char*)hash_table->keys[i], (char*)key) == 0) {
            return hash_table->values[i];
        }
    }
    return NULL;
}

int g_hash_table_insert(GHashTable* hash_table, void* key, void* value) {
    if (hash_table->size >= hash_table->capacity) return 0;
    hash_table->keys[hash_table->size] = key;
    hash_table->values[hash_table->size] = value;
    hash_table->size++;
    return 1;
}

int g_hash_table_remove(GHashTable* hash_table, const void* key) {
    for (int i = 0; i < hash_table->size; i++) {
        if (hash_table->keys[i] && strcmp((char*)hash_table->keys[i], (char*)key) == 0) {
            hash_table->keys[i] = NULL;
            hash_table->values[i] = NULL;
            return 1;
        }
    }
    return 0;
}

int g_hash_table_size(GHashTable* hash_table) {
    return hash_table->size;
}

int g_hash_table_foreach_remove(GHashTable* hash_table, GHRFunc func, void* user_data) {
    int removed = 0;
    for (int i = 0; i < hash_table->size; i++) {
        if (hash_table->keys[i] && func(hash_table->keys[i], hash_table->values[i], user_data)) {
            hash_table->keys[i] = NULL;
            hash_table->values[i] = NULL;
            removed++;
        }
    }
    return removed;
}

/* Array functions */
GPtrArray* g_ptr_array_new(void) {
    GPtrArray* array = malloc(sizeof(GPtrArray));
    array->capacity = 16;
    array->len = 0;
    array->pdata = malloc(array->capacity * sizeof(void*));
    return array;
}

void g_ptr_array_add(GPtrArray* array, void* data) {
    if (array->len >= array->capacity) {
        array->capacity *= 2;
        array->pdata = realloc(array->pdata, array->capacity * sizeof(void*));
    }
    array->pdata[array->len++] = data;
}

void g_ptr_array_free(GPtrArray* array, int free_seg) {
    if (free_seg) {
        for (int i = 0; i < array->len; i++) {
            free(array->pdata[i]);
        }
    }
    free(array->pdata);
    free(array);
}

/* List functions */
GList* g_list_append(GList* list, void* data) {
    GList* new_node = malloc(sizeof(GList));
    new_node->data = data;
    new_node->next = NULL;
    new_node->prev = NULL;
    
    if (!list) return new_node;
    
    GList* last = list;
    while (last->next) last = last->next;
    last->next = new_node;
    new_node->prev = last;
    return list;
}

GList* g_list_first(GList* list) {
    if (!list) return NULL;
    while (list->prev) list = list->prev;
    return list;
}

GList* g_list_delete_link(GList* list, GList* link) {
    if (!link) return list;
    
    if (link->prev) link->prev->next = link->next;
    if (link->next) link->next->prev = link->prev;
    
    GList* new_list = list;
    if (list == link) {
        new_list = link->next;
    }
    
    free(link);
    return new_list;
}

/* Utility functions */
unsigned int g_str_hash(const void* v) {
    const char* str = (const char*)v;
    unsigned int hash = 5381;
    int c;
    while ((c = *str++)) {
        hash = ((hash << 5) + hash) + c;
    }
    return hash;
}

int g_str_equal(const void* v1, const void* v2) {
    return strcmp((const char*)v1, (const char*)v2) == 0;
}

/* Additional missing functions */
int g_hash_table_lookup_extended(GHashTable* hash_table, const void* lookup_key, void** orig_key, void** value) {
    for (int i = 0; i < hash_table->size; i++) {
        if (hash_table->keys[i] && strcmp((char*)hash_table->keys[i], (char*)lookup_key) == 0) {
            if (orig_key) *orig_key = hash_table->keys[i];
            if (value) *value = hash_table->values[i];
            return 1;
        }
    }
    return 0;
}
