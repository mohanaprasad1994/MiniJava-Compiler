%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
extern int yylex();
extern void yyerror(char *);
extern char* yytext;

int num_macro=0;
struct Macro{
    char* identifier;
    char* replacewith;
    int numarg;
    char** arg;
    int type;
    } ; 
struct Macro list[1000]; 
int valid_char(char a){
    if(a>='a' && a<='z' || a>='A' && a<='Z' ||a>='0' &&a<='9' || a=='_')
        return 1;
    return 0;
    }
char** get_arg(char* arglist,int * num){
      if(arglist==NULL)
            {*num=0;return NULL;}
      *num=1;int i=0;int l=strlen(arglist);
      while(i<l){
        if(arglist[i]==',')
        (*num)++;
        i++;
        }
      
      char** t=(char**)malloc(((*num)+2)*sizeof(char*));
      for(i=0;i<(*num);i++)
        t[i]=(char*)malloc((l+5)*sizeof(char));
      int k=0,j=0;
      
      for(i=0;i<l;i++){
        if(arglist[i]!=','){
            
            t[k][j]=arglist[i];j++;
            }
        else{t[k][j]='\0';k++;j=0;}
       }
       t[k][j]='\0';
        return t;
  }
      
      
void add_macro(char* idf,char* arglist,char* replace,int type){
        int i;
        for(i=0;i<num_macro;i++)
            if(strcmp(idf,list[i].identifier)==0){
                printf("// Failed to parse macrojava code.");exit(0);}
        list[num_macro].identifier=idf;
        list[num_macro].replacewith=replace;
        int a;
        list[num_macro].arg=get_arg(arglist,&a);
        (list[num_macro].numarg)=a;
        list[num_macro].type=type;
        //for(i=0;i<list[num_macro].numarg;i++)
            //printf("%s\n",list[num_macro].arg[i]);
       num_macro++;
}

char* replace(char* idf,char* arglist,int type){
        
        int ind,flag=0;char* temp;
        for(ind=0;ind<num_macro;ind++)
            if(strcmp(list[ind].identifier,idf)==0 && type==list[ind].type)
                {flag=1;break;}
        if(flag==0)
        {   printf("// Failed to parse macrojava code.");exit(0);}
        
        if(arglist==NULL){
            if(list[ind].numarg==0){
                temp=(char*)malloc((strlen(list[ind].replacewith)+5)*sizeof(char));
                temp=strcpy(temp,list[ind].replacewith);//printf("%s  ",temp);
                return temp;}
            printf("// Failed to parse macrojava code.");exit(0);
        }
        
        int num;char** arg=get_arg(arglist,&num);//printf("FFF %d %s\n",num,arg[0]);
        
        if(num!=list[ind].numarg)
        {  printf("// Failed to parse macrojava code.");exit(0);}
        char* final=(char*)malloc(10000*sizeof(char));int pos=0;final[0]='\0';
        int l=strlen(list[ind].replacewith);int i,j;
        //printf("%s ",list[ind].replacewith);
        char *a=(char*)malloc((l+5)*sizeof(char));int k=0;a[0]='\0';
        for(i=0;i<l;i++){
            if(valid_char(list[ind].replacewith[i])==0){
                a[k]='\0';
                for(j=0;j<list[ind].numarg;j++){
                   
                    if(strcmp(list[ind].arg[j],a)==0){ //printf("%s %s %s\n",list[ind].arg[j],a,arg[j]);
                                                        
                        strcat(final,arg[j]);pos+=strlen(arg[j]);
                        a[0]='\0';k=0;
                        break;}
                    }
                 a[k]='\0';
                strcat(final,a);pos+=strlen(a);k=0;
                final[pos++]=list[ind].replacewith[i];final[pos]='\0';
                //printf("%s ",final);
                
            }
            else{
                a[k++]=list[ind].replacewith[i];
                }
          }
          //printf("FINAL%s",final);
          return final;
          }
                    
                
       
         
        
        
           
        
%}


%union {
    char * strval;
}
%token SEMICOLON CLASS IF ELSE  ERROR WHILE LPARAN RPARAN LCPARAN RCPARAN LSPARAN RSPARAN LESSTHAN GREATERTHAN EQUALS PLUS MINUS STAR DIV 
        END PUBLIC STATIC VOID MAIN NEW FALSE TRUE THIS WORDINT AND OR NOT DOT LENGTH SYSTEM STRING COMMA EXT BOOLE RET DEFINE OTHER
