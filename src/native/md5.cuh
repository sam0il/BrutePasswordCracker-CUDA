#ifndef MD5_CUH
#define MD5_CUH

#include <stdint.h>

/*
 * CUDA Device Function: MD5 Hash Implementation
 *
 * This implements the MD5 hashing algorithm optimized for GPU execution.
 * Key features:
 * - Processes input in 64-byte chunks
 * - Uses bitwise operations for performance
 * - Generates 32-character hex output
 *
 * Parameters:
 * - input:     The plaintext to hash
 * - input_len: Length of the input string
 * - output:    33-byte buffer for hex result (including null terminator)
 */
__device__ inline void md5(const char* input, int input_len, char* output) {
    // MD5 uses these constants for its rounds
    const uint32_t S[64] = {
        7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22, // Round 1
        5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20, // Round 2
        4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23, // Round 3
        6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21  // Round 4
    };

    // Precomputed sine values (as integers)
    const uint32_t K[64] = {
        0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee, // Round 1
        0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
        0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
        0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,

        0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,  // Round 2
        0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
        0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
        0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,

        0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,  // Round 3
        0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
        0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
        0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,

        0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,  // Round 4
        0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
        0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
        0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391
    };

    // Working buffers
    uint8_t buffer[64] = { 0 };  // Input buffer (always 64 bytes)
    uint32_t block[16] = { 0 };  // Message as 16 32-bit words

    /* --- MD5 Initialization --- */
    // These are the initial hash values specified in the MD5 standard
    uint32_t a0 = 0x67452301;  // A
    uint32_t b0 = 0xefcdab89;  // B
    uint32_t c0 = 0x98badcfe;  // C 
    uint32_t d0 = 0x10325476;  // D

    /* --- Input Processing --- */
    // 1. Copy input into working buffer
    for (int i = 0; i < input_len; i++) {
        buffer[i] = input[i];
    }

    // 2. Add padding (MD5 spec requires 0x80 followed by zeros)
    buffer[input_len] = 0x80;  // Append '1' bit

    // 3. Append original length in bits (little-endian)
    uint64_t bit_len = input_len * 8;
    for (int i = 0; i < 8; i++) {
        buffer[56 + i] = (bit_len >> (i * 8)) & 0xff;
    }

    // 4. Convert byte buffer to 32-bit words
    for (int i = 0; i < 16; i++) {
        block[i] = (buffer[i * 4 + 3] << 24) | (buffer[i * 4 + 2] << 16) |
            (buffer[i * 4 + 1] << 8) | buffer[i * 4];
    }

    /* --- MD5 Transformation --- */
    uint32_t A = a0, B = b0, C = c0, D = d0;

    // Process each of the 64 operations
    for (int i = 0; i < 64; i++) {
        uint32_t F, g;

        // Round 1 (0-15)
        if (i < 16) {
            F = (B & C) | ((~B) & D);  // F = (B AND C) OR ((NOT B) AND D)
            g = i;
        }
        // Round 2 (16-31)
        else if (i < 32) {
            F = (D & B) | ((~D) & C);  // F = (D AND B) OR ((NOT D) AND C)
            g = (5 * i + 1) % 16;
        }
        // Round 3 (32-47)
        else if (i < 48) {
            F = B ^ C ^ D;  // F = B XOR C XOR D
            g = (3 * i + 5) % 16;
        }
        // Round 4 (48-63)
        else {
            F = C ^ (B | (~D));  // F = C XOR (B OR (NOT D))
            g = (7 * i) % 16;
        }

        // Core MD5 operation
        F = F + A + K[i] + block[g];
        A = D;
        D = C;
        C = B;
        B = B + ((F << S[i]) | (F >> (32 - S[i])));  // Left rotate
    }

    /* --- Final Hash Construction --- */
    // Add the transformed values back to the initial values
    a0 += A;
    b0 += B;
    c0 += C;
    d0 += D;

    // Convert the four 32-bit values to hexadecimal string
    const char hex_chars[] = "0123456789abcdef";
    for (int i = 0; i < 4; i++) {
        uint32_t val = (i == 0) ? a0 : (i == 1) ? b0 : (i == 2) ? c0 : d0;
        for (int j = 0; j < 8; j++) {
            int hex_index = (val >> (4 * (7 - j))) & 0xF;
            output[i * 8 + j] = hex_chars[hex_index];
        }
    }
    output[32] = '\0';  // Null-terminate the string
}

#endif // MD5_CUH