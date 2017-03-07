/**
 * Author: Paul Reiners
 */
package com.ibm.compbio.misc;

/**
 * @author Paul Reiners
 * 
 */
public class Fibonacci {

   /**
    * @param args
    */
   public static void main(String[] args) {
      Fibonacci fibonacci = new Fibonacci();
      for (int i = 0; i < 8; i++) {
         System.out.print("" + fibonacci.fibonacci1(i) + ", ");
      }
      System.out.println("...");
      for (int i = 0; i < 8; i++) {
         System.out.print("" + fibonacci.fibonacci2(i) + ", ");
      }
      System.out.println("...");
   }

   public int fibonacci1(int n) {
      if (n == 0) {
         return 0;
      } else if (n == 1) {
         return 1;
      } else {
         return fibonacci1(n - 1) + fibonacci1(n - 2);
      }
   }

   public int fibonacci2(int n) {
      int[] table = new int[n + 1];
      for (int i = 0; i < table.length; i++) {
         if (i == 0) {
            table[i] = 0;
         } else if (i == 1) {
            table[i] = 1;
         } else {
            table[i] = table[i - 2] + table[i - 1];
         }
      }

      return table[n];
   }
}
