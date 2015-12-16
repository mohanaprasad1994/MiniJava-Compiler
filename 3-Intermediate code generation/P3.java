import java.io.FileInputStream;
import java.io.FileNotFoundException;

import syntaxtree.*;
import visitor.*;

public class P3 {
   public static void main(String [] args)  {
      try {
         Node root = new MiniJavaParser(System.in).Goal();
         
         Object table=root.accept(new GJDepthFirst(),null); // Your assignment part is invoked here.
         root.accept(new GJDepthFirst2(),table);
         
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
} 



