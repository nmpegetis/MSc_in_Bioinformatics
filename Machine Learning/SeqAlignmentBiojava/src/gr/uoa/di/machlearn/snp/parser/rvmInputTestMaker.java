package gr.uoa.di.machlearn.snp.parser;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
//import java.util.StringTokenizer;

public class rvmInputTestMaker {
	 public static void main(String[]args) throws IOException        
	 { 
//         int word_count=0;
//         int line_count=0;

/**
 * IT IS ESSENTIAL NOT TO FORGET TO DELETE THE "full_test.txt" FILE BEFORE EVERY EXECUTION OF THIS PROGRAM SO THAT THE FILE IS RE-CREATED WITH THE NEW DATA (else it should stay as it is, with the old data)
 * */
		 PrintWriter writer = new PrintWriter(new BufferedWriter(new FileWriter("/RVMdata/cancer_vulvovaginal_test.txt",true)));
         String s1,s2;
//             StringTokenizer st1;
//             StringTokenizer st2;
         BufferedReader buf1=new BufferedReader(new InputStreamReader(System.in));
         BufferedReader buf2=new BufferedReader(new InputStreamReader(System.in));

//everything in comments is to check if every line has the same columns             

         s1="/RVMdata/vulvovaginal_output.txt";		//s1 is always the file that has the minimum lines between the s1 and s2 files
         s2="/RVMdata/cancer_output.txt";
         buf1=new BufferedReader(new FileReader(s1));
         buf2=new BufferedReader(new FileReader(s2));
         while((s1=buf1.readLine())!=null)
         {
        	 	s2=buf2.readLine();
//             		st1=new StringTokenizer(s1," ,;:.");
//             		st2=new StringTokenizer(s2," ,;:.");
         		
         		
/*             		word_count=0;
             		while(st1.hasMoreTokens())
             		{
                             word_count++;
                             s1=st1.nextToken();
                     }
   
                    System.out.println("Word Count in line"+line_count+": "+word_count);
                    line_count++;

                    
             		word_count=0;
                    while(st2.hasMoreTokens())
             		{
                             word_count++;
                             s2=st2.nextToken();
                     }   
                    System.out.println("Word Count in line"+line_count+": "+word_count);
                    line_count++;
*/
                
                writer.println("0\t"+s1);	//add in the beggining "0" for the negative dataset (which in this case is "mental_output.txt")
 				writer.println("1\t"+s2);	//add in the beggining "1" for the positive dataset (which in this case is "cancer_output.txt")
         }
         buf1.close();
         buf2.close();
         writer.close();
	}
}
