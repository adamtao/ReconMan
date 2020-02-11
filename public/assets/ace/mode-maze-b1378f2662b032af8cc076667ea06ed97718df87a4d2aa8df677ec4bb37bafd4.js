define("ace/mode/maze_highlight_rules",["require","exports","module","ace/lib/oop","ace/mode/text_highlight_rules"],function(e,t){"use strict";var o=e("../lib/oop"),n=e("./text_highlight_rules").TextHighlightRules,r=function(){this.$rules={start:[{token:"keyword.control",regex:/##|``/,comment:"Wall"},{token:"entity.name.tag",regex:/\.\./,comment:"Path"},{token:"keyword.control",regex:/<>/,comment:"Splitter"},{token:"entity.name.tag",regex:/\*[\*A-Za-z0-9]/,comment:"Signal"},{token:"constant.numeric",regex:/[0-9]{2}/,comment:"Pause"},{token:"keyword.control",regex:/\^\^/,comment:"Start"},{token:"keyword.control",regex:/\(\)/,comment:"Hole"},{token:"support.function",regex:/>>/,comment:"Out"},{token:"support.function",regex:/>\//,comment:"Ln Out"},{token:"support.function",regex:/<</,comment:"In"},{token:"keyword.control",regex:/--/,comment:"One use"},{token:"constant.language",regex:/%[LRUDNlrudn]/,comment:"Direction"},{token:["entity.name.function","keyword.other","keyword.operator","keyword.other","keyword.operator","constant.numeric","keyword.operator","keyword.other","keyword.operator","constant.numeric","string.quoted.double","string.quoted.single"],regex:/([A-Za-z][A-Za-z0-9])( *-> *)(?:([-+*\/]=)( *)((?:-)?)([0-9]+)|(=)( *)(?:((?:-)?)([0-9]+)|("[^"]*")|('[^']*')))/,comment:"Assignment function"},{token:["entity.name.function","keyword.other","keyword.control","keyword.other","keyword.operator","keyword.other","keyword.operator","constant.numeric","entity.name.tag","keyword.other","keyword.control","keyword.other","constant.language","keyword.other","keyword.control","keyword.other","constant.language"],regex:/([A-Za-z][A-Za-z0-9])( *-> *)(IF|if)( *)(?:([<>]=?|==)( *)((?:-)?)([0-9]+)|(\*[\*A-Za-z0-9]))( *)(THEN|then)( *)(%[LRUDNlrudn])(?:( *)(ELSE|else)( *)(%[LRUDNlrudn]))?/,comment:"Equality Function"},{token:"entity.name.function",regex:/[A-Za-z][A-Za-z0-9]/,comment:"Function cell"},{token:"comment.line.double-slash",regex:/ *\/\/.*/,comment:"Comment"}]},this.normalizeRules()};r.metaData={fileTypes:["mz"],name:"Maze",scopeName:"source.maze"},o.inherits(r,n),t.MazeHighlightRules=r}),define("ace/mode/folding/cstyle",["require","exports","module","ace/lib/oop","ace/range","ace/mode/folding/fold_mode"],function(e,t){"use strict";var o=e("../../lib/oop"),c=e("../../range").Range,n=e("./fold_mode").FoldMode,r=t.FoldMode=function(e){e&&(this.foldingStartMarker=new RegExp(this.foldingStartMarker.source.replace(/\|[^|]*?$/,"|"+e.start)),this.foldingStopMarker=new RegExp(this.foldingStopMarker.source.replace(/\|[^|]*?$/,"|"+e.end)))};o.inherits(r,n),function(){this.foldingStartMarker=/([\{\[\(])[^\}\]\)]*$|^\s*(\/\*)/,this.foldingStopMarker=/^[^\[\{\(]*([\}\]\)])|^[\s\*]*(\*\/)/,this.singleLineBlockCommentRe=/^\s*(\/\*).*\*\/\s*$/,this.tripleStarBlockCommentRe=/^\s*(\/\*\*\*).*\*\/\s*$/,this.startRegionRe=/^\s*(\/\*|\/\/)#?region\b/,this._getFoldWidgetBase=this.getFoldWidget,this.getFoldWidget=function(e,t,o){var n=e.getLine(o);if(this.singleLineBlockCommentRe.test(n)&&!this.startRegionRe.test(n)&&!this.tripleStarBlockCommentRe.test(n))return"";var r=this._getFoldWidgetBase(e,t,o);return!r&&this.startRegionRe.test(n)?"start":r},this.getFoldWidgetRange=function(e,t,o,n){var r,i=e.getLine(o);if(this.startRegionRe.test(i))return this.getCommentRegionBlock(e,i,o);if(r=i.match(this.foldingStartMarker)){var a=r.index;if(r[1])return this.openingBracketBlock(e,r[1],o,a);var l=e.getCommentFoldRange(o,a+r[0].length,1);return l&&!l.isMultiLine()&&(n?l=this.getSectionRange(e,o):"all"!=t&&(l=null)),l}if("markbegin"!==t&&(r=i.match(this.foldingStopMarker))){a=r.index+r[0].length;return r[1]?this.closingBracketBlock(e,r[1],o,a):e.getCommentFoldRange(o,a,-1)}},this.getSectionRange=function(e,t){for(var o=e.getLine(t),n=o.search(/\S/),r=t,i=o.length,a=t+=1,l=e.getLength();++t<l;){var s=(o=e.getLine(t)).search(/\S/);if(-1!==s){if(s<n)break;var g=this.getFoldWidgetRange(e,"all",t);if(g){if(g.start.row<=r)break;if(g.isMultiLine())t=g.end.row;else if(n==s)break}a=t}}return new c(r,i,a,e.getLine(a).length)},this.getCommentRegionBlock=function(e,t,o){for(var n=t.search(/\s*$/),r=e.getLength(),i=o,a=/^\s*(?:\/\*|\/\/|--)#?(end)?region\b/,l=1;++o<r;){t=e.getLine(o);var s=a.exec(t);if(s&&(s[1]?l--:l++,!l))break}if(i<o)return new c(i,n,o,t.length)}}.call(r.prototype)}),define("ace/mode/maze",["require","exports","module","ace/lib/oop","ace/mode/text","ace/mode/maze_highlight_rules","ace/mode/folding/cstyle"],function(e,t){"use strict";var o=e("../lib/oop"),n=e("./text").Mode,r=e("./maze_highlight_rules").MazeHighlightRules,i=e("./folding/cstyle").FoldMode,a=function(){this.HighlightRules=r,this.foldingRules=new i,this.$behaviour=this.$defaultBehaviour};o.inherits(a,n),function(){this.lineCommentStart="//",this.$id="ace/mode/maze"}.call(a.prototype),t.Mode=a}),window.require(["ace/mode/maze"],function(e){"object"==typeof module&&"object"==typeof exports&&module&&(module.exports=e)});