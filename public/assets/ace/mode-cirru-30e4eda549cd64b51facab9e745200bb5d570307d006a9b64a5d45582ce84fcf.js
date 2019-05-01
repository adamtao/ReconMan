define("ace/mode/cirru_highlight_rules",["require","exports","module","ace/lib/oop","ace/mode/text_highlight_rules"],function(e,t){"use strict";var r=e("../lib/oop"),o=e("./text_highlight_rules").TextHighlightRules,i=function(){this.$rules={start:[{token:"constant.numeric",regex:/[\d\.]+/},{token:"comment.line.double-dash",regex:/--/,next:"comment"},{token:"storage.modifier",regex:/\(/},{token:"storage.modifier",regex:/,/,next:"line"},{token:"support.function",regex:/[^\(\)"\s]+/,next:"line"},{token:"string.quoted.double",regex:/"/,next:"string"},{token:"storage.modifier",regex:/\)/}],comment:[{token:"comment.line.double-dash",regex:/ +[^\n]+/,next:"start"}],string:[{token:"string.quoted.double",regex:/"/,next:"line"},{token:"constant.character.escape",regex:/\\/,next:"escape"},{token:"string.quoted.double",regex:/[^\\"]+/}],escape:[{token:"constant.character.escape",regex:/./,next:"string"}],line:[{token:"constant.numeric",regex:/[\d\.]+/},{token:"markup.raw",regex:/^\s*/,next:"start"},{token:"storage.modifier",regex:/\$/,next:"start"},{token:"variable.parameter",regex:/[^\(\)"\s]+/},{token:"storage.modifier",regex:/\(/,next:"start"},{token:"storage.modifier",regex:/\)/},{token:"markup.raw",regex:/^ */,next:"start"},{token:"string.quoted.double",regex:/"/,next:"string"}]}};r.inherits(i,o),t.CirruHighlightRules=i}),define("ace/mode/folding/coffee",["require","exports","module","ace/lib/oop","ace/mode/folding/fold_mode","ace/range"],function(e,t){"use strict";var r=e("../../lib/oop"),o=e("./fold_mode").FoldMode,i=e("../../range").Range,n=t.FoldMode=function(){};r.inherits(n,o),function(){this.getFoldWidgetRange=function(e,t,r){var o=this.indentationBlock(e,r);if(o)return o;var n=/\S/,s=e.getLine(r),g=s.search(n);if(-1!=g&&"#"==s[g]){for(var a=s.length,d=e.getLength(),l=r,u=r;++r<d;){s=e.getLine(r);var c=s.search(n);if(-1!=c){if("#"!=s[c])break;u=r}}if(u>l){var f=e.getLine(u).length;return new i(l,a,u,f)}}},this.getFoldWidget=function(e,t,r){var o=e.getLine(r),i=o.search(/\S/),n=e.getLine(r+1),s=e.getLine(r-1),g=s.search(/\S/),a=n.search(/\S/);if(-1==i)return e.foldWidgets[r-1]=-1!=g&&g<a?"start":"","";if(-1==g){if(i==a&&"#"==o[i]&&"#"==n[i])return e.foldWidgets[r-1]="",e.foldWidgets[r+1]="","start"}else if(g==i&&"#"==o[i]&&"#"==s[i]&&-1==e.getLine(r-2).search(/\S/))return e.foldWidgets[r-1]="start",e.foldWidgets[r+1]="","";return e.foldWidgets[r-1]=-1!=g&&g<i?"start":"",i<a?"start":""}}.call(n.prototype)}),define("ace/mode/cirru",["require","exports","module","ace/lib/oop","ace/mode/text","ace/mode/cirru_highlight_rules","ace/mode/folding/coffee"],function(e,t){"use strict";var r=e("../lib/oop"),o=e("./text").Mode,i=e("./cirru_highlight_rules").CirruHighlightRules,n=e("./folding/coffee").FoldMode,s=function(){this.HighlightRules=i,this.foldingRules=new n,this.$behaviour=this.$defaultBehaviour};r.inherits(s,o),function(){this.lineCommentStart="--",this.$id="ace/mode/cirru"}.call(s.prototype),t.Mode=s}),function(){window.require(["ace/mode/cirru"],function(e){"object"==typeof module&&"object"==typeof exports&&module&&(module.exports=e)})}();