import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Ask0 {	
    public static void main(String[] args) {		
        BufferedReader buf = null;
		try {
			buf = new BufferedReader(new InputStreamReader(new DataInputStream(new FileInputStream(args[0]))));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}   
        String line = null, first = null, second = null;
        String pairs[] = null;
        Map<String, HashMap<String,Integer>> lines = new HashMap<String, HashMap<String,Integer>>();
		HashMap<String, Integer> set = null;
		List<String> allLines = new ArrayList<String>(); 
        
		try {
			while((line=buf.readLine())!=null){
				set = new HashMap<String,Integer>();
        		allLines.add(line);
			    pairs = line.split("\\|");
			    first = pairs[0];
			    second = pairs[1];

				if(lines.get(first) == null){
			    	set.put(second,1);
			    	lines.put(first, set);				    	
			    }
				else if(! lines.get(first).containsKey(second)){
					set = lines.get(first);
			    	set.put(second,set.size()+1);
			    	lines.put(first, set);				    	
			    }
			}
		} catch (IOException e) {
			e.printStackTrace();
		}

        try {
			buf.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

        int size;
        for (String str : allLines){

		    pairs = str.split("\\|");
		    first = pairs[0];
		    second = pairs[1];
        	if((size = lines.get(first).size()) > 1)            		
        		System.out.println(str+"["+lines.get(first).get(second)+" of "+size+"]");
        }
    }
}
