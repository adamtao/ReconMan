define("ace/mode/sh_highlight_rules",["require","exports","module","ace/lib/oop","ace/mode/text_highlight_rules"],function(e,t){"use strict";var n=e("../lib/oop"),r=e("./text_highlight_rules").TextHighlightRules,i=t.reservedKeywords="!|{|}|case|do|done|elif|else|esac|fi|for|if|in|then|until|while|&|;|export|local|read|typeset|unset|elif|select|set|function|declare|readonly",o=t.languageConstructs="[|]|alias|bg|bind|break|builtin|cd|command|compgen|complete|continue|dirs|disown|echo|enable|eval|exec|exit|fc|fg|getopts|hash|help|history|jobs|kill|let|logout|popd|printf|pushd|pwd|return|set|shift|shopt|source|suspend|test|times|trap|type|ulimit|umask|unalias|wait",s=function(){var e=this.createKeywordMapper({keyword:i,"support.function.builtin":o,"invalid.deprecated":"debugger"},"identifier"),t="(?:\\.\\d+)",n="(?:\\d+)",r="(?:(?:"+n+"?"+t+")|(?:"+n+"\\.))",s="(?:(?:"+r+"|"+n+"))",a="(?:"+s+"|"+r+")",l="(?:&"+n+")",g="[a-zA-Z_][a-zA-Z0-9_]*",h="(?:"+g+"(?==))",c="(?:"+g+"\\s*\\(\\))";this.$rules={start:[{token:"constant",regex:/\\./},{token:["text","comment"],regex:/(^|\s)(#.*)$/},{token:"string.start",regex:'"',push:[{token:"constant.language.escape",regex:/\\(?:[$`"\\]|$)/},{include:"variables"},{token:"keyword.operator",regex:/`/},{token:"string.end",regex:'"',next:"pop"},{defaultToken:"string"}]},{token:"string",regex:"\\$'",push:[{token:"constant.language.escape",regex:/\\(?:[abeEfnrtv\\'"]|x[a-fA-F\d]{1,2}|u[a-fA-F\d]{4}([a-fA-F\d]{4})?|c.|\d{1,3})/},{token:"string",regex:"'",next:"pop"},{defaultToken:"string"}]},{regex:"<<<",token:"keyword.operator"},{stateName:"heredoc",regex:"(<<-?)(\\s*)(['\"`]?)([\\w\\-]+)(['\"`]?)",onMatch:function(e,t,n){var r="-"==e[2]?"indentedHeredoc":"heredoc",i=e.split(this.splitRegex);return n.push(r,i[4]),[{type:"constant",value:i[1]},{type:"text",value:i[2]},{type:"string",value:i[3]},{type:"support.class",value:i[4]},{type:"string",value:i[5]}]},rules:{heredoc:[{onMatch:function(e,t,n){return e===n[1]?(n.shift(),n.shift(),this.next=n[0]||"start","support.class"):(this.next="","string")},regex:".*$",next:"start"}],indentedHeredoc:[{token:"string",regex:"^\t+"},{onMatch:function(e,t,n){return e===n[1]?(n.shift(),n.shift(),this.next=n[0]||"start","support.class"):(this.next="","string")},regex:".*$",next:"start"}]}},{regex:"$",token:"empty",next:function(e,t){return"heredoc"===t[0]||"indentedHeredoc"===t[0]?t[0]:e}},{token:["keyword","text","text","text","variable"],regex:/(declare|local|readonly)(\s+)(?:(-[fixar]+)(\s+))?([a-zA-Z_][a-zA-Z0-9_]*\b)/},{token:"variable.language",regex:"(?:\\$(?:SHLVL|\\$|\\!|\\?))"},{token:"variable",regex:h},{include:"variables"},{token:"support.function",regex:c},{token:"support.function",regex:l},{token:"string",start:"'",end:"'"},{token:"constant.numeric",regex:a},{token:"constant.numeric",regex:"(?:(?:[1-9]\\d*)|(?:0))\\b"},{token:e,regex:"[a-zA-Z_][a-zA-Z0-9_]*\\b"},{token:"keyword.operator",regex:"\\+|\\-|\\*|\\*\\*|\\/|\\/\\/|~|<|>|<=|=>|=|!=|[%&|`]"},{token:"punctuation.operator",regex:";"},{token:"paren.lparen",regex:"[\\[\\(\\{]"},{token:"paren.rparen",regex:"[\\]]"},{token:"paren.rparen",regex:"[\\)\\}]",next:"pop"}],variables:[{token:"variable",regex:/(\$)(\w+)/},{token:["variable","paren.lparen"],regex:/(\$)(\()/,push:"start"},{token:["variable","paren.lparen","keyword.operator","variable","keyword.operator"],regex:/(\$)(\{)([#!]?)(\w+|[*@#?\-$!0_])(:[?+\-=]?|##?|%%?|,,?\/|\^\^?)?/,push:"start"},{token:"variable",regex:/\$[*@#?\-$!0_]/},{token:["variable","paren.lparen"],regex:/(\$)(\{)/,push:"start"}]},this.normalizeRules()};n.inherits(s,r),t.ShHighlightRules=s}),define("ace/mode/folding/cstyle",["require","exports","module","ace/lib/oop","ace/range","ace/mode/folding/fold_mode"],function(e,t){"use strict";var n=e("../../lib/oop"),r=e("../../range").Range,i=e("./fold_mode").FoldMode,o=t.FoldMode=function(e){e&&(this.foldingStartMarker=new RegExp(this.foldingStartMarker.source.replace(/\|[^|]*?$/,"|"+e.start)),this.foldingStopMarker=new RegExp(this.foldingStopMarker.source.replace(/\|[^|]*?$/,"|"+e.end)))};n.inherits(o,i),function(){this.foldingStartMarker=/([\{\[\(])[^\}\]\)]*$|^\s*(\/\*)/,this.foldingStopMarker=/^[^\[\{\(]*([\}\]\)])|^[\s\*]*(\*\/)/,this.singleLineBlockCommentRe=/^\s*(\/\*).*\*\/\s*$/,this.tripleStarBlockCommentRe=/^\s*(\/\*\*\*).*\*\/\s*$/,this.startRegionRe=/^\s*(\/\*|\/\/)#?region\b/,this._getFoldWidgetBase=this.getFoldWidget,this.getFoldWidget=function(e,t,n){var r=e.getLine(n);if(this.singleLineBlockCommentRe.test(r)&&!this.startRegionRe.test(r)&&!this.tripleStarBlockCommentRe.test(r))return"";var i=this._getFoldWidgetBase(e,t,n);return!i&&this.startRegionRe.test(r)?"start":i},this.getFoldWidgetRange=function(e,t,n,r){var i=e.getLine(n);if(this.startRegionRe.test(i))return this.getCommentRegionBlock(e,i,n);var o=i.match(this.foldingStartMarker);if(o){var s=o.index;if(o[1])return this.openingBracketBlock(e,o[1],n,s);var a=e.getCommentFoldRange(n,s+o[0].length,1);return a&&!a.isMultiLine()&&(r?a=this.getSectionRange(e,n):"all"!=t&&(a=null)),a}if("markbegin"!==t){var o=i.match(this.foldingStopMarker);if(o){var s=o.index+o[0].length;return o[1]?this.closingBracketBlock(e,o[1],n,s):e.getCommentFoldRange(n,s,-1)}}},this.getSectionRange=function(e,t){var n=e.getLine(t),i=n.search(/\S/),o=t,s=n.length;t+=1;for(var a=t,l=e.getLength();++t<l;){n=e.getLine(t);var g=n.search(/\S/);if(-1!==g){if(i>g)break;var h=this.getFoldWidgetRange(e,"all",t);if(h){if(h.start.row<=o)break;if(h.isMultiLine())t=h.end.row;else if(i==g)break}a=t}}return new r(o,s,a,e.getLine(a).length)},this.getCommentRegionBlock=function(e,t,n){for(var i=t.search(/\s*$/),o=e.getLength(),s=n,a=/^\s*(?:\/\*|\/\/|--)#?(end)?region\b/,l=1;++n<o;){t=e.getLine(n);var g=a.exec(t);if(g&&(g[1]?l--:l++,!l))break}var h=n;if(h>s)return new r(s,i,h,t.length)}}.call(o.prototype)}),define("ace/mode/sh",["require","exports","module","ace/lib/oop","ace/mode/text","ace/mode/sh_highlight_rules","ace/range","ace/mode/folding/cstyle","ace/mode/behaviour/cstyle"],function(e,t){"use strict";var n=e("../lib/oop"),r=e("./text").Mode,i=e("./sh_highlight_rules").ShHighlightRules,o=e("../range").Range,s=e("./folding/cstyle").FoldMode,a=e("./behaviour/cstyle").CstyleBehaviour,l=function(){this.HighlightRules=i,this.foldingRules=new s,this.$behaviour=new a};n.inherits(l,r),function(){this.lineCommentStart="#",this.getNextLineIndent=function(e,t,n){var r=this.$getIndent(t),i=this.getTokenizer().getLineTokens(t,e),o=i.tokens;if(o.length&&"comment"==o[o.length-1].type)return r;if("start"==e){t.match(/^.*[\{\(\[:]\s*$/)&&(r+=n)}return r};var e={pass:1,"return":1,raise:1,"break":1,"continue":1};this.checkOutdent=function(t,n,r){if("\r\n"!==r&&"\r"!==r&&"\n"!==r)return!1;var i=this.getTokenizer().getLineTokens(n.trim(),t).tokens;if(!i)return!1;do{var o=i.pop()}while(o&&("comment"==o.type||"text"==o.type&&o.value.match(/^\s+$/)));return!!o&&("keyword"==o.type&&e[o.value])},this.autoOutdent=function(e,t,n){n+=1;var r=this.$getIndent(t.getLine(n)),i=t.getTabString();r.slice(-i.length)==i&&t.remove(new o(n,r.length-i.length,n,r.length))},this.$id="ace/mode/sh"}.call(l.prototype),t.Mode=l}),define("ace/mode/dockerfile_highlight_rules",["require","exports","module","ace/lib/oop","ace/mode/sh_highlight_rules"],function(e,t){"use strict";var n=e("../lib/oop"),r=e("./sh_highlight_rules").ShHighlightRules,i=function(){r.call(this);for(var e=this.$rules.start,t=0;t<e.length;t++)if("variable.language"==e[t].token){e.splice(t,0,{token:"constant.language",regex:"(?:^(?:FROM|MAINTAINER|RUN|CMD|EXPOSE|ENV|ADD|ENTRYPOINT|VOLUME|USER|WORKDIR|ONBUILD|COPY|LABEL)\\b)",caseInsensitive:!0});break}};n.inherits(i,r),t.DockerfileHighlightRules=i}),define("ace/mode/dockerfile",["require","exports","module","ace/lib/oop","ace/mode/sh","ace/mode/dockerfile_highlight_rules","ace/mode/folding/cstyle"],function(e,t){"use strict";var n=e("../lib/oop"),r=e("./sh").Mode,i=e("./dockerfile_highlight_rules").DockerfileHighlightRules,o=e("./folding/cstyle").FoldMode,s=function(){r.call(this),this.HighlightRules=i,this.foldingRules=new o};n.inherits(s,r),function(){this.$id="ace/mode/dockerfile"}.call(s.prototype),t.Mode=s}),function(){window.require(["ace/mode/dockerfile"],function(e){"object"==typeof module&&"object"==typeof exports&&module&&(module.exports=e)})}();