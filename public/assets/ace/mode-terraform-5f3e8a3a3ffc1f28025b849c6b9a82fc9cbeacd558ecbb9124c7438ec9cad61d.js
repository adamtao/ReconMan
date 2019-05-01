define("ace/mode/terraform_highlight_rules",["require","exports","module","ace/lib/oop","ace/mode/text_highlight_rules"],function(e,t){"use strict";var r=e("../lib/oop"),n=e("./text_highlight_rules").TextHighlightRules,o=function(){this.$rules={start:[{token:["storage.function.terraform"],regex:"\\b(output|resource|data|variable|module|export)\\b"},{token:"variable.terraform",regex:"\\$\\s",push:[{token:"keyword.terraform",regex:"(-var-file|-var)"},{token:"variable.terraform",regex:"\\n|$",next:"pop"},{include:"strings"},{include:"variables"},{include:"operators"},{defaultToken:"text"}]},{token:"language.support.class",regex:"\\b(timeouts|provider|connection|provisioner|lifecycleprovider|atlas)\\b"},{token:"singleline.comment.terraform",regex:"#(.)*$"},{token:"multiline.comment.begin.terraform",regex:"^\\s*\\/\\*",push:"blockComment"},{token:"storage.function.terraform",regex:"^\\s*(locals|terraform)\\s*{"},{token:"paren.lpar",regex:"[[({]"},{token:"paren.rpar",regex:"[\\])}]"},{include:"constants"},{include:"strings"},{include:"operators"},{include:"variables"}],blockComment:[{regex:"^\\s*\\/\\*",token:"multiline.comment.begin.terraform",push:"blockComment"},{regex:"\\*\\/\\s*$",token:"multiline.comment.end.terraform",next:"pop"},{defaultToken:"comment"}],constants:[{token:"constant.language.terraform",regex:"\\b(true|false|yes|no|on|off|EOF)\\b"},{token:"constant.numeric.terraform",regex:"(\\b([0-9]+)([kKmMgG]b?)?\\b)|(\\b(0x[0-9A-Fa-f]+)([kKmMgG]b?)?\\b)"}],variables:[{token:["variable.assignment.terraform","keyword.operator"],regex:"\\b([a-zA-Z_]+)(\\s*=)"}],interpolated_variables:[{token:"variable.terraform",regex:"\\b(var|self|count|path|local)\\b(?:\\.*[a-zA-Z_-]*)?"}],strings:[{token:"punctuation.quote.terraform",regex:"'",push:[{token:"punctuation.quote.terraform",regex:"'",next:"pop"},{include:"escaped_chars"},{defaultToken:"string"}]},{token:"punctuation.quote.terraform",regex:'"',push:[{token:"punctuation.quote.terraform",regex:'"',next:"pop"},{include:"interpolation"},{include:"escaped_chars"},{defaultToken:"string"}]}],escaped_chars:[{token:"constant.escaped_char.terraform",regex:"\\\\."}],operators:[{token:"keyword.operator",regex:"\\?|:|==|!=|>|<|>=|<=|&&|\\|\\||!|%|&|\\*|\\+|\\-|/|="}],interpolation:[{token:"punctuation.interpolated.begin.terraform",regex:"\\$?\\$\\{",push:[{token:"punctuation.interpolated.end.terraform",regex:"\\}",next:"pop"},{include:"interpolated_variables"},{include:"operators"},{include:"constants"},{include:"strings"},{include:"functions"},{include:"parenthesis"},{defaultToken:"punctuation"}]}],functions:[{token:"keyword.function.terraform",regex:"\\b(abs|basename|base64decode|base64encode|base64gzip|base64sha256|base64sha512|bcrypt|ceil|chomp|chunklist|cidrhost|cidrnetmask|cidrsubnet|coalesce|coalescelist|compact|concat|contains|dirname|distinct|element|file|floor|flatten|format|formatlist|indent|index|join|jsonencode|keys|length|list|log|lookup|lower|map|matchkeys|max|merge|min|md5|pathexpand|pow|replace|rsadecrypt|sha1|sha256|sha512|signum|slice|sort|split|substr|timestamp|timeadd|title|transpose|trimspace|upper|urlencode|uuid|values|zipmap)\\b"}],parenthesis:[{token:"paren.lpar",regex:"\\["},{token:"paren.rpar",regex:"\\]"}]},this.normalizeRules()};r.inherits(o,n),t.TerraformHighlightRules=o}),define("ace/mode/folding/cstyle",["require","exports","module","ace/lib/oop","ace/range","ace/mode/folding/fold_mode"],function(e,t){"use strict";var r=e("../../lib/oop"),n=e("../../range").Range,o=e("./fold_mode").FoldMode,i=t.FoldMode=function(e){e&&(this.foldingStartMarker=new RegExp(this.foldingStartMarker.source.replace(/\|[^|]*?$/,"|"+e.start)),this.foldingStopMarker=new RegExp(this.foldingStopMarker.source.replace(/\|[^|]*?$/,"|"+e.end)))};r.inherits(i,o),function(){this.foldingStartMarker=/([\{\[\(])[^\}\]\)]*$|^\s*(\/\*)/,this.foldingStopMarker=/^[^\[\{\(]*([\}\]\)])|^[\s\*]*(\*\/)/,this.singleLineBlockCommentRe=/^\s*(\/\*).*\*\/\s*$/,this.tripleStarBlockCommentRe=/^\s*(\/\*\*\*).*\*\/\s*$/,this.startRegionRe=/^\s*(\/\*|\/\/)#?region\b/,this._getFoldWidgetBase=this.getFoldWidget,this.getFoldWidget=function(e,t,r){var n=e.getLine(r);if(this.singleLineBlockCommentRe.test(n)&&!this.startRegionRe.test(n)&&!this.tripleStarBlockCommentRe.test(n))return"";var o=this._getFoldWidgetBase(e,t,r);return!o&&this.startRegionRe.test(n)?"start":o},this.getFoldWidgetRange=function(e,t,r,n){var o=e.getLine(r);if(this.startRegionRe.test(o))return this.getCommentRegionBlock(e,o,r);var i=o.match(this.foldingStartMarker);if(i){var a=i.index;if(i[1])return this.openingBracketBlock(e,i[1],r,a);var s=e.getCommentFoldRange(r,a+i[0].length,1);return s&&!s.isMultiLine()&&(n?s=this.getSectionRange(e,r):"all"!=t&&(s=null)),s}if("markbegin"!==t){var i=o.match(this.foldingStopMarker);if(i){var a=i.index+i[0].length;return i[1]?this.closingBracketBlock(e,i[1],r,a):e.getCommentFoldRange(r,a,-1)}}},this.getSectionRange=function(e,t){var r=e.getLine(t),o=r.search(/\S/),i=t,a=r.length;t+=1;for(var s=t,l=e.getLength();++t<l;){r=e.getLine(t);var c=r.search(/\S/);if(-1!==c){if(o>c)break;var g=this.getFoldWidgetRange(e,"all",t);if(g){if(g.start.row<=i)break;if(g.isMultiLine())t=g.end.row;else if(o==c)break}s=t}}return new n(i,a,s,e.getLine(s).length)},this.getCommentRegionBlock=function(e,t,r){for(var o=t.search(/\s*$/),i=e.getLength(),a=r,s=/^\s*(?:\/\*|\/\/|--)#?(end)?region\b/,l=1;++r<i;){t=e.getLine(r);var c=s.exec(t);if(c&&(c[1]?l--:l++,!l))break}var g=r;if(g>a)return new n(a,o,g,t.length)}}.call(i.prototype)}),define("ace/mode/matching_brace_outdent",["require","exports","module","ace/range"],function(e,t){"use strict";var r=e("../range").Range,n=function(){};(function(){this.checkOutdent=function(e,t){return!!/^\s+$/.test(e)&&/^\s*\}/.test(t)},this.autoOutdent=function(e,t){var n=e.getLine(t),o=n.match(/^(\s*\})/);if(!o)return 0;var i=o[1].length,a=e.findMatchingBracket({row:t,column:i});if(!a||a.row==t)return 0;var s=this.$getIndent(e.getLine(a.row));e.replace(new r(t,0,t,i-1),s)},this.$getIndent=function(e){return e.match(/^\s*/)[0]}}).call(n.prototype),t.MatchingBraceOutdent=n}),define("ace/mode/terraform",["require","exports","module","ace/lib/oop","ace/mode/text","ace/mode/terraform_highlight_rules","ace/mode/behaviour/cstyle","ace/mode/folding/cstyle","ace/mode/matching_brace_outdent"],function(e,t){"use strict";var r=e("../lib/oop"),n=e("./text").Mode,o=e("./terraform_highlight_rules").TerraformHighlightRules,i=e("./behaviour/cstyle").CstyleBehaviour,a=e("./folding/cstyle").FoldMode,s=e("./matching_brace_outdent").MatchingBraceOutdent,l=function(){n.call(this),this.HighlightRules=o,this.$outdent=new s,this.$behaviour=new i,this.foldingRules=new a};r.inherits(l,n),function(){this.$id="ace/mode/terraform"}.call(l.prototype),t.Mode=l}),function(){window.require(["ace/mode/terraform"],function(e){"object"==typeof module&&"object"==typeof exports&&module&&(module.exports=e)})}();