package org.example;

public class NativeCracker {
    static {
        System.loadLibrary("BruteForceCudaNative"); // Will link to the native DLL
    }

    // Brute-force version with mask support
    public native String crackBruteForce(String hash, String charset, int maxLen, String mask);

    // Dictionary attack (optional)
    public native String crackDictionary(String hash, String[] wordlist);
}
