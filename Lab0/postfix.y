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


lines   :       lines expr '\n' { printf("%s\n", $2); }
        |       lines '\n'
        |
        ;
//TODO:完善表达式的规则
expr    :       expr ADD expr   { strcpy($$,$1);strcat($$, " ");strcat($$,$3);strcat($$, " ");strcat($$,"+"); }
        |       expr MINUS expr   { strcpy($$,$1);strcat($$, " ");strcat($$,$3);strcat($$, " ");strcat($$,"-"); }
        |       expr MUL expr   { strcpy($$,$1);strcat($$, " ");strcat($$,$3);strcat($$, " ");strcat($$,"*"); }
        |       expr DIV expr   { strcpy($$,$1);strcat($$, " ");strcat($$,$3);strcat($$, " ");strcat($$,"/"); }
        |       LPAREN expr RPAREN  { strcpy($$,$2); }
        |       MINUS expr %prec UMINUS   { strcpy($$,$2);strcat($$, " ");strcat($$,"minus"); }
        |       NUMBER  { strcpy($$,$1); }
        ;

%%  

// programs section

int yylex()
{
    int t;
    while(1){
        t=getchar();
        if (t == '\n') return t;
        if(t==' '||t=='\t'){
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