%token <strval> INT
%token <strval> IDENTIFIER
%start goal
%type <strval> PrimaryExpression
%type <strval> Identifier
%type <strval> Expression
%type <strval> MacroExpression
%type <strval> CommaExpressionStar
%type <strval> MethodDeclarationStar
%type <strval> CommaTypeIdentifierStar
%type <strval> StatementStar
%type <strval> CommaIdentifierStar;
%type <strval> prog
%type <strval> TypeDeclarationStar
%type <strval> TypeIdentifierStar
%type <strval> TypeIdentifierSemicolon
%type <strval> MainClass
%type <strval> TypeDeclaration
%type <strval> MethodDeclaration
%type <strval> Type
%type <strval> Statement
%type <strval> MacroStatement



%%
goal:    prog                                                      {printf("%s",$1);exit(0);};
prog:	 MacroDefinitionStar MainClass TypeDeclarationStar             {$$=(char*)malloc((strlen($2)+strlen($3)+10)*sizeof(char));
                                                                        strcpy($$,$2);strcat($$,$3);
                                                                        free($2);free($3);} ;

MacroDefinitionStar: MacroDefinitionStar MacroDefinition                  

                        |                                              ;
                     
TypeDeclarationStar:  TypeDeclaration TypeDeclarationStar               {$$=(char*)malloc((strlen($1)+strlen($2)+5)*sizeof(char));
                                                                        strcpy($$,$1);strcat($$,$2);free($1);free($2);}   

                        |                                               {$$=(char*)malloc(2*sizeof(char));strcpy($$,"");} ;
                        
TypeIdentifierStar: TypeIdentifierStar TypeIdentifierSemicolon          {$$=(char*)malloc((strlen($1)+strlen($2)+5)*sizeof(char));
                                                                        strcpy($$,$1);strcat($$,$2);free($1);free($2);}   

                        |                                               {$$=(char*)malloc(2*sizeof(char));strcpy($$,"");} ;
                        
TypeIdentifierSemicolon: Type Identifier SEMICOLON                      {$$=(char*)malloc((strlen($1)+strlen($2)+4)*sizeof(char));
                                                                         strcpy($$,$1);strcat($$,$2);strcat($$,";");
                                                                         free($1);free($2);};

MethodDeclarationStar: MethodDeclaration MethodDeclarationStar         {$$=(char*)malloc((strlen($1)+strlen($2)+5)*sizeof(char));
                                                                        strcpy($$,$1);strcat($$,$2);free($1);free($2);}   

                        |                                               {$$=(char*)malloc(2*sizeof(char));strcpy($$,"");} ;
                        
CommaTypeIdentifierStar: CommaTypeIdentifierStar COMMA Type Identifier {$$=(char*)malloc((strlen($1)+strlen($3)+strlen($4)+10)*sizeof(char));
                                                                        strcpy($$,$1);strcat($$,",");strcat($$,$3);strcat($$," ");strcat($$,$4);free($4);free($1);free($3);}
                                                                                            
                        |                                               {$$=(char*)malloc(2*sizeof(char));strcpy($$,"");} ;

StatementStar: Statement StatementStar                  {$$=(char*)malloc((strlen($1)+strlen($2)+3)*sizeof(char));
                                                        strcpy($$,$1);strcat($$,$2);free($1);free($2);}
                                                                  
               |                                        {$$=(char*)malloc(2*sizeof(char));strcpy($$,"");};
               
CommaExpressionStar: CommaExpressionStar COMMA Expression {$$=(char*)malloc((strlen($1)+strlen($3)+3)*sizeof(char));
                                                           strcpy($$,$1);strcat($$,",");strcat($$,$3);free($1);free($3);}
                                                                               
                     |                                    {$$=(char*)malloc(2*sizeof(char));strcpy($$,"");} ;
                     
CommaIdentifierStar: CommaIdentifierStar COMMA Identifier {$$=(char*)malloc((strlen($1)+strlen($3)+3)*sizeof(char));
                                                           strcpy($$,$1);strcat($$,",");strcat($$,$3);free($1);free($3);} 
   
                    |                                      {$$=(char*)malloc(2*sizeof(char));strcpy($$,"");}; 
                    
                   
MainClass	:   CLASS Identifier LCPARAN PUBLIC STATIC VOID MAIN LPARAN STRING LSPARAN RSPARAN Identifier RPARAN LCPARAN SYSTEM LPARAN Expression RPARAN SEMICOLON RCPARAN RCPARAN 
                            {$$=(char*)malloc((strlen($2)+strlen($12)+strlen($17)+100)*sizeof(char));
                            strcpy($$,"class ");strcat($$,$2);strcat($$,"{public static void main (String[] ");strcat($$,$12);strcat($$,"){System.out.println(");strcat($$,$17);strcat($$,");}}");
                            free($2);free($12);free($17);} ;
                    

