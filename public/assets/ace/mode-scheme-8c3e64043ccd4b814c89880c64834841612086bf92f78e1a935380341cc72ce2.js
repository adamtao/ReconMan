define("ace/mode/scheme_highlight_rules",["require","exports","module","ace/lib/oop","ace/mode/text_highlight_rules"],function(e,t){"use strict";var n=e("../lib/oop"),i=e("./text_highlight_rules").TextHighlightRules,r=function(){var e="case|do|let|loop|if|else|when",t="eq?|eqv?|equal?|and|or|not|null?",n="#t|#f",i="cons|car|cdr|cond|lambda|lambda*|syntax-rules|format|set!|quote|eval|append|list|list?|member?|load",r=this.createKeywordMapper({"keyword.control":e,"keyword.operator":t,"constant.language":n,"support.function":i},"identifier",!0);this.$rules={start:[{token:"comment",regex:";.*$"},{token:["storage.type.function-type.scheme","text","entity.name.function.scheme"],regex:"(?:\\b(?:(define|define-syntax|define-macro))\\b)(\\s+)((?:\\w|\\-|\\!|\\?)*)"},{token:"punctuation.definition.constant.character.scheme",regex:"#:\\S+"},{token:["punctuation.definition.variable.scheme","variable.other.global.scheme","punctuation.definition.variable.scheme"],regex:"(\\*)(\\S*)(\\*)"},{token:"constant.numeric",regex:"#[xXoObB][0-9a-fA-F]+"},{token:"constant.numeric",regex:"[+-]?\\d+(?:(?:\\.\\d*)?(?:[eE][+-]?\\d+)?)?"},{token:r,regex:"[a-zA-Z_#][a-zA-Z0-9_\\-\\?\\!\\*]*"},{token:"string",regex:'"(?=.)',next:"qqstring"}],qqstring:[{token:"constant.character.escape.scheme",regex:"\\\\."},{token:"string",regex:'[^"\\\\]+',merge:!0},{token:"string",regex:"\\\\$",next:"qqstring",merge:!0},{token:"string",regex:'"|$',next:"start",merge:!0}]}};n.inherits(r,i),t.SchemeHighlightRules=r}),define("ace/mode/matching_parens_outdent",["require","exports","module","ace/range"],function(e,t){"use strict";var n=e("../range").Range,i=function(){};(function(){this.checkOutdent=function(e,t){return!!/^\s+$/.test(e)&&/^\s*\)/.test(t)},this.autoOutdent=function(e,t){var i=e.getLine(t),r=i.match(/^(\s*\))/);if(!r)return 0;var o=r[1].length,s=e.findMatchingBracket({row:t,column:o});if(!s||s.row==t)return 0;var a=this.$getIndent(e.getLine(s.row));e.replace(new n(t,0,t,o-1),a)},this.$getIndent=function(e){var t=e.match(/^(\s+)/);return t?t[1]:""}}).call(i.prototype),t.MatchingParensOutdent=i}),define("ace/mode/scheme",["require","exports","module","ace/lib/oop","ace/mode/text","ace/mode/scheme_highlight_rules","ace/mode/matching_parens_outdent"],function(e,t){"use strict";var n=e("../lib/oop"),i=e("./text").Mode,r=e("./scheme_highlight_rules").SchemeHighlightRules,o=e("./matching_parens_outdent").MatchingParensOutdent,s=function(){this.HighlightRules=r,this.$outdent=new o,this.$behaviour=this.$defaultBehaviour};n.inherits(s,i),function(){this.lineCommentStart=";",this.minorIndentFunctions=["define","lambda","define-macro","define-syntax","syntax-rules","define-record-type","define-structure"],this.$toIndent=function(e){return e.split("").map(function(e){return/\s/.exec(e)?e:" "}).join("")},this.$calculateIndent=function(e,t){for(var n,i,r=this.$getIndent(e),o=0,s=e.length-1;s>=0&&(i=e[s],"("===i?(o--,n=!0):"("===i||"["===i||"{"===i?(o--,n=!1):")"!==i&&"]"!==i&&"}"!==i||o++,!(o<0));s--);if(!(o<0&&n))return o<0&&!n?this.$toIndent(e.substring(0,s+1)):o>0?r=r.substring(0,r.length-t.length):r;s+=1;for(var a=s,c="";;){if(" "===(i=e[s])||"\t"===i)return-1!==this.minorIndentFunctions.indexOf(c)?this.$toIndent(e.substring(0,a-1)+t):this.$toIndent(e.substring(0,s+1));if(i===undefined)return this.$toIndent(e.substring(0,a-1)+t);c+=e[s],s++}},this.getNextLineIndent=function(e,t,n){return this.$calculateIndent(t,n)},this.checkOutdent=function(e,t,n){return this.$outdent.checkOutdent(t,n)},this.autoOutdent=function(e,t,n){this.$outdent.autoOutdent(t,n)},this.$id="ace/mode/scheme"}.call(s.prototype),t.Mode=s});