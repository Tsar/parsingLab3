grammar Prefix;

@header {
import java.util.Set;
import java.util.HashSet;
import java.io.PrintWriter;
}

@members {
	PrintWriter out;
	String code;
	int codeOffset;
	boolean newLine;
	Set<String> varNames;

	void init() {
		try{
			out = new PrintWriter("output.cpp");
			out.print("#include <iostream>\n\n");
			out.print("int main() {\n");
		} catch (Exception e) {
		}
		codeOffset = 1;
		code = "";
		newLine = true;
		varNames = new HashSet<String>();
	}
	
	void deinit() {
		if (!varNames.isEmpty()) {
			out.print("    int ");
			boolean firstVar = true;
			for (String varName : varNames) {
				if (!firstVar) {
					out.print(", " + varName);
				} else {
					out.print(varName);
					firstVar = false;
				}
			}
			out.print(";\n");
		}
		out.print(code);
		out.print("    return 0;\n}\n");
		out.close();
	}

	void addCode(String s) {
		if (s.length() == 0)
			return;
		if (s.charAt(0) == '}')
			--codeOffset;
		if (newLine) {
			for (int i = 0; i < codeOffset; ++i)
				code += "    ";
		}
		code += s;
		if (s.length() > 1 && s.charAt(s.length() - 2) == '{')
			++codeOffset;
		if (s.charAt(s.length() - 1) == '\n')
			newLine = true;
		else
			newLine = false;
	}
}

s	:	{init();} B? expr* {deinit();};

expr	:	IF_OPERATOR {addCode("if ");} B bool_expr {addCode(" {\n");} B expr+
		(ELIF_OPERATOR {addCode("} else if ");} B bool_expr {addCode(" {\n");} B expr+)*
		(ELSE_OPERATOR {addCode("} else {\n");} B expr+)?
		ENDIF_OPERATOR {addCode("}\n");} B?
	|	PRINT_OPERATOR {addCode("std::cout << ");} B arithm_expr {addCode(";\n");} B?
	|	EQ_OPERATOR B? VARIABLE {varNames.add($VARIABLE.text); addCode($VARIABLE.text + " = ");} B arithm_expr {addCode(";\n");} B?;

bool_expr
	:	BOOL_BIN_OPERATOR {addCode("(");} B? arithm_expr {addCode(" " + $BOOL_BIN_OPERATOR.text + " ");} B arithm_expr {addCode(")");}
	|	NOT_OPERATOR {addCode("(!");} B? bool_expr {addCode(")");};

arithm_expr
	:	ARITHM_BIN_OPERATOR {addCode("(");} B? arithm_expr {addCode(" " + $ARITHM_BIN_OPERATOR.text + " ");} B arithm_expr {addCode(")");}
	|	NUMBER {addCode($NUMBER.text);}
	|	VARIABLE {varNames.add($VARIABLE.text); addCode($VARIABLE.text);};

ARITHM_BIN_OPERATOR
	:	'+'
	|	'-'
	|	'*'
	|	'/'
	|	'>>'
	|	'<<'
	|	'|'
	|	'&';

BOOL_BIN_OPERATOR
	:	'>='
	|	'<='
	|	'>'
	|	'<'
	|	'||'
	|	'&&';

NOT_OPERATOR
	:	'!';

EQ_OPERATOR
	:	'=';

IF_OPERATOR
	:	'if';

ELIF_OPERATOR
	:	'elif';

ELSE_OPERATOR
	:	'else';

ENDIF_OPERATOR
	:	'endif';

PRINT_OPERATOR
	:	'print';

NUMBER	:	('0'..'9')+;

VARIABLE:	('A'..'Z' | 'a'..'z' | '_')('A'..'Z' | 'a'..'z' | '_' | '0'..'9')+;

B	:	(' ' | '\n' | '\t')+;