TypeDeclaration	:	CLASS Identifier LCPARAN TypeIdentifierStar MethodDeclarationStar RCPARAN 
                            {$$=(char*)malloc((strlen($2)+strlen($4)+strlen($5)+50)*sizeof(char));
                            strcpy($$,"class ");strcat($$,$2);strcat($$,"{");strcat($$,$4);strcat($$,$5);
                            strcat($$,"}");free($2);free($4);free($5);};
                    |	CLASS Identifier EXT Identifier LCPARAN TypeIdentifierStar MethodDeclarationStar RCPARAN 
                            {$$=(char*)malloc((strlen($2)+strlen($4)+strlen($6)+strlen($7)+50)*sizeof(char));
                            strcpy($$,"class ");strcat($$,$2);strcat($$," extends ");strcat($$,$4);strcat($$,"{");strcat($$,$6);strcat($$,$7);
                            strcat($$,"}");free($2);free($4);free($6);free($7);};
                            

MethodDeclaration: 	PUBLIC Type Identifier LPARAN RPARAN LCPARAN TypeIdentifierStar StatementStar RET Expression SEMICOLON RCPARAN  
                            {$$=(char*)malloc((strlen($2)+strlen($3)+strlen($7)+strlen($8)+strlen($10)+50)*sizeof(char));
                            strcpy($$,"public ");strcat($$,$2);strcat($$,$3);strcat($$,"(){");strcat($$,$7);strcat($$,$8);
                            strcat($$,"return ");strcat($$,$10);strcat($$,";}");free($2);free($3);free($7);free($8);free($10);}
                            
                    | PUBLIC Type Identifier LPARAN  Type Identifier CommaTypeIdentifierStar RPARAN LCPARAN TypeIdentifierStar StatementStar RET Expression SEMICOLON RCPARAN  
                            {$$=(char*)malloc((strlen($2)+strlen($3)+strlen($5)+strlen($6)+strlen($7)+strlen($10)+strlen($11)+strlen($13)+50)*sizeof(char));
                            strcpy($$,"public ");strcat($$,$2);strcat($$,$3);strcat($$,"(");strcat($$,$5);strcat($$,$6);strcat($$,$7);strcat($$,"){");
                            strcat($$,$10);strcat($$,$11);strcat($$,"return ");strcat($$,$13);strcat($$,";}");free($2);free($3);free($5);free($6);free($7);free($10);free($11);free($13);} ;
                    
Type	:	WORDINT LSPARAN RSPARAN {$$=(char*)malloc(10*sizeof(char));strcpy($$,"int[] ");}

            |	BOOLE           {$$=(char*)malloc(10*sizeof(char));strcpy($$,"boolean ");}
            
            |	WORDINT         {$$=(char*)malloc(10*sizeof(char));strcpy($$,"int ");}
            
            |	Identifier       {$$=(char*)malloc((strlen($1)+3)*sizeof(char));
                                    strcpy($$,$1);strcat($$," ");free($1);};

Statement	:	LCPARAN StatementStar RCPARAN                                       {$$=(char*)malloc((strlen($2)+10)*sizeof(char));
                                                                                    strcpy($$,"{");strcat($$,$2);strcat($$,"}");free($2);}
                                                                                    
                |	SYSTEM LPARAN Expression RPARAN SEMICOLON                       {$$=(char*)malloc((strlen($3)+30)*sizeof(char));
                                                                                    strcpy($$,"System.out.println(");strcat($$,$3);strcat($$,");");free($3);}
                                                                                    
                |	Identifier EQUALS Expression SEMICOLON                          {$$=(char*)malloc((strlen($1)+strlen($3)+10)*sizeof(char));
                                                                                    strcpy($$,$1);strcat($$,"=");strcat($$,$3);strcat($$,";");free($1);free($3);}
                                                                                    
                |	Identifier LSPARAN Expression RSPARAN EQUALS Expression SEMICOLON   {$$=(char*)malloc((strlen($1)+strlen($3)+strlen($6)+10)*sizeof(char));
                                                                                           strcpy($$,$1);strcat($$,"[");strcat($$,$3);strcat($$,"]=");
                                                                                           strcat($$,$6);strcat($$,";");
                                                                                           free($1);free($3);free($6);} 
                                                                                           
                |	IF LPARAN Expression RPARAN Statement                               {$$=(char*)malloc((strlen($3)+strlen($5)+15)*sizeof(char));
                                                                                        strcpy($$,"if");strcat($$,"(");strcat($$,$3);strcat($$,")");strcat($$,$5);
                                                                                        free($3);free($5);} 
                                                                                                                             
                |	IF LPARAN Expression RPARAN Statement ELSE Statement                {$$=(char*)malloc((strlen($3)+strlen($5)+strlen($7)+15)*sizeof(char));
                                                                                           strcpy($$,"if(");strcat($$,$3);strcat($$,")");strcat($$,$5);
                                                                                           strcat($$,"else ");strcat($$,$7);
                                                                                           free($3);free($5);free($7);}
                                                                                           
                |	WHILE LPARAN Expression RPARAN Statement                            {$$=(char*)malloc((strlen($3)+strlen($5)+15)*sizeof(char));
                                                                                        strcpy($$,"while(");strcat($$,$3);strcat($$,")");strcat($$,$5);
                                                                                        free($3);free($5);} 
                                                                                        
                |	MacroStatement                                                      {$$=$1;};
                
MacroStatement :    Identifier LPARAN RPARAN SEMICOLON                                     { $$=replace($1,NULL,1);
                                                                                            free($1);} 
                                                                                        
                    | Identifier LPARAN Expression CommaExpressionStar RPARAN SEMICOLON   {char* temp=(char*)malloc((strlen($3)+strlen($4)+10)*sizeof(char));
                                                                                            strcpy(temp,$3);strcat(temp,$4);
                                                                                            $$=replace($1,temp,1);
                                                                                            free($1);free($3);free($4);};
                                                                                
Expression	:	PrimaryExpression AND PrimaryExpression       {$$=(char*)malloc((strlen($1)+strlen($3)+10)*sizeof(char));
                                                                strcpy($$,$1);strcat($$,"&");strcat($$,$3);free($1);free($3);}                       
                
                |	PrimaryExpression LESSTHAN PrimaryExpression  {$$=(char*)malloc((strlen($1)+strlen($3)+10)*sizeof(char));
                                                                strcpy($$,$1);strcat($$,"<");strcat($$,$3);free($1);free($3);}                      
                
                |	PrimaryExpression PLUS PrimaryExpression    {$$=(char*)malloc((strlen($1)+strlen($3)+10)*sizeof(char));
                                                                strcpy($$,$1);strcat($$,"+");strcat($$,$3);free($1);free($3);}                                                 
                
                |	PrimaryExpression MINUS PrimaryExpression   {$$=(char*)malloc((strlen($1)+strlen($3)+10)*sizeof(char));
                                                                strcpy($$,$1);strcat($$,"-");strcat($$,$3);free($1);free($3);}                                             
                
                |	PrimaryExpression STAR PrimaryExpression     {$$=(char*)malloc((strlen($1)+strlen($3)+10)*sizeof(char));
                                                                strcpy($$,$1);strcat($$,"*");strcat($$,$3);free($1);free($3);}                                            
                
                |	PrimaryExpression DIV PrimaryExpression         {$$=(char*)malloc((strlen($1)+strlen($3)+10)*sizeof(char));
                                                                    strcpy($$,$1);strcat($$,"/");strcat($$,$3);free($1);free($3);}                                               
                
                |	PrimaryExpression LSPARAN PrimaryExpression RSPARAN  {$$=(char*)malloc((strlen($1)+strlen($3)+10)*sizeof(char));
                                                                            strcpy($$,$1);strcat($$,"[");strcat($$,$3);strcat($$,"]");free($1);free($3);}                                     
                
                |	PrimaryExpression LENGTH                        {$$=(char*)malloc((strlen($1)+10)*sizeof(char));
                                                                    strcpy($$,$1);strcat($$,".length");free($1);}                                                             
                
                |	PrimaryExpression                               {$$=(char*)malloc((strlen($1)+10)*sizeof(char));
                                                                    strcpy($$,$1);free($1);}                                              
               
                |	PrimaryExpression DOT Identifier LPARAN Expression CommaExpressionStar RPARAN {$$=(char*)malloc((strlen($1)+strlen($3)+strlen($5)+strlen($6)+15)*sizeof(char));
                                                                                                    strcpy($$,$1);strcat($$,".");strcat($$,$3);strcat($$,"(");
                                                                                                    strcat($$,$5);strcat($$,$6);strcat($$,")");free($1);free($3);free($5);free($6);}   
                
                |   PrimaryExpression DOT Identifier LPARAN RPARAN        {$$=(char*)malloc((strlen($1)+strlen($3)+10)*sizeof(char));
                                                                            strcpy($$,$1);strcat($$,".");strcat($$,$3);strcat($$,"()");
                                                                            free($1);free($3);}                             
               
                |	MacroExpression                                     
                            {$$=$1;}  ;
                
                
