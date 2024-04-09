#define _DEFAULT_SOURCE

#include <errno.h>
#include <getopt.h>
#include <signal.h>
#include <stddef.h> // for size_t
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>

#define RED "#FF7373"
#define ORANGE "#FFA500"
#define PATH_LEN 256

typedef unsigned long ulong;
typedef unsigned int uint;

typedef struct {
    // Values from /proc/meminfo, in KiB
    long long MemTotalKiB;
    long long MemAvailableKiB;
    long long SwapTotalKiB;
    long long SwapFreeKiB;
    long long AnonPagesKiB;
    // Calculated values
    // UserMemTotalKiB = MemAvailableKiB + AnonPagesKiB.
    // Represents the total amount of memory that may be used by user processes.
    long long UserMemTotalKiB;
    // Calculated percentages
    double MemAvailablePercent; // percent of total memory that is available
    double SwapFreePercent; // percent of total swap that is free
} meminfo_t;


typedef struct {
  char bytes[4];
  int size;
} utf8_char;


#define BYTE_ONE 0x80   // 10000000
#define BYTE_TWO 0xC0   // 11000000
#define BYTE_THREE 0xE0 // 11100000
#define BYTE_FOUR 0xF0  // 11110000
#define BYTE_FIVE 0xF8  // 11111000

/* Parse the contents of /proc/meminfo (in buf), return value of "name"
 * (example: "MemTotal:")
 * Returns -errno if the entry cannot be found. */
static long long get_entry(const char* name, const char* buf)
{
    char* hit = strstr(buf, name);
    if (hit == NULL) {
        return -ENODATA;
    }

    errno = 0;
    long long val = strtoll(hit + strlen(name), NULL, 10);
    if (errno != 0) {
        int strtoll_errno = errno;
        return -strtoll_errno;
    }
    return val;
}

/* Like get_entry(), but exit if the value cannot be found */
static long long get_entry_fatal(const char* name, const char* buf)
{
    long long val = get_entry(name, buf);
    if (val < 0) {
        exit(1);
    }
    return val;
}

/* If the kernel does not provide MemAvailable (introduced in Linux 3.14),
 * approximate it using other data we can get */
static long long available_guesstimate(const char* buf)
{
    long long Cached = get_entry_fatal("Cached:", buf);
    long long MemFree = get_entry_fatal("MemFree:", buf);
    long long Buffers = get_entry_fatal("Buffers:", buf);
    long long Shmem = get_entry_fatal("Shmem:", buf);

    return MemFree + Cached + Buffers - Shmem;
}

/* Parse /proc/meminfo.
 * This function either returns valid data or kills the process
 * with a fatal error.
 */
meminfo_t parse_meminfo()
{
    // Note that we do not need to close static FDs that we ensure to
    // `fopen()` maximally once.
    static FILE* fd;
    static int guesstimate_warned = 0;
    // On Linux 5.3, "wc -c /proc/meminfo" counts 1391 bytes.
    // 8192 should be enough for the foreseeable future.
    char buf[8192] = { 0 };
    meminfo_t m = { 0 };

    if (fd == NULL) {
        char buf[PATH_LEN] = { 0 };
        snprintf(buf, sizeof(buf), "%s/%s", "/proc", "meminfo");
        fd = fopen(buf, "r");
    }
    if (fd == NULL) {
        exit(1);
    }
    rewind(fd);

    size_t len = fread(buf, 1, sizeof(buf) - 1, fd);
    if (ferror(fd)) {
        exit(1);
    }
    if (len == 0) {
        exit(1);
    }

    m.MemTotalKiB = get_entry_fatal("MemTotal:", buf);
    m.SwapTotalKiB = get_entry_fatal("SwapTotal:", buf);
    m.AnonPagesKiB = get_entry_fatal("AnonPages:", buf);
    m.SwapFreeKiB = get_entry_fatal("SwapFree:", buf);

    m.MemAvailableKiB = get_entry("MemAvailable:", buf);
    if (m.MemAvailableKiB < 0) {
        m.MemAvailableKiB = available_guesstimate(buf);
        if (guesstimate_warned == 0) {
            fprintf(stderr, "Warning: Your kernel does not provide MemAvailable data (needs 3.14+)\n"
                            "         Falling back to guesstimate\n");
            guesstimate_warned = 1;
        }
    }

    // Calculated values
    m.UserMemTotalKiB = m.MemAvailableKiB + m.AnonPagesKiB;

    // Calculate percentages
    m.MemAvailablePercent = (double)m.MemAvailableKiB * 100 / (double)m.UserMemTotalKiB;
    if (m.SwapTotalKiB > 0) {
        m.SwapFreePercent = (double)m.SwapFreeKiB * 100 / (double)m.SwapTotalKiB;
    } else {
        m.SwapFreePercent = 0;
    }

    return m;
}


