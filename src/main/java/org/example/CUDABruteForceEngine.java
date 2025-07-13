package org.example;

public class CUDABruteForceEngine {
    static {
        System.loadLibrary("BruteForceCudaNative"); // Load your DLL
    }

    // Declare native method signature (match C++ DLL export)
    public native boolean crackPasswordCUDA(byte[] charset, int charsetLen, int passLen, byte[] targetHash, long startIdx, long maxIdx, byte[] foundPassword);

    // Helper Java methods to use this native method, e.g. convert to UTF8, etc.
}
