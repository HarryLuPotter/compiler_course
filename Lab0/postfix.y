%{
/*********************************************
实现中缀表达式到后缀表达式的转换
YACC file
**********************************************/
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<string.h>
#ifndef YYSTYPE
#define YYSTYPE char*
#endif
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

//TODO:给每个符号定义一个单词类别
%token ADD MINUS MUL DIV
%token NUMBER
%token LPAREN RPAREN


%left ADD MINUS
%left MUL DIV
%right UMINUS         

%%


lines   :       lines expr ';' { printf("%s\n", $2); }
        |       lines ';'
        |
        ;
//TODO:完善表达式的规则
expr    :       expr ADD expr   { $$ = (char *)malloc(50*sizeof(char)); strcpy($$, $1); strcat($$, $3); strcat($$, "+ "); }
        |       expr MINUS expr   { $$ = (char *)malloc(50*sizeof(char)); strcpy($$, $1); strcat($$, $3); strcat($$, "- ");}
        |       MINUS expr %prec UMINUS   {$$ = (char *)malloc(50*sizeof(char)); strcpy($$, "-"); strcat($$, $2); strcat($$, " ");}
        |       expr MUL expr   { $$ = (char *)malloc(50*sizeof(char)); strcpy($$, $1); strcat($$, $3); strcat($$, "* ");}
        |       expr DIV expr   { $$ = (char *)malloc(50*sizeof(char)); strcpy($$, $1); strcat($$, $3); strcat($$, "/ ");}
        |       LPAREN expr RPAREN      { $$ = (char *)malloc(50*sizeof(char)); strcpy($$,$2);}
        |       NUMBER  {$$ = (char *)malloc(50*sizeof(char)); strcpy($$, $1);strcat($$," ");}
        ;

%%  

// programs section

int yylex()
{
    int t;
    while(1){
        t=getchar();
        if(t==' '||t=='\t' || t == '\n'){
            //do noting
        }else if(isdigit(t)){
            //TODO:解析多位数字返回数字类型 
            yylval = (char*)malloc(sizeof(char) * 100);
            int idx = 0;
            while (isdigit(t))
            {
                yylval[idx++] = t;
                t = getchar();
            }
            yylval[idx] = '\0';
            ungetc(t, stdin); //yyin
            return NUMBER;
        }else if(t=='+'){
            return ADD;
        }else if(t=='-'){
            return MINUS;
        }//TODO:识别其他符号
        else if (t == '*')
        {
            return MUL;
        }
        else if (t == '/')
        {
            return DIV;
        }
        else if (t == '(')
        {
            return LPAREN;
        }
        else if (t == ')')
        {
            return RPAREN;
        }
        else{
            return t;
        }
    }
}

int main(void)
{
    yyin=stdin;
    do{
        yyparse();
    }while(!feof(yyin));
    return 0;
}
void yyerror(const char* s){
    fprintf(stderr,"Parse error: %s\n",s);
    exit(1);
}