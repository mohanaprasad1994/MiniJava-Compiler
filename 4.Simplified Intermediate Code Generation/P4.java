import syntaxtree.*;
import visitor.*;

public class P4 {
   public static void main(String [] args) {
      try {
         Node root = new MiniIRParser(System.in).Goal();
         //System.out.println("Program parsed successfully");
         Object tempno=root.accept(new GJDepthFirst(),null); // Your assignment part is invoked here.
         root.accept(new GJDepthFirst2(),tempno);
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
} 

