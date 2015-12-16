import syntaxtree.*;
import visitor.*;

public class P5 {
   public static void main(String [] args) {
      try {
         Node root = new microIRParser(System.in).Goal();
         //System.out.println("Program parsed successfully");
         Object tempno=root.accept(new GJDepthFirst(),null); // Your assignment part is invoked here.
         Object temp2=root.accept(new GJDepthFirst2(),tempno);
         root.accept(new GJDepthFirst3(),temp2);
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
} 

