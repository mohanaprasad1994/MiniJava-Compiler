
%{
#include<stdio.h>
#include "P1.tab.h"

void yyerror(char *);
int yyparse();
%}

%%

[ \t\n]	; // ignore space


"\;"	                { /*printf(";\n");*/return SEMICOLON;}
"class"             { /*printf("class\n");*/return CLASS;}
"if"                {/*printf("if\n");*/return IF;}
"else"              {/*printf("else\n");*/return ELSE;}
"while"             {/*printf("while\n");*/return WHILE;}
"\("                 { /*printf("(\n");*/return LPARAN;}
"\)"                 { /*printf(")\n");*/return RPARAN;}
"\{"                 {/*printf("{\n");*/return LCPARAN;}
"\}"                 {/*printf("}\n");*/return RCPARAN;}
"\["                 {/*printf("[\n");*/return LSPARAN;}
"\]"                 {/*printf("]\n");*/return RSPARAN;}
"\<"                 {/*printf("<\n");*/return LESSTHAN;}
"\>"                 {/*printf(">\n");*/return GREATERTHAN;}
"\="                 { /*printf("=\n");*/return EQUALS;}
"\+"                 {/*printf("+\n");*/return PLUS;}
"\-"                 {/*printf("-\n");*/return MINUS;}
"\*"                 {/*printf("*\n");*/return STAR;}
"/"                 {/*printf("/\n");*/return DIV;}
"public"            {/*printf("Public\n");*/return PUBLIC;}
"static"            {/*printf("static\n");*/return STATIC;}
"void"              {/*printf("void\n");*/return VOID;}
"main"              {/*printf("main\n");*/return MAIN;}
"new"               {/*printf("new\n");*/return NEW;}
"false"             {/*printf("false\n");*/return FALSE;}
"true"              {/*printf("TRUE\n");*/return TRUE;}
"this"              {/*printf("THIS\n");*/return THIS;}
"int"               {/*printf("int\n");*/return WORDINT;}
"&"                 {/*printf("AND\n");*/return AND;}
"|"                 {/*printf("OR\n");*/return OR;}
"!"                 {/*printf("NOT\n");*/return NOT;}
"."                 {/*printf(".\n");*/return DOT;}
".length"           {/*printf(".length\n");*/return LENGTH;}
"System.out.println" {/*printf("System\n");*/return SYSTEM;}
"String"            {/*printf("String\n");*/return STRING;}
","                 {/*printf(",\n");*/return COMMA;}
"extends"           {/*printf("extends\n");*/return EXT;}
"return"            { /*printf("return\n");*/return RET;}
"boolean"           { /*printf("boolan\n");*/return BOOLE;}
"#define"           {/* printf("#define\n");*/return DEFINE;}
[a-zA-Z][a-zA-Z0-9_]*          { yylval.strval=strdup(yytext);/*printf("identifier %s\n",yytext);*/return IDENTIFIER;}
[1-9][0-9]*|0     { yylval.strval=strdup(yytext);/*printf("number %s\n",yytext);*/return INT;}
\/\/.*\n ;
\/\*.*\*\/ ;
. {printf("other h%s",yytext);return OTHER;}
%%

void yyerror(char *str) {
	fprintf(stderr,"// Failed to parse macrojava code.");
}
int yywrap() {return END;}
int main(){
	yyparse();
}