uint utf8_char_count(const char* str)
{
  uint count = 0;
  while(*str) {
    count += (*str & BYTE_TWO) != BYTE_ONE;
    str++;
  }
  return count;
}


void load_bar_chars(utf8_char* bar_chars, uint count, char* characters) {
  char* c = characters;
  for (uint i = 0; i < count; i++) {
    int size = 0;
    utf8_char* b = bar_chars + i;
    if ( !c[0] ) {
      // error
      printf("FAILED TO LOAD CHARS CORRECT");
    } else if (!(c[0] & BYTE_ONE)) {
      // character is one byte
      size = 1;
    } else if ( (c[0] & BYTE_THREE) == BYTE_TWO ) {
      size = 2;
    } else if ( (c[0] & BYTE_FOUR) == BYTE_THREE) {
      size = 3;
    } else if ( (c[0] & BYTE_FIVE) == BYTE_FOUR) {
      size = 4;
    }
    
    for (uint j = 0; j < size; j++)
     b->bytes[j] = c[j];

    b->size = size;
    
    c += size;
  }
}

int clamp(int value, int min, int max) {
  return value < min ? min : (value > max ? max : value);
}


int main(int argc, char *argv[])
{
  // load environment variables
  char *characters = "";
  uint bar_size = 10;
  char *envvar = NULL;
  int warning = 50;
  int critical = 80;
  char* color_warning = ORANGE;
  char* color_critical = RED;
  
  envvar = getenv("bar_chars");
  if (envvar)
    characters = envvar;
  envvar = getenv("bar_size");
  if (envvar)
    bar_size = atoi(envvar);
  envvar = getenv("critical");
  if (envvar)
    critical = atoi(envvar);
  envvar = getenv("warning");
  if (envvar)
    warning = atoi(envvar);
  envvar = getenv("color_warning");
  if (envvar)
    color_warning = envvar;
  envvar = getenv("color_critical");
  if (envvar)
    color_critical = envvar;
  
  uint count = utf8_char_count(characters);
  utf8_char* bar_chars = (utf8_char*)malloc(count * sizeof(utf8_char));
  
  load_bar_chars(bar_chars, count, characters);

  // allocate the maximun size possible
  int buffer_size = (bar_size * 4) + 1;
  char* buffer = (char*)malloc(buffer_size);
  
  
  uint t = 1;
  while (1) {
    
    meminfo_t info = parse_meminfo();

    long long total = info.MemTotalKiB;
    long long free  = info.MemAvailableKiB;
    long long usage = total - free;
    
    float percent = 100 * ((float)usage / total);
    float bar_percent = percent;

    memset(buffer, 0, buffer_size);
    
    //printf("%ld/%ld   %f  ", usage, total, percent);
    char* write_point = buffer;

    float section_size = 100.0 / bar_size; 
    for (uint i = 0; i < bar_size; i++) {
      int section_val = clamp((int)bar_percent, 0, count-1);
      utf8_char u_char = bar_chars[section_val];

      for (uint j = 0; j < u_char.size; j++)
	  write_point[j] = u_char.bytes[j];

      bar_percent -= section_size;
      write_point += u_char.size;
    }

    if (critical != 0 && percent > critical) {
      printf("<span color='%s'>", color_critical);
    } else if (warning != 0 && percent > warning) {
      printf("<span color='%s'>", color_warning);
    } else {
      printf("<span>");
    }

    const float kib_to_gb = 1024 * 1024;
    
    float usage_gb = usage / kib_to_gb;
    float total_gb = total / kib_to_gb;
    
    printf("%s %4.1fG/%4.1fG (%i%%)</span>\n", buffer, usage_gb, total_gb, (int)percent);
    fflush(stdout);

    sleep(t);
  }
  free(buffer);
  free(bar_chars);
  return EXIT_SUCCESS;
}
