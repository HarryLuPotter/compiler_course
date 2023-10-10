%{
/*********************************************
将所有的词法分析功能均放在 yylex 函数内实现，为 +、-、*、\、(、 ) 每个运算符及整数分别定义一个单词类别，在 yylex 内实现代码，能
识别这些单词，并将单词类别返回给词法分析程序。
实现功能更强的词法分析程序，可识别并忽略空格、制表符、回车等
空白符，能识别多位十进制整数。
YACC file
**********************************************/
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<string.h>
#ifndef YYSTYPE
#define YYSTYPE int
#endif
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);

//
#define SYMTABSIZE 100

struct SymTabItem  //符号表项
{
    char *sym;
    int value;
};

int size = 0; //当前符号表的容量
struct SymTabItem SymTab[SYMTABSIZE]; //符号表

%}

//TODO:给每个符号定义一个单词类别
%token ADD MINUS MUL DIV
%token NUMBER
%token LPAREN RPAREN
%token ID  //标识符定义单词类别
%token EQUAL  //等号

%right EQUAL
%left ADD MINUS
%left MUL DIV
%right UMINUS         


%%


lines   :       lines expr ';' { printf("%d\n", $2); }
        |       lines ';'
        |
        ;
//TODO:完善表达式的规则
expr    :       expr ADD expr   { $$ = $1 + $3; }
        |       expr MINUS expr   { $$ = $1 - $3; }
        |       expr MUL expr   { $$ = $1 * $3; }
        |       expr DIV expr   { $$ = $1 / $3; }
        |       LPAREN expr RPAREN  { $$ = $2; }
        |       MINUS expr %prec UMINUS   { $$ = -$2; }
        |       NUMBER  

        |       ID              { $$ = SymTab[$1].value; }
        |       ID EQUAL expr  {SymTab[$1].value = $3; $$ = $3;}
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
            yylval = 0;
            while (isdigit(t))
            {
                yylval = 10 * yylval + t - '0';
                t = getchar();
            }
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
        else if (t == ';')
        {
            return t;
        }
        else if (t == '=')
        {
            return EQUAL;
        }
        else if (isalpha(t) || t == '_') //识别ID
        {
            char* curId = (char*)malloc(50 * sizeof(char)); //存当前识别的标识符
            int idx = 0;
            curId[idx++] = t;
            t = getchar();
            while (isalnum(t) || t == '_') //继续识别
            {
                curId[idx++] = t;
                t = getchar();
            }


            ungetc(t, stdin);
            curId[idx] = '\0';



            //查找符号表
            for (int i = 0; i < size; ++i)
            {
                if (strcmp(curId, SymTab[i].sym) == 0) //匹配上
                {
                    yylval = i;
                    return ID;
                }
            }
            //没匹配上
            yylval = size++;
            SymTab[yylval].sym = curId; //
            SymTab[yylval].value = 0; //初始化成0
            return ID;
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