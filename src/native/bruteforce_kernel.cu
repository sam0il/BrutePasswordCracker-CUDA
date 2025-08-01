#include <stdio.h>
#include <string.h>
#include "md5.cuh"  // Contains our MD5 implementation

#define MAX_LEN 16  // Maximum password length we can handle

/**
 * Device Function: Compares generated password with target MD5 hash
 *
 * @param attempt      The password attempt to check
 * @param len          Length of the password attempt
 * @param targetHash   The MD5 hash we're trying to match
 * @return             True if the attempt's hash matches targetHash
 */
__device__ bool matchHash(const char* attempt, int len, const char* targetHash) {
    char result[33];  // MD5 produces 32-char hex string + null terminator

    // Generate MD5 hash of the current attempt
    md5(attempt, len, result);

    // Compare each character of the generated hash with target
    for (int i = 0; i < 32; ++i) {
        if (result[i] != targetHash[i]) {
            return false;  // Mismatch found
        }
    }
    return true;  // All characters matched!
}

/**
 * CUDA Kernel: Brute-force password cracker
 *
 * Each thread tries different password combinations based on:
 * - Character set (charset)
 * - Mask pattern (like "a??bc")
 * - Starting index (for parallel processing)
 *
 * @param hash        Target MD5 hash to crack (on device)
 * @param charset     Available characters for brute-forcing
 * @param charsetLen  Length of the charset
 * @param mask        Pattern with ? for unknown chars (e.g., "a??bc")
 * @param maskLen     Length of the mask
 * @param output      Buffer to store found password
 * @param found       Flag to indicate if password was found
 * @param startIndex  Starting combination index for this batch
 */
__global__ void kernel_brute_force(
    const char* hash,
    const char* charset,
    int charsetLen,
    const char* mask,
    int maskLen,
    char* output,
    bool* found,
    unsigned long long startIndex
) {
    // Calculate this thread's unique index
    unsigned long long idx = threadIdx.x + blockIdx.x * blockDim.x + startIndex;

    // Early exit if another thread already found the password
    if (*found) return;

    // Buffer for current password attempt
    char attempt[MAX_LEN + 1] = { 0 };
    unsigned long long temp = idx;

    // Generate password attempt based on mask and charset
    for (int i = maskLen - 1; i >= 0; --i) {
        if (mask[i] == '?') {
            // Replace ? with charset character based on index
            attempt[i] = charset[temp % charsetLen];
            temp /= charsetLen;
        }
        else {
            // Use fixed character from mask
            attempt[i] = mask[i];
        }
    }

    // Check if this attempt matches the target hash
    if (matchHash(attempt, maskLen, hash)) {
        *found = true;  // Signal other threads to stop

        // Store found password in output buffer
        for (int i = 0; i < maskLen; ++i) {
            output[i] = attempt[i];
        }
        output[maskLen] = '\0';  // Null-terminate
    }
}