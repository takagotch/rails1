/*
 * Imitate firebug in ie
 *
 * (c) Ben Nolan 2006 - BSD Licensed
 */
 
if (!window.console){
  var div = document.createElement("div");
  div.style.cssText = "overflow-x: hidden; overflow-y: auto; position:  absolute;top:  0;left:  0;background: #fafafa;border-bottom: 2px solid #333;height: 200px;z-index:  1000;width:  100%;padding: 0;";
  div.style.display = "none";

  window.onload = function(){
    document.body.insertBefore(div, document.body.firstChild);
    document.body.onkeydown = console.onKeyDown;
  }

  window.console = {
    div_ : div,
    log : function(st){
      var p = console.newRow_();

      if (!st){
        st = "[null]";
      }
      
      if (st.nodeName){
        st = "<" + st.nodeName + " ... />";
      }

      p.appendChild(document.createTextNode(st));

      console.write_(p);
    },
    write_ : function(obj){
      div.appendChild(obj);
    },
    show_ : function(){
      console.div_.style.display = "block";
    },
    hide_ : function(){
      console.div_.style.display = "none";
    },
    newRow_ : function(){
      var p = document.createElement("p");
      p.style.cssText = "padding:  3px;    margin:  0;  border-bottom:  1px solid #777;";
      return p;
    },
    onKeyDown : function(){
      if ( (window.event.ctrlKey) && (window.event.keyCode == 76) ){

        if (console.div_.style.display=='block'){
          console.hide_()
        }else{
          console.show_();
        }

        window.event.cancelBubble = true;
        
        return false;
      }    
    }
  }
  
  window.onerror = function(strMsg,strUrl,strLine){
    var caller = arguments.callee.caller;

    /*var st = '';
    for (x in arguments.callee.caller.arguments.callee){
      st += typeof(argument.callee.caller) + ',';
    }*/
    
    //console.log(st);
     
    var p = console.newRow_();
    p.style.background = "#ffa";
    p.style.color = "red";
    
    p.appendChild(document.createTextNode(strMsg));
    
    var span = document.createElement("span");
    span.style.cssText = "position: absolute; right: 60px; text-decoration: underline; color: black"
    span.innerHTML = "Line " + strLine;
    span.onclick = function(){
      // ...
    };
  
    p.appendChild(span);

    console.write_(p);

    while (caller){
      console.log(new String(caller).substr(0,60) + '...');
      caller = caller.caller;
    }
  
    //console.log(document.getElementsByTagName("script")[0].src);
    
    return true;
  }
}