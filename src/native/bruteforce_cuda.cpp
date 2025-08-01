#include <jni.h>
#include <string>
#include <iostream>
#include <cuda_runtime.h>
#include "org_example_NativeCracker.h"

#define THREADS 256
#define BLOCKS 64
#define MAX_LEN 16

extern __global__ void kernel_brute_force(const char*, const char*, int, const char*, int, char*, bool*, unsigned long long);

JNIEXPORT jstring JNICALL Java_org_example_NativeCracker_crackBruteForce
(JNIEnv* env, jobject, jstring jHash, jstring jCharset, jint maxLen, jstring jMask) {
    const char* hash = env->GetStringUTFChars(jHash, 0);
    const char* charset = env->GetStringUTFChars(jCharset, 0);
    const char* mask = env->GetStringUTFChars(jMask, 0);

    int charsetLen = static_cast<int>(strlen(charset));
    int maskLen = static_cast<int>(strlen(mask));
    // Calculate total number of combinations based on mask and charset
    unsigned long long totalCombos = 1;
    for (int i = 0; i < maskLen; ++i)
        if (mask[i] == '?') totalCombos *= charsetLen;

    std::cout << "================ CUDA CRACKER CONFIG ================\n";
    std::cout << "Charset: " << charset << "\nHash: " << hash << "\nMask: " << mask << std::endl;
    std::cout << "Mask Length: " << maskLen << ", Charset Length: " << charsetLen << "\n";
    std::cout << "Total Combinations: " << totalCombos << "\n=====================================================\n";

    // Allocate GPU memory
    char* d_hash, * d_charset, * d_mask, * d_output;
    bool* d_found;
    cudaMalloc(&d_hash, 33);
    cudaMalloc(&d_charset, charsetLen + 1);
    cudaMalloc(&d_mask, maskLen + 1);
    cudaMalloc(&d_output, MAX_LEN + 1);
    cudaMalloc(&d_found, sizeof(bool));

    // Copy data to device
    cudaMemcpy(d_hash, hash, 33, cudaMemcpyHostToDevice);
    cudaMemcpy(d_charset, charset, charsetLen + 1, cudaMemcpyHostToDevice);
    cudaMemcpy(d_mask, mask, maskLen + 1, cudaMemcpyHostToDevice);

    // Reset found flag on GPU
    bool h_found = false;
    cudaMemcpy(d_found, &h_found, sizeof(bool), cudaMemcpyHostToDevice);

    // Host-side buffer for cracked password
    char h_output[MAX_LEN + 1] = { 0 };
    unsigned long long batchSize = THREADS * BLOCKS;

    // Launch kernel in batches until password is found
    for (unsigned long long i = 0; i < totalCombos; i += batchSize) {
        kernel_brute_force << <BLOCKS, THREADS >> > (
            d_hash, d_charset, charsetLen, d_mask, maskLen, d_output, d_found, i
            );
        cudaDeviceSynchronize();

        // Check if password was found
        cudaMemcpy(&h_found, d_found, sizeof(bool), cudaMemcpyDeviceToHost);
        if (h_found) break;
    }

    // Copy result back to host
    cudaMemcpy(h_output, d_output, MAX_LEN + 1, cudaMemcpyDeviceToHost);

    // Free GPU memory
    cudaFree(d_hash);
    cudaFree(d_charset);
    cudaFree(d_mask);
    cudaFree(d_output);
    cudaFree(d_found);

    // Release Java string memory
    env->ReleaseStringUTFChars(jHash, hash);
    env->ReleaseStringUTFChars(jCharset, charset);
    env->ReleaseStringUTFChars(jMask, mask);

    // Return result to Java
    return env->NewStringUTF(h_found ? h_output : "NOT FOUND");
}
