import java_cup.runtime.*;

%%
%class Lexer
%unicode
%cup
%line
%column
%states IN_COMMENT
%{
  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
%}

Whitespace = [ ]|\r\n|\t|\r|\n|" "|"\t"
Letter = [a-zA-Z]
Digit = [0-9]
IdChar = {Letter} | {Digit} | "_"
Boolean = T | F
Identifier = {Letter}{IdChar}*
Integer = (0|[1-9]{Digit}*)
Rational = {Integer} "/" {Integer}
Float = {Integer} "." {Integer}
AllChars = {Whitespace} | {Letter} | {Digit} 
Comment = "#" .* | "/*" [^*\/]* "*/"
Character = \'.\'
String = \".*\"

%state YYINITIAL, COMMENT, TYPE
%%
<YYINITIAL> {  
  /* keywords */
  main        { return symbol(sym.MAIN);     }
  break       { return symbol(sym.BREAK);    }

  read        { return symbol(sym.READ);     }
  print       { return symbol(sym.PRINT);    }

  if          { return symbol(sym.IF);       }
  fi          { return symbol(sym.ENDIF);    }
  then        { return symbol(sym.THEN);     }
  else        { return symbol(sym.ELSE);     }

  loop        { return symbol(sym.LOOP);     }
  pool        { return symbol(sym.ENDLOOP);  }

  for         { return symbol(sym.FOR);      }
  in          { return symbol(sym.IN);       }
  range       { return symbol(sym.RANGE);    }

  fdef        { return symbol(sym.DEFFUNC);  }
  tdef        { return symbol(sym.DEFTYPE);  }
  alias       { return symbol(sym.ALIAS);    }

  T       { return symbol(sym.BOOLT);  }
  F       { return symbol(sym.BOOLF);    }
  
  lambda       { return symbol(sym.LAMBDA);    }

  int          { return symbol(sym.INT);    }
  rat          { return symbol(sym.RAT);    }
  bool         { return symbol(sym.BOOL);    }
  top          { return symbol(sym.TOP);    }
  string       { return symbol(sym.STRTYPE);    }
  char         { return symbol(sym.CHARTYPE);    }
  float        { return symbol(sym.FLOATTYPE);    }
  seq          { return symbol(sym.SEQTYPE);    }

  return       { return symbol(sym.RETURN);    }
  
  "."           { return symbol(sym.DOT); }
  "::"          { return symbol(sym.CONCAT); }
  "/#"          { yybegin(COMMENT);}
  ":="          { return symbol(sym.ASSIGNMENT); }
  "="           { return symbol(sym.EQ);   }
  "+"           { return symbol(sym.PLUS);       }
  "-"           { return symbol(sym.MINUS);      }
  "*"           { return symbol(sym.MULT);       }
  "/"           { return symbol(sym.DIV);        }
  "("           { return symbol(sym.LPAREN);     }
  ")"           { return symbol(sym.RPAREN);     }
  "["           { return symbol(sym.LSQ);     }
  "]"           { return symbol(sym.RSQ);     }
  "{"           { return symbol(sym.LCPAREN);    }
  "}"           { return symbol(sym.RCPAREN);    }
  ";"           { return symbol(sym.SEMICOL); }
  ":"           { return symbol(sym.COLON); }
  ","           { return symbol(sym.COMMA); }
  "||"          { return symbol(sym.OR); }
  "&&"          { return symbol(sym.AND); }
  "!"           { return symbol(sym.NOT); } 
  "<"           { return symbol(sym.LT); }
  ">"           { return symbol(sym.GT); }
  "<="          { return symbol(sym.LE); }
  ">="          { return symbol(sym.GE); }
  "!="          { return symbol(sym.NE); }

  /* Whitespace & Comments*/
  {Whitespace}  { /* do nothing */               }
  {Comment}     { /* do nothing */               }

  /* Identifiers */
  {Identifier}  { return symbol(sym.IDENTIFIER, yytext());   }

  /* Numbers */
  {Integer}     { return symbol(sym.INTEGER,
                                Integer.parseInt(yytext())); }
  {Rational}    { return symbol(sym.RATIONAL,yytext()); }
  {Float}       { return symbol(sym.FLOAT,yytext()); }     
  
  {Character}   { return symbol(sym.CHAR, yytext());   }
  {String}      { return symbol(sym.STRING, yytext());   } 

}

<COMMENT>{
  "#/"        {yybegin(YYINITIAL);}
  "\n"        {       }
  .           {       }
}

/* error fallback */
[^]  {
    System.out.println("Error in line "
        + (yyline+1) +": Invalid input '" + yytext()+"'");
    return symbol(sym.ILLEGAL_CHARACTER);
}
