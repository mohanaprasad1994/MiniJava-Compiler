class Factorial{
    public static void main(String[] a){
        System.out.println(10);
    }
}

class Fac {
    boolean a;
    public int ComputeFac(int num, A a){
        A b;
        int num_aux ;
        if (num < 1)
            num_aux = 1 ;
        else
            num_aux = num * (this.ComputeFac(num-1,b)) ;
        return num_aux ;
    }
}
class A extends Fac  {
    int a;
     Fac b;
    public int ComputeFac(int num,A a){
        int num_aux ;
        if (num < 1)
            num_aux = 1 ;
        else
            num_aux = num * (this.ComputeFac(num-1,b)) ;
        return num_aux ;
    }
}


