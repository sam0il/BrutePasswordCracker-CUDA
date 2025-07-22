package org.example;

public class NativeCracker {
    static {
        System.load("C:\\Users\\samoi\\IdeaProjects\\BrutePasswordCrackerCUDA\\src\\native\\Library(3)\\x64\\Debug\\bruteforce.dll");
    }

    public native String crackBruteForce(String hash, String charset, int maxLen, String mask);
}
