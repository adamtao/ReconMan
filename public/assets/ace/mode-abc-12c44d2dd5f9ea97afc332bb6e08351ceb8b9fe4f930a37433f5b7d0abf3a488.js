define("ace/mode/abc_highlight_rules",["require","exports","module","ace/lib/oop","ace/mode/text_highlight_rules"],function(e,t){"use strict";var n=e("../lib/oop"),o=e("./text_highlight_rules").TextHighlightRules,i=function(){this.$rules={start:[{token:["zupfnoter.information.comment.line.percentage","information.keyword","in formation.keyword.embedded"],regex:"(%%%%)(hn\\.[a-z]*)(.*)",comment:"Instruction Comment"},{token:["information.comment.line.percentage","information.keyword.embedded"],regex:"(%%)(.*)",comment:"Instruction Comment"},{token:"comment.line.percentage",regex:"%.*",comment:"Comments"},{token:"barline.keyword.operator",regex:"[\\[:]*[|:][|\\]:]*(?:\\[?[0-9]+)?|\\[[0-9]+",comment:"Bar lines"},{token:["information.keyword.embedded","information.argument.string.unquoted"],regex:"(\\[[A-Za-z]:)([^\\]]*\\])",comment:"embedded Header lines"},{token:["information.keyword","information.argument.string.unquoted"],regex:"^([A-Za-z]:)([^%\\\\]*)",comment:"Header lines"},{token:["text","entity.name.function","string.unquoted","text"],regex:"(\\[)([A-Z]:)(.*?)(\\])",comment:"Inline fields"},{token:["accent.constant.language","pitch.constant.numeric","duration.constant.numeric"],regex:"([\\^=_]*)([A-Ga-gz][,']*)([0-9]*/*[><0-9]*)",comment:"Notes"},{token:"zupfnoter.jumptarget.string.quoted",regex:'[\\"!]\\^\\:.*?[\\"!]',comment:"Zupfnoter jumptarget"},{token:"zupfnoter.goto.string.quoted",regex:'[\\"!]\\^\\@.*?[\\"!]',comment:"Zupfnoter goto"},{token:"zupfnoter.annotation.string.quoted",regex:'[\\"!]\\^\\!.*?[\\"!]',comment:"Zupfnoter annoation"},{token:"zupfnoter.annotationref.string.quoted",regex:'[\\"!]\\^\\#.*?[\\"!]',comment:"Zupfnoter annotation reference"},{token:"chordname.string.quoted",regex:'[\\"!]\\^.*?[\\"!]',comment:"abc chord"},{token:"string.quoted",regex:'[\\"!].*?[\\"!]',comment:"abc annotation"}]},this.normalizeRules()};i.metaData={fileTypes:["abc"],name:"ABC",scopeName:"text.abcnotation"},n.inherits(i,o),t.ABCHighlightRules=i}),define("ace/mode/folding/cstyle",["require","exports","module","ace/lib/oop","ace/range","ace/mode/folding/fold_mode"],function(e,t){"use strict";var n=e("../../lib/oop"),c=e("../../range").Range,o=e("./fold_mode").FoldMode,i=t.FoldMode=function(e){e&&(this.foldingStartMarker=new RegExp(this.foldingStartMarker.source.replace(/\|[^|]*?$/,"|"+e.start)),this.foldingStopMarker=new RegExp(this.foldingStopMarker.source.replace(/\|[^|]*?$/,"|"+e.end)))};n.inherits(i,o),function(){this.foldingStartMarker=/([\{\[\(])[^\}\]\)]*$|^\s*(\/\*)/,this.foldingStopMarker=/^[^\[\{\(]*([\}\]\)])|^[\s\*]*(\*\/)/,this.singleLineBlockCommentRe=/^\s*(\/\*).*\*\/\s*$/,this.tripleStarBlockCommentRe=/^\s*(\/\*\*\*).*\*\/\s*$/,this.startRegionRe=/^\s*(\/\*|\/\/)#?region\b/,this._getFoldWidgetBase=this.getFoldWidget,this.getFoldWidget=function(e,t,n){var o=e.getLine(n);if(this.singleLineBlockCommentRe.test(o)&&!this.startRegionRe.test(o)&&!this.tripleStarBlockCommentRe.test(o))return"";var i=this._getFoldWidgetBase(e,t,n);return!i&&this.startRegionRe.test(o)?"start":i},this.getFoldWidgetRange=function(e,t,n,o){var i,r=e.getLine(n);if(this.startRegionRe.test(r))return this.getCommentRegionBlock(e,r,n);if(i=r.match(this.foldingStartMarker)){var a=i.index;if(i[1])return this.openingBracketBlock(e,i[1],n,a);var g=e.getCommentFoldRange(n,a+i[0].length,1);return g&&!g.isMultiLine()&&(o?g=this.getSectionRange(e,n):"all"!=t&&(g=null)),g}if("markbegin"!==t&&(i=r.match(this.foldingStopMarker))){a=i.index+i[0].length;return i[1]?this.closingBracketBlock(e,i[1],n,a):e.getCommentFoldRange(n,a,-1)}},this.getSectionRange=function(e,t){for(var n=e.getLine(t),o=n.search(/\S/),i=t,r=n.length,a=t+=1,g=e.getLength();++t<g;){var s=(n=e.getLine(t)).search(/\S/);if(-1!==s){if(s<o)break;var l=this.getFoldWidgetRange(e,"all",t);if(l){if(l.start.row<=i)break;if(l.isMultiLine())t=l.end.row;else if(o==s)break}a=t}}return new c(i,r,a,e.getLine(a).length)},this.getCommentRegionBlock=function(e,t,n){for(var o=t.search(/\s*$/),i=e.getLength(),r=n,a=/^\s*(?:\/\*|\/\/|--)#?(end)?region\b/,g=1;++n<i;){t=e.getLine(n);var s=a.exec(t);if(s&&(s[1]?g--:g++,!g))break}if(r<n)return new c(r,o,n,t.length)}}.call(i.prototype)}),define("ace/mode/abc",["require","exports","module","ace/lib/oop","ace/mode/text","ace/mode/abc_highlight_rules","ace/mode/folding/cstyle"],function(e,t){"use strict";var n=e("../lib/oop"),o=e("./text").Mode,i=e("./abc_highlight_rules").ABCHighlightRules,r=e("./folding/cstyle").FoldMode,a=function(){this.HighlightRules=i,this.foldingRules=new r,this.$behaviour=this.$defaultBehaviour};n.inherits(a,o),function(){this.$id="ace/mode/abc"}.call(a.prototype),t.Mode=a}),window.require(["ace/mode/abc"],function(e){"object"==typeof module&&"object"==typeof exports&&module&&(module.exports=e)});