package org.example;

public class Main {
    public static void main(String[] args) {
        NativeCracker cracker = new NativeCracker();

        String hash = "0b44a09cc6a73edaec434d2db382028f"; // MD5("abc")
        String charset = "abc";
        String mask = "???";
        int maxLen = 3;

        String result = cracker.crackBruteForce(hash, charset, maxLen, mask);
        System.out.println("JNI call returned: " + result);
    }
}
