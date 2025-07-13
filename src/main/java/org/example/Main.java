package org.example;

public class Main {
    public static void main(String[] args) {
        byte[] charset = "abcdefghijklmnopqrstuvwxyz".getBytes();
       // byte[] targetHash = ...; // MD5 hash bytes of the password you want to crack
        //byte[] foundPassword = new byte[maxPasswordLength + 1];

       // boolean found = CUDABruteForceEngine.crackPasswordCUDA(charset, charset.length, maxPasswordLength, targetHash, startIdx, maxIdx, foundPassword);

        if(false) {
            String password = new String(foundPassword).trim();
            System.out.println("Password found: " + password);
        } else {
            System.out.println("Password not found in this range.");
        }

    }
}