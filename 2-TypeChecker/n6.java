class Factorial{
    public static void main(String[] a){
        System.out.println(1);
    }
}

class Fac1 extends Fac{
    int a;
    public Fac ComputeFac(){
        int num_aux;int num ;
        if (num < 1)
            num_aux = 1 ;
        else
            num_aux = a;
        return new Fac1();
    }
}
class Fac{
    int a;
    public Fac ComputeFac(){
        int num;
        int num_aux ;
        if (num < 1)
            num_aux = 1 ;
        else
            num_aux = num;
        return this;
    }
}
