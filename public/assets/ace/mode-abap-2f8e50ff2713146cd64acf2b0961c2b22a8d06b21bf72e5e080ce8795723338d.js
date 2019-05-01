define("ace/mode/abap_highlight_rules",["require","exports","module","ace/lib/oop","ace/mode/text_highlight_rules"],function(E,e){"use strict";var t=E("../lib/oop"),N=E("./text_highlight_rules").TextHighlightRules,T=function(){var E=this.createKeywordMapper({"variable.language":"this",keyword:"ADD ALIAS ALIASES ASCENDING ASSERT ASSIGN ASSIGNING AT BACK CALL CASE CATCH CHECK CLASS CLEAR CLOSE CNT COLLECT COMMIT COMMUNICATION COMPUTE CONCATENATE CONDENSE CONSTANTS CONTINUE CONTROLS CONVERT CREATE CURRENCY DATA DEFINE DEFINITION DEFERRED DELETE DESCENDING DESCRIBE DETAIL DIVIDE DO ELSE ELSEIF ENDAT ENDCASE ENDCLASS ENDDO ENDEXEC ENDFORM ENDFUNCTION ENDIF ENDIFEND ENDINTERFACE ENDLOOP ENDMETHOD ENDMODULE ENDON ENDPROVIDE ENDSELECT ENDTRY ENDWHILE EVENT EVENTS EXEC EXIT EXPORT EXPORTING EXTRACT FETCH FIELDS FORM FORMAT FREE FROM FUNCTION GENERATE GET HIDE IF IMPORT IMPORTING INDEX INFOTYPES INITIALIZATION INTERFACE INTERFACES INPUT INSERT IMPLEMENTATION LEAVE LIKE LINE LOAD LOCAL LOOP MESSAGE METHOD METHODS MODIFY MODULE MOVE MULTIPLY ON OVERLAY OPTIONAL OTHERS PACK PARAMETERS PERFORM POSITION PROGRAM PROVIDE PUT RAISE RANGES READ RECEIVE RECEIVING REDEFINITION REFERENCE REFRESH REJECT REPLACE REPORT RESERVE RESTORE RETURN RETURNING ROLLBACK SCAN SCROLL SEARCH SELECT SET SHIFT SKIP SORT SORTED SPLIT STANDARD STATICS STEP STOP SUBMIT SUBTRACT SUM SUMMARY SUPPRESS TABLES TIMES TRANSFER TRANSLATE TRY TYPE TYPES UNASSIGN ULINE UNPACK UPDATE WHEN WHILE WINDOW WRITE OCCURS STRUCTURE OBJECT PROPERTY CASTING APPEND RAISING VALUE COLOR CHANGING EXCEPTION EXCEPTIONS DEFAULT CHECKBOX COMMENT ID NUMBER FOR TITLE OUTPUT WITH EXIT USING INTO WHERE GROUP BY HAVING ORDER BY SINGLE APPENDING CORRESPONDING FIELDS OF TABLE LEFT RIGHT OUTER INNER JOIN AS CLIENT SPECIFIED BYPASSING BUFFER UP TO ROWS CONNECTING EQ NE LT LE GT GE NOT AND OR XOR IN LIKE BETWEEN","constant.language":"TRUE FALSE NULL SPACE","support.type":"c n i p f d t x string xstring decfloat16 decfloat34","keyword.operator":"abs sign ceil floor trunc frac acos asin atan cos sin tan abapOperator cosh sinh tanh exp log log10 sqrt strlen xstrlen charlen numofchar dbmaxlen lines"},"text",!0," ");this.$rules={start:[{token:"string",regex:"`",next:"string"},{token:"string",regex:"'",next:"qstring"},{token:"doc.comment",regex:/^\*.+/},{token:"comment",regex:/".+$/},{token:"invalid",regex:"\\.{2,}"},{token:"keyword.operator",regex:/\W[\-+%=<>*]\W|\*\*|[~:,\.&$]|->*?|=>/},{token:"paren.lparen",regex:"[\\[({]"},{token:"paren.rparen",regex:"[\\])}]"},{token:"constant.numeric",regex:"[+-]?\\d+\\b"},{token:"variable.parameter",regex:/sy|pa?\d\d\d\d\|t\d\d\d\.|innnn/},{token:"keyword",regex:"WITH\\W+(?:HEADER\\W+LINE|FRAME|KEY)|NO\\W+STANDARD\\W+PAGE\\W+HEADING|EXIT\\W+FROM\\W+STEP\\W+LOOP|BEGIN\\W+OF\\W+(?:BLOCK|LINE)|BEGIN\\W+OF|END\\W+OF\\W+(?:BLOCK|LINE)|END\\W+OF|NO\\W+INTERVALS|RESPECTING\\W+BLANKS|SEPARATED\\W+BY|USING\\W+(?:EDIT\\W+MASK)|WHERE\\W+(?:LINE)|RADIOBUTTON\\W+GROUP|REF\\W+TO|(?:PUBLIC|PRIVATE|PROTECTED)(?:\\W+SECTION)?|DELETING\\W+(?:TRAILING|LEADING)(?:ALL\\W+OCCURRENCES)|(?:FIRST|LAST)\\W+OCCURRENCE|INHERITING\\W+FROM|LINE-COUNT|ADD-CORRESPONDING|AUTHORITY-CHECK|BREAK-POINT|CLASS-DATA|CLASS-METHODS|CLASS-METHOD|DIVIDE-CORRESPONDING|EDITOR-CALL|END-OF-DEFINITION|END-OF-PAGE|END-OF-SELECTION|FIELD-GROUPS|FIELD-SYMBOLS|FUNCTION-POOL|MOVE-CORRESPONDING|MULTIPLY-CORRESPONDING|NEW-LINE|NEW-PAGE|NEW-SECTION|PRINT-CONTROL|RP-PROVIDE-FROM-LAST|SELECT-OPTIONS|SELECTION-SCREEN|START-OF-SELECTION|SUBTRACT-CORRESPONDING|SYNTAX-CHECK|SYNTAX-TRACE|TOP-OF-PAGE|TYPE-POOL|TYPE-POOLS|LINE-SIZE|LINE-COUNT|MESSAGE-ID|DISPLAY-MODE|READ(?:-ONLY)?|IS\\W+(?:NOT\\W+)?(?:ASSIGNED|BOUND|INITIAL|SUPPLIED)"},{token:"variable.parameter",regex:/\w+-\w[\-\w]*/},{token:E,regex:"\\b\\w+\\b"},{caseInsensitive:!0}],qstring:[{token:"constant.language.escape",regex:"''"},{token:"string",regex:"'",next:"start"},{defaultToken:"string"}],string:[{token:"constant.language.escape",regex:"``"},{token:"string",regex:"`",next:"start"},{defaultToken:"string"}]}};t.inherits(T,N),e.AbapHighlightRules=T}),define("ace/mode/folding/coffee",["require","exports","module","ace/lib/oop","ace/mode/folding/fold_mode","ace/range"],function(E,e){"use strict";var t=E("../../lib/oop"),N=E("./fold_mode").FoldMode,T=E("../../range").Range,I=e.FoldMode=function(){};t.inherits(I,N),function(){this.getFoldWidgetRange=function(E,e,t){var N=this.indentationBlock(E,t);if(N)return N;var I=/\S/,O=E.getLine(t),n=O.search(I);if(-1!=n&&"#"==O[n]){for(var R=O.length,S=E.getLength(),r=t,o=t;++t<S;){O=E.getLine(t);var i=O.search(I);if(-1!=i){if("#"!=O[i])break;o=t}}if(o>r){var A=E.getLine(o).length;return new T(r,R,o,A)}}},this.getFoldWidget=function(E,e,t){var N=E.getLine(t),T=N.search(/\S/),I=E.getLine(t+1),O=E.getLine(t-1),n=O.search(/\S/),R=I.search(/\S/);if(-1==T)return E.foldWidgets[t-1]=-1!=n&&n<R?"start":"","";if(-1==n){if(T==R&&"#"==N[T]&&"#"==I[T])return E.foldWidgets[t-1]="",E.foldWidgets[t+1]="","start"}else if(n==T&&"#"==N[T]&&"#"==O[T]&&-1==E.getLine(t-2).search(/\S/))return E.foldWidgets[t-1]="start",E.foldWidgets[t+1]="","";return E.foldWidgets[t-1]=-1!=n&&n<T?"start":"",T<R?"start":""}}.call(I.prototype)}),define("ace/mode/abap",["require","exports","module","ace/mode/abap_highlight_rules","ace/mode/folding/coffee","ace/range","ace/mode/text","ace/lib/oop"],function(E,e){"use strict";function t(){this.HighlightRules=N,this.foldingRules=new T}var N=E("./abap_highlight_rules").AbapHighlightRules,T=E("./folding/coffee").FoldMode,I=(E("../range").Range,E("./text").Mode);E("../lib/oop").inherits(t,I),function(){this.lineCommentStart='"',this.getNextLineIndent=function(E,e){return this.$getIndent(e)},this.$id="ace/mode/abap"}.call(t.prototype),e.Mode=t}),function(){window.require(["ace/mode/abap"],function(E){"object"==typeof module&&"object"==typeof exports&&module&&(module.exports=E)})}();