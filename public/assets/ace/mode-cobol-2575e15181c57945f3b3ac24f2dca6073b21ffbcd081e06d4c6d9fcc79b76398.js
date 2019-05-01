define("ace/mode/cobol_highlight_rules",["require","exports","module","ace/lib/oop","ace/mode/text_highlight_rules"],function(E,e){"use strict";var o=E("../lib/oop"),t=E("./text_highlight_rules").TextHighlightRules,T=function(){var E="ACCEPT|MERGE|SUM|ADD||MESSAGE|TABLE|ADVANCING|MODE|TAPE|AFTER|MULTIPLY|TEST|ALL|NEGATIVE|TEXT|ALPHABET|NEXT|THAN|ALSO|NO|THEN|ALTERNATE|NOT|THROUGH|AND|NUMBER|THRU|ANY|OCCURS|TIME|ARE|OF|TO|AREA|OFF|TOP||ASCENDING|OMITTED|TRUE|ASSIGN|ON|TYPE|AT|OPEN|UNIT|AUTHOR|OR|UNTIL|BEFORE|OTHER|UP|BLANK|OUTPUT|USE|BLOCK|PAGE|USING|BOTTOM|PERFORM|VALUE|BY|PIC|VALUES|CALL|PICTURE|WHEN|CANCEL|PLUS|WITH|CD|POINTER|WRITE|CHARACTER|POSITION||ZERO|CLOSE|POSITIVE|ZEROS|COLUMN|PROCEDURE|ZEROES|COMMA|PROGRAM|COMMON|PROGRAM-ID|COMMUNICATION|QUOTE|COMP|RANDOM|COMPUTE|READ|CONTAINS|RECEIVE|CONFIGURATION|RECORD|CONTINUE|REDEFINES|CONTROL|REFERENCE|COPY|REMAINDER|COUNT|REPLACE|DATA|REPORT|DATE|RESERVE|DAY|RESET|DELETE|RETURN|DESTINATION|REWIND|DISABLE|REWRITE|DISPLAY|RIGHT|DIVIDE|RUN|DOWN|SAME|ELSE|SEARCH|ENABLE|SECTION|END|SELECT|ENVIRONMENT|SENTENCE|EQUAL|SET|ERROR|SIGN|EXIT|SEQUENTIAL|EXTERNAL|SIZE|FLASE|SORT|FILE|SOURCE|LENGTH|SPACE|LESS|STANDARD|LIMIT|START|LINE|STOP|LOCK|STRING|LOW-VALUE|SUBTRACT",e="true|false|null",o="count|min|max|avg|sum|rank|now|coalesce|main",t=this.createKeywordMapper({"support.function":o,keyword:E,"constant.language":e},"identifier",!0);this.$rules={start:[{token:"comment",regex:"\\*.*$"},{token:"string",regex:'".*?"'},{token:"string",regex:"'.*?'"},{token:"constant.numeric",regex:"[+-]?\\d+(?:(?:\\.\\d*)?(?:[eE][+-]?\\d+)?)?\\b"},{token:t,regex:"[a-zA-Z_$][a-zA-Z0-9_$]*\\b"},{token:"keyword.operator",regex:"\\+|\\-|\\/|\\/\\/|%|<@>|@>|<@|&|\\^|~|<|>|<=|=>|==|!=|<>|="},{token:"paren.lparen",regex:"[\\(]"},{token:"paren.rparen",regex:"[\\)]"},{token:"text",regex:"\\s+"}]}};o.inherits(T,t),e.CobolHighlightRules=T}),define("ace/mode/cobol",["require","exports","module","ace/lib/oop","ace/mode/text","ace/mode/cobol_highlight_rules"],function(E,e){"use strict";var o=E("../lib/oop"),t=E("./text").Mode,T=E("./cobol_highlight_rules").CobolHighlightRules,R=function(){this.HighlightRules=T,this.$behaviour=this.$defaultBehaviour};o.inherits(R,t),function(){this.lineCommentStart="*",this.$id="ace/mode/cobol"}.call(R.prototype),e.Mode=R}),function(){window.require(["ace/mode/cobol"],function(E){"object"==typeof module&&"object"==typeof exports&&module&&(module.exports=E)})}();