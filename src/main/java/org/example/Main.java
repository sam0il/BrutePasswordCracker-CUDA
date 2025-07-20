package org.example;
import org.example.NativeCracker;

public class Main {
    public static void main(String[] args) {
        NativeCracker cracker = new NativeCracker();

        String hash = "0b44a09cc6a73edaec434d2db382028f"; // example MD5 of "aaa"
        String charset = "abc";
        int maxLength = 3;
        String mask = "???";

        String result = cracker.crackBruteForce(hash, charset, maxLength, mask);
        System.out.println("Cracked password: " + result);
    }
}
