define("ace/mode/rust_highlight_rules",["require","exports","module","ace/lib/oop","ace/mode/text_highlight_rules"],function(e,t){"use strict";var r=e("../lib/oop"),o=e("./text_highlight_rules").TextHighlightRules,n=/\\(?:[nrt0'"\\]|x[\da-fA-F]{2}|u\{[\da-fA-F]{6}\})/.source,s=function(){this.$rules={start:[{token:"variable.other.source.rust",regex:"'[a-zA-Z_][a-zA-Z0-9_]*(?![\\'])"},{token:"string.quoted.single.source.rust",regex:"'(?:[^'\\\\]|"+n+")'"},{token:"identifier",regex:/r#[a-zA-Z_][a-zA-Z0-9_]*\b/},{stateName:"bracketedComment",onMatch:function(e,t,r){return r.unshift(this.next,e.length-1,t),"string.quoted.raw.source.rust"},regex:/r#*"/,next:[{onMatch:function(e,t,r){var o="string.quoted.raw.source.rust";return e.length>=r[1]?(e.length>r[1]&&(o="invalid"),r.shift(),r.shift(),this.next=r.shift()):this.next="",o},regex:/"#*/,next:"start"},{defaultToken:"string.quoted.raw.source.rust"}]},{token:"string.quoted.double.source.rust",regex:'"',push:[{token:"string.quoted.double.source.rust",regex:'"',next:"pop"},{token:"constant.character.escape.source.rust",regex:n},{defaultToken:"string.quoted.double.source.rust"}]},{token:["keyword.source.rust","text","entity.name.function.source.rust"],regex:"\\b(fn)(\\s+)((?:r#)?[a-zA-Z_][a-zA-Z0-9_]*)"},{token:"support.constant",regex:"\\b[a-zA-Z_][\\w\\d]*::"},{token:"keyword.source.rust",regex:"\\b(?:abstract|alignof|as|become|box|break|catch|continue|const|crate|default|do|dyn|else|enum|extern|for|final|if|impl|in|let|loop|macro|match|mod|move|mut|offsetof|override|priv|proc|pub|pure|ref|return|self|sizeof|static|struct|super|trait|type|typeof|union|unsafe|unsized|use|virtual|where|while|yield)\\b"},{token:"storage.type.source.rust",regex:"\\b(?:Self|isize|usize|char|bool|u8|u16|u32|u64|u128|f16|f32|f64|i8|i16|i32|i64|i128|str|option|either|c_float|c_double|c_void|FILE|fpos_t|DIR|dirent|c_char|c_schar|c_uchar|c_short|c_ushort|c_int|c_uint|c_long|c_ulong|size_t|ptrdiff_t|clock_t|time_t|c_longlong|c_ulonglong|intptr_t|uintptr_t|off_t|dev_t|ino_t|pid_t|mode_t|ssize_t)\\b"},{token:"variable.language.source.rust",regex:"\\bself\\b"},{token:"comment.line.doc.source.rust",regex:"//!.*$"},{token:"comment.line.double-dash.source.rust",regex:"//.*$"},{token:"comment.start.block.source.rust",regex:"/\\*",stateName:"comment",push:[{token:"comment.start.block.source.rust",regex:"/\\*",push:"comment"},{token:"comment.end.block.source.rust",regex:"\\*/",next:"pop"},{defaultToken:"comment.block.source.rust"}]},{token:"keyword.operator",regex:/\$|[-=]>|[-+%^=!&|<>]=?|[*/](?![*/])=?/},{token:"punctuation.operator",regex:/[?:,;.]/},{token:"paren.lparen",regex:/[\[({]/},{token:"paren.rparen",regex:/[\])}]/},{token:"constant.language.source.rust",regex:"\\b(?:true|false|Some|None|Ok|Err)\\b"},{token:"support.constant.source.rust",regex:"\\b(?:EXIT_FAILURE|EXIT_SUCCESS|RAND_MAX|EOF|SEEK_SET|SEEK_CUR|SEEK_END|_IOFBF|_IONBF|_IOLBF|BUFSIZ|FOPEN_MAX|FILENAME_MAX|L_tmpnam|TMP_MAX|O_RDONLY|O_WRONLY|O_RDWR|O_APPEND|O_CREAT|O_EXCL|O_TRUNC|S_IFIFO|S_IFCHR|S_IFBLK|S_IFDIR|S_IFREG|S_IFMT|S_IEXEC|S_IWRITE|S_IREAD|S_IRWXU|S_IXUSR|S_IWUSR|S_IRUSR|F_OK|R_OK|W_OK|X_OK|STDIN_FILENO|STDOUT_FILENO|STDERR_FILENO)\\b"},{token:"meta.preprocessor.source.rust",regex:"\\b\\w\\(\\w\\)*!|#\\[[\\w=\\(\\)_]+\\]\\b"},{token:"constant.numeric.source.rust",regex:/\b(?:0x[a-fA-F0-9_]+|0o[0-7_]+|0b[01_]+|[0-9][0-9_]*(?!\.))(?:[iu](?:size|8|16|32|64|128))?\b/},{token:"constant.numeric.source.rust",regex:/\b(?:[0-9][0-9_]*)(?:\.[0-9][0-9_]*)?(?:[Ee][+-][0-9][0-9_]*)?(?:f32|f64)?\b/}]},this.normalizeRules()};s.metaData={fileTypes:["rs","rc"],foldingStartMarker:"^.*\\bfn\\s*(\\w+\\s*)?\\([^\\)]*\\)(\\s*\\{[^\\}]*)?\\s*$",foldingStopMarker:"^\\s*\\}",name:"Rust",scopeName:"source.rust"},r.inherits(s,o),t.RustHighlightRules=s}),define("ace/mode/folding/cstyle",["require","exports","module","ace/lib/oop","ace/range","ace/mode/folding/fold_mode"],function(e,t){"use strict";var r=e("../../lib/oop"),l=e("../../range").Range,o=e("./fold_mode").FoldMode,n=t.FoldMode=function(e){e&&(this.foldingStartMarker=new RegExp(this.foldingStartMarker.source.replace(/\|[^|]*?$/,"|"+e.start)),this.foldingStopMarker=new RegExp(this.foldingStopMarker.source.replace(/\|[^|]*?$/,"|"+e.end)))};r.inherits(n,o),function(){this.foldingStartMarker=/([\{\[\(])[^\}\]\)]*$|^\s*(\/\*)/,this.foldingStopMarker=/^[^\[\{\(]*([\}\]\)])|^[\s\*]*(\*\/)/,this.singleLineBlockCommentRe=/^\s*(\/\*).*\*\/\s*$/,this.tripleStarBlockCommentRe=/^\s*(\/\*\*\*).*\*\/\s*$/,this.startRegionRe=/^\s*(\/\*|\/\/)#?region\b/,this._getFoldWidgetBase=this.getFoldWidget,this.getFoldWidget=function(e,t,r){var o=e.getLine(r);if(this.singleLineBlockCommentRe.test(o)&&!this.startRegionRe.test(o)&&!this.tripleStarBlockCommentRe.test(o))return"";var n=this._getFoldWidgetBase(e,t,r);return!n&&this.startRegionRe.test(o)?"start":n},this.getFoldWidgetRange=function(e,t,r,o){var n,s=e.getLine(r);if(this.startRegionRe.test(s))return this.getCommentRegionBlock(e,s,r);if(n=s.match(this.foldingStartMarker)){var i=n.index;if(n[1])return this.openingBracketBlock(e,n[1],r,i);var u=e.getCommentFoldRange(r,i+n[0].length,1);return u&&!u.isMultiLine()&&(o?u=this.getSectionRange(e,r):"all"!=t&&(u=null)),u}if("markbegin"!==t&&(n=s.match(this.foldingStopMarker))){i=n.index+n[0].length;return n[1]?this.closingBracketBlock(e,n[1],r,i):e.getCommentFoldRange(r,i,-1)}},this.getSectionRange=function(e,t){for(var r=e.getLine(t),o=r.search(/\S/),n=t,s=r.length,i=t+=1,u=e.getLength();++t<u;){var a=(r=e.getLine(t)).search(/\S/);if(-1!==a){if(a<o)break;var c=this.getFoldWidgetRange(e,"all",t);if(c){if(c.start.row<=n)break;if(c.isMultiLine())t=c.end.row;else if(o==a)break}i=t}}return new l(n,s,i,e.getLine(i).length)},this.getCommentRegionBlock=function(e,t,r){for(var o=t.search(/\s*$/),n=e.getLength(),s=r,i=/^\s*(?:\/\*|\/\/|--)#?(end)?region\b/,u=1;++r<n;){t=e.getLine(r);var a=i.exec(t);if(a&&(a[1]?u--:u++,!u))break}if(s<r)return new l(s,o,r,t.length)}}.call(n.prototype)}),define("ace/mode/rust",["require","exports","module","ace/lib/oop","ace/mode/text","ace/mode/rust_highlight_rules","ace/mode/folding/cstyle"],function(e,t){"use strict";var r=e("../lib/oop"),o=e("./text").Mode,n=e("./rust_highlight_rules").RustHighlightRules,s=e("./folding/cstyle").FoldMode,i=function(){this.HighlightRules=n,this.foldingRules=new s,this.$behaviour=this.$defaultBehaviour};r.inherits(i,o),function(){this.lineCommentStart="//",this.blockComment={start:"/*",end:"*/",nestable:!0},this.$quotes={'"':'"'},this.$id="ace/mode/rust"}.call(i.prototype),t.Mode=i}),window.require(["ace/mode/rust"],function(e){"object"==typeof module&&"object"==typeof exports&&module&&(module.exports=e)});