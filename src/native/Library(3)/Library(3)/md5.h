#ifndef MD5_H
#define MD5_H

#include <stdint.h>

// Simple GPU-compatible MD5 implementation declarations
__device__ void md5(const char* input, char* output);

#endif
