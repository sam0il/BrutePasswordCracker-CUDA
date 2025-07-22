#include "md5.cuh"
#include <stdio.h>
#include <string.h>

#define F(x,y,z) ((x & y) | (~x & z))
#define G(x,y,z) ((x & z) | (y & ~z))
#define H(x,y,z) (x ^ y ^ z)
#define I(x,y,z) (y ^ (x | ~z))

#define ROTATE_LEFT(x,n) ((x << n) | (x >> (32 - n)))

#define FF(a,b,c,d,x,s,ac) \
    a += F(b,c,d) + x + ac; \
    a = ROTATE_LEFT(a,s); \
    a += b;
#define GG(a,b,c,d,x,s,ac) \
    a += G(b,c,d) + x + ac; \
    a = ROTATE_LEFT(a,s); \
    a += b;
#define HH(a,b,c,d,x,s,ac) \
    a += H(b,c,d) + x + ac; \
    a = ROTATE_LEFT(a,s); \
    a += b;
#define II(a,b,c,d,x,s,ac) \
    a += I(b,c,d) + x + ac; \
    a = ROTATE_LEFT(a,s); \
    a += b;

__device__ void md5(const char* input, char* output) {
    int len = strlen(input);
    uint8_t buffer[64] = { 0 };
    memcpy(buffer, input, len);
    buffer[len] = 0x80;
    uint32_t bitLen = len * 8;
    buffer[56] = bitLen & 0xff;
    buffer[57] = (bitLen >> 8) & 0xff;
    buffer[58] = (bitLen >> 16) & 0xff;
    buffer[59] = (bitLen >> 24) & 0xff;

    uint32_t* X = (uint32_t*)buffer;
    uint32_t a = 0x67452301;
    uint32_t b = 0xefcdab89;
    uint32_t c = 0x98badcfe;
    uint32_t d = 0x10325476;

    // Round 1
    FF(a, b, c, d, X[0], 7, 0xd76aa478);
    FF(d, a, b, c, X[1], 12, 0xe8c7b756);
    FF(c, d, a, b, X[2], 17, 0x242070db);
    FF(b, c, d, a, X[3], 22, 0xc1bdceee);
    FF(a, b, c, d, X[4], 7, 0xf57c0faf);
    FF(d, a, b, c, X[5], 12, 0x4787c62a);
    FF(c, d, a, b, X[6], 17, 0xa8304613);
    FF(b, c, d, a, X[7], 22, 0xfd469501);
    FF(a, b, c, d, X[8], 7, 0x698098d8);
    FF(d, a, b, c, X[9], 12, 0x8b44f7af);
    FF(c, d, a, b, X[10], 17, 0xffff5bb1);
    FF(b, c, d, a, X[11], 22, 0x895cd7be);
    FF(a, b, c, d, X[12], 7, 0x6b901122);
    FF(d, a, b, c, X[13], 12, 0xfd987193);
    FF(c, d, a, b, X[14], 17, 0xa679438e);
    FF(b, c, d, a, X[15], 22, 0x49b40821);

    // Round 2
    GG(a, b, c, d, X[1], 5, 0xf61e2562);
    GG(d, a, b, c, X[6], 9, 0xc040b340);
    GG(c, d, a, b, X[11], 14, 0x265e5a51);
    GG(b, c, d, a, X[0], 20, 0xe9b6c7aa);
    GG(a, b, c, d, X[5], 5, 0xd62f105d);
    GG(d, a, b, c, X[10], 9, 0x02441453);
    GG(c, d, a, b, X[15], 14, 0xd8a1e681);
    GG(b, c, d, a, X[4], 20, 0xe7d3fbc8);
    GG(a, b, c, d, X[9], 5, 0x21e1cde6);
    GG(d, a, b, c, X[14], 9, 0xc33707d6);
    GG(c, d, a, b, X[3], 14, 0xf4d50d87);
    GG(b, c, d, a, X[8], 20, 0x455a14ed);
    GG(a, b, c, d, X[13], 5, 0xa9e3e905);
    GG(d, a, b, c, X[2], 9, 0xfcefa3f8);
    GG(c, d, a, b, X[7], 14, 0x676f02d9);
    GG(b, c, d, a, X[12], 20, 0x8d2a4c8a);

    // Round 3
    HH(a, b, c, d, X[5], 4, 0xfffa3942);
    HH(d, a, b, c, X[8], 11, 0x8771f681);
    HH(c, d, a, b, X[11], 16, 0x6d9d6122);
    HH(b, c, d, a, X[14], 23, 0xfde5380c);
    HH(a, b, c, d, X[1], 4, 0xa4beea44);
    HH(d, a, b, c, X[4], 11, 0x4bdecfa9);
    HH(c, d, a, b, X[7], 16, 0xf6bb4b60);
    HH(b, c, d, a, X[10], 23, 0xbebfbc70);
    HH(a, b, c, d, X[13], 4, 0x289b7ec6);
    HH(d, a, b, c, X[0], 11, 0xeaa127fa);
    HH(c, d, a, b, X[3], 16, 0xd4ef3085);
    HH(b, c, d, a, X[6], 23, 0x04881d05);
    HH(a, b, c, d, X[9], 4, 0xd9d4d039);
    HH(d, a, b, c, X[12], 11, 0xe6db99e5);
    HH(c, d, a, b, X[15], 16, 0x1fa27cf8);
    HH(b, c, d, a, X[2], 23, 0xc4ac5665);

    // Round 4
    II(a, b, c, d, X[0], 6, 0xf4292244);
    II(d, a, b, c, X[7], 10, 0x432aff97);
    II(c, d, a, b, X[14], 15, 0xab9423a7);
    II(b, c, d, a, X[5], 21, 0xfc93a039);
    II(a, b, c, d, X[12], 6, 0x655b59c3);
    II(d, a, b, c, X[3], 10, 0x8f0ccc92);
    II(c, d, a, b, X[10], 15, 0xffeff47d);
    II(b, c, d, a, X[1], 21, 0x85845dd1);
    II(a, b, c, d, X[8], 6, 0x6fa87e4f);
    II(d, a, b, c, X[15], 10, 0xfe2ce6e0);
    II(c, d, a, b, X[6], 15, 0xa3014314);
    II(b, c, d, a, X[13], 21, 0x4e0811a1);
    II(a, b, c, d, X[4], 6, 0xf7537e82);
    II(d, a, b, c, X[11], 10, 0xbd3af235);
    II(c, d, a, b, X[2], 15, 0x2ad7d2bb);
    II(b, c, d, a, X[9], 21, 0xeb86d391);

    a += 0x67452301;
    b += 0xefcdab89;
    c += 0x98badcfe;
    d += 0x10325476;

    sprintf(output, "%08x%08x%08x%08x", a, b, c, d);
}