MacroExpression: Identifier LPARAN Expression CommaExpressionStar RPARAN        {char* temp=(char*)malloc((strlen($3)+strlen($4)+10)*sizeof(char));
                                                                                strcpy(temp,$3);strcat(temp,$4);
                                                                                $$=replace($1,temp,0);
                                                                                free($1);free($3);free($4);}
                                                                                
                 |    Identifier LPARAN RPARAN                                  { $$=replace($1,NULL,0);
                                                                                free($1);};
                                                                                
PrimaryExpression	:	        INT                                             {$$=(char*)malloc((strlen($1)+5)*sizeof(char));strcpy($$,$1);}

                            |	TRUE                                            {$$=(char*)malloc(10*sizeof(char));strcpy($$,"true");}
                           
                            |	FALSE                                           {$$=(char*)malloc(10*sizeof(char));strcpy($$,"false");}
                           
                            |	Identifier                                      {$$=$1;}
                            
                            |	THIS                                            {$$=(char*)malloc(10*sizeof(char));strcpy($$,"this");}
                            
                            |	NEW WORDINT LSPARAN Expression RSPARAN          {$$=(char*)malloc((strlen($4)+20)*sizeof(char));
                                                                                strcpy($$,"new ");strcat($$,"int [");strcat($$,$4);
                                                                                strcat($$,"]");free($4);}
                            
                            |	NEW Identifier LPARAN RPARAN                    {$$=(char*)malloc((strlen($2)+20)*sizeof(char));
                                                                                strcpy($$,"new ");strcat($$,$2);strcat($$,"()"); 
                                                                                free($2);}
                            
                            |	NOT Expression                                  {$$=(char*)malloc((strlen($2)+20)*sizeof(char));
                                                                                strcpy($$,"!");strcat($$,$2);free($2);}
                            
                            |	LPARAN Expression RPARAN                        {$$=(char*)malloc((strlen($2)+20)*sizeof(char));
                                                                                strcpy($$,"(");strcat($$,$2);strcat($$,")");free($2);}  ;
MacroDefinition	:	MacroDefExpression     
                    |	MacroDefStatement   ;
                    
MacroDefStatement	:	DEFINE Identifier LPARAN Identifier CommaIdentifierStar RPARAN LCPARAN  StatementStar RCPARAN 
                            {   char* temp=(char*)malloc((strlen($4)+strlen($5)+3)*sizeof(char));strcpy(temp,$4);strcat(temp,$5);
                                char* temp2=(char*)malloc((strlen($8)+5)*sizeof(char));strcpy(temp2,"{");strcat(temp2,$8);strcat(temp2,"}");
                                add_macro($2,temp,temp2,1);free($4);free($5);free($8);
                            } 
                        |  DEFINE Identifier LPARAN RPARAN LCPARAN  StatementStar RCPARAN  
                                {char* temp2=(char*)malloc((strlen($6)+5)*sizeof(char));strcpy(temp2,"{");strcat(temp2,$6);strcat(temp2,"}");
                                add_macro($2,NULL,temp2,1);free($6);};
                                
MacroDefExpression	:   DEFINE Identifier LPARAN Identifier CommaIdentifierStar RPARAN LPARAN Expression RPARAN
                        {   char* temp=(char*)malloc((strlen($4)+strlen($5)+3)*sizeof(char));strcpy(temp,$4);strcat(temp,$5);
                                char* temp2=(char*)malloc((strlen($8)+5)*sizeof(char));strcpy(temp2,"(");strcat(temp2,$8);strcat(temp2,")");
                                add_macro($2,temp,temp2,0);free($4);free($5);free($8);
                            } 
                        | DEFINE Identifier LPARAN  RPARAN LPARAN Expression RPARAN
                            {char* temp2=(char*)malloc((strlen($6)+5)*sizeof(char));strcpy(temp2,"(");strcat(temp2,$6);strcat(temp2,")");
                                add_macro($2,NULL,temp2,0);free($6);};

Identifier	:	IDENTIFIER                                                      {$$=(char*)malloc((strlen($1)+5)*sizeof(char));strcpy($$,$1);};


