document.write("<style type=text/css>.bl{display:inline !important}</style>");window.gnb={};(function(){var e=window.gnb;function j(a){return a==null||a.className=="g"?a:j(a.parentNode)}e._add=function(a,c){var b=a.ownerDocument,d=j(a);if(d==null){return false}a.parentNode.innerHTML="&nbsp;- メモを保存しました";var h=d.getElementsByTagName("A"),g=null;for(var f=0;f<h.length;++f){if(h[f].className=="l"){g=h[f]}}if(g==null){return false}var l=g.innerHTML.replace(/<\/?b>|<\/?font(?: color="?#?cc0033"?)?>/ig,
""),m=b.location.href+"",i=/td class="?j"?[^>]*?><font size="?-1"?>(?:<font color="?#6.*?<br>)?([\s\S]*?)(?:<br>)?<(?:nobr|script|table|div|span|font color="?#0)/i.exec(d.innerHTML);if(i==null){i=[""]}e._doAdd(i[1],l,c,m,d);return false};e._doAdd=function(a,c,b,d,h){k([a,c,b,d])};e._show=function(){e.title="Google ノートブック"};function n(){var a=document.createElement("div");a.id="gn_ph";var c=a.style;c.right="20px";c.bottom="0px";var b=document.body,d=b.style,h=navigator.userAgent.toLowerCase().indexOf("msie")>
-1;if(h){var g=document.createElement("div");g.id="gncntnr";var f=g.style;f.width="100%";f.height="100%";f.overflow=d.overflow||"auto";d.overflow="hidden";d.padding="0";while(b.firstChild){g.appendChild(b.firstChild)}b.appendChild(g);c.position="absolute"}else{c.position="fixed"}d.marginRight="0";b.appendChild(a);return a}function k(a){e._doAddargs=a;var c=document.getElementById("gn_ph");if(c!=null){return}c=n();var b=document.createElement("iframe");b.frameBorder=0;b.style.height="100%";b.style.width=
"100%";c.style.height="1px";c.style.width="1px";c.appendChild(b);var d=window.google.kHL;b.contentWindow.document.location.replace("/notebook/onsearch"+(d?"?hl="+d:"")+"&zx="+Math.random())}e._open=k;e._resizeIfr=function(a,c){var b=document.getElementById("gn_ph");b.style.width=a+"px";b.style.height=c+"px"}})();
