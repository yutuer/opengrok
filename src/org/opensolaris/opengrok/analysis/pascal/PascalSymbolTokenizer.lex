/*
 * CDDL HEADER START
 *
 * The contents of this file are subject to the terms of the
 * Common Development and Distribution License (the "License").  
 * You may not use this file except in compliance with the License.
 *
 * See LICENSE.txt included in this distribution for the specific
 * language governing permissions and limitations under the License.
 *
 * When distributing Covered Code, include this CDDL HEADER in each
 * file and include the License file at LICENSE.txt.
 * If applicable, add the following below this CDDL HEADER, with the
 * fields enclosed by brackets "[]" replaced with your own identifying
 * information: Portions Copyright [yyyy] [name of copyright owner]
 *
 * CDDL HEADER END
 */

/*
 * Copyright (c) 2016, Oracle and/or its affiliates. All rights reserved.
 * Portions Copyright (c) 2017, Chris Fraire <cfraire@me.com>.
 */

/*
 * Gets Pascal symbols - ignores comments, strings, keywords
 */

package org.opensolaris.opengrok.analysis.pascal;

import org.opensolaris.opengrok.analysis.JFlexSymbolMatcher;
%%
%public
%class PascalSymbolTokenizer
%extends JFlexSymbolMatcher
%init{
    yyline = 1;
%init}
%unicode
%int
%include CommonLexer.lexh
%char

Identifier = [a-zA-Z_] [a-zA-Z0-9_]*

%state STRING COMMENT SCOMMENT QSTRING

%%

<YYINITIAL> {
{Identifier} {String id = yytext();
                if(!Consts.kwd.contains(id)){
                        onSymbolMatched(id, yychar);
                        return yystate(); }
              }
 \"     { yybegin(STRING); }
 \'     { yybegin(QSTRING); }
 \{     { yybegin(COMMENT); }
 "//"   { yybegin(SCOMMENT); }
}

<STRING> {
 \"     { yybegin(YYINITIAL); }
}

<QSTRING> {
 \'     { yybegin(YYINITIAL); }
}

<COMMENT> {
\}    { yybegin(YYINITIAL);}
}

<SCOMMENT> {
\n      { yybegin(YYINITIAL);}
}

<YYINITIAL, STRING, COMMENT, SCOMMENT, QSTRING> {
[^]    {}
}
