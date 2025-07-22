#ifndef MD5_CUH
#define MD5_CUH

#include <stdint.h>

__device__ void md5(const char* input, char* output);

#endif // MD5_CUH
