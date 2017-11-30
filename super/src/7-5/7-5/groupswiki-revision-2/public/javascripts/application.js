/*
 * This file is copyright (c) 2006-2007 Ben Nolan.
 * AGPL Licensed.
 */

var safari = /Konqueror|Safari|KHTML/.test(navigator.userAgent),
  firefox = /Firefox/.test(navigator.userAgent),
  ie = /MSIE/.test(navigator.userAgent);

Wiki = {
  linkFromText : function(st){
    return '/pages/' + st.replace(/<.+?>/g,'').replace(/&.+?;/g,' ').replace(/\s+/g,' ').replace(/[~!@#$%^&*\(\)_\+`\-=\{\}|\[\]\;\':",.\/<>?]/g, ' ').replace(/ +$/,'').replace(/ +/g, '_').toLowerCase();
  }
};

Onload = Class.create();
Onload.prototype = {
  initialize : function(){
    this.ieFixes();
    
    if (($('mode')) && ($F('mode')=='edit')){
      setTimeout(function(){
        window.ed_ = new Editor('editor', 'content');
      },100);
    }
  },
  ieFixes : function(){
    var x = new PeriodicalExecuter(function(){
      if (ie){
	if ($('col1')){
          $('col1').style.top = (document.documentElement.scrollTop + 50) + 'px';
        }
      }
    }, 0.1);
  }
};

Dialog = Class.create();

Dialog.prototype = {
  initialize : function(el, editor){
    this.parent = $(el);
    this.editor = editor;
    this.createElements();
    this.editor.disableEditing();
    this.editor.el.toolbar.hide();
  },
  
  styles : {
    right : {
      className : 'editor-dialog-right',
      xOffset : -580,
      yOffset : -40
    }
  },
  
  createElements : function(){
    this.style = this.styles.right;
    
    this.el = {
      root : Builder.node('div', {className : 'editor-dialog'}),
      lightbox : Builder.node('div', {className : 'lightbox'}),
      content : Builder.node('div')
    };
    
    this.el.root.addClassName(this.style.className);
    this.el.root.appendChild(this.el.content);

    document.body.appendChild(this.el.root);
    document.body.appendChild(this.el.lightbox);
    
    if (ie){
      this.fixIe();
    }
  },
  
  fixIe : function(){
    this.el.lightbox.style.position = 'absolute';
    this.el.lightbox.style.top = "0px";

    this.el.root.style.position = 'absolute';
  },
  
  loadContent : function(url, postHash){
    var ajax = new Ajax.Updater(this.el.content, url, {method : postHash ? 'post' : 'get', postBody : postHash ? postHash.toQueryString() : ''});
  },
  
  close : function(){
    document.body.removeChild(this.el.root);
    document.body.removeChild(this.el.lightbox);
    this.editor.enableEditing();
    this.editor.el.toolbar.show();
  },
  
  showSpinner : function(){
    this.el.content.hide();
    this.el.root.appendChild(Builder.node('img', {className : 'spinner', src : '/images/spinner.gif'}));
  },
  
  loading : function(){
    setTimeout(this.showSpinner.bind(this), 10);
  }
};

LinkDialog = Class.create();
LinkDialog.prototype = {
  initialize : function(link, editor){
    this.link = link;
    this.editor = editor;
    this.createElements();
    this.setInitialState();
  },
  
  setInitialState : function(){
    if (this.link.hasClassName('weblink')){
      this.showTab('web');
      this.el.weburl.value = this.link.getAttribute('href');
    }else{
      this.showTab('wiki');
      this.el.wikiurl.value = this.link.getAttribute('href').replace(/^.pages./, '');
    }
  },
  
  createElements : function(){
    this.dialog = window.dialog_ = new Dialog(this.link, this.editor);
    
    this.el = {};

    Object.extend(this.el, {
      links : $H({
        wiki : Builder.node('a', {src:'#'}, 'Wiki link'),
        web : Builder.node('a', {src:'#'}, 'Web link'),
        unlink : Builder.node('a', {src:'#'}, 'Unlink')
      }),
      tabs : $H({
        wiki : Builder.node('div', [
          Builder.node('p', 'Enter a wikipage to link to:'),
          this.el.wikiurl = Builder.node('input', {type : 'text', style : 'width: 250px'}),
          this.el.submitWiki = Builder.node('input', {type : 'submit', value : 'Save'}),
          ' or ',
          this.el.cancelWiki = Builder.node('a', {href : '#'}, 'cancel')
        ]),
        web : Builder.node('div', [
          Builder.node('p', 'Enter a url to link to:'),
          Builder.node('img', {src : '/images/extlink.gif'}),
          this.el.weburl = Builder.node('input', {type : 'text', style : 'width: 250px'}),
          this.el.submitWeb = Builder.node('input', {type : 'submit', value : 'Save'}),
          ' or ',
          this.el.cancelWeb = Builder.node('a', {href : '#'}, 'cancel')
        ]),
        unlink : Builder.node('div', [
          Builder.node('p', 'Link will be returned to normal text'),
          this.el.submitUnlink = Builder.node('input', {type : 'submit', value : 'Unlink'})
        ]
        )
      })
    });

    this.el.cancelWiki.observe('click', this.close.bind(this));
    this.el.cancelWeb.observe('click', this.close.bind(this));
    
    this.el.submitWiki.observe('click', this.submitWiki.bind(this));
    this.el.submitWeb.observe('click', this.submitWeb.bind(this));
    this.el.submitUnlink.observe('click', this.submitUnlink.bind(this));

    this.dialog.el.content.appendChild(
      Builder.node('div', {}, [
        Builder.node('p', {className : 'dialog-tabs'}, 
          this.el.links.collect(function(pair){
            pair[1].observe('click', function(){
              this.showTab(pair[0]);
            }.bind(this));
            return pair[1];
          }.bind(this))
        ),
        Builder.node('div', {}, this.el.tabs.values())
      ])
    );
  },
  
  showTab : function(tabName){
    this.el.tabs.values().invoke('hide');
    this.el.tabs[tabName].show();

    this.el.links.values().invoke('removeClassName', 'active');

    this.el.links[tabName].addClassName('active');
  },

  close : function(e){
    this.dialog.close();

    if(e){
      Event.stop(e);
    }
  },
  
  submitWiki : function(){
    this.link.href = $F(this.el.wikiurl);
    this.link.className = "";
    this.close();
  },

  submitWeb : function(){
    this.link.href = $F(this.el.weburl);
    this.link.className = "weblink";
    this.close();
  },

  submitUnlink : function(){
    this.editor.convertElement(this.link, 'span');
/*    var text = this.editor.document.createTextNode;
    text.value = this.link.innerHTML;

    this.link.parentNode.insertBefore(text, this.link);
    //this.link.remove();
    */
    this.close();
  }
};

Button = {};

Button.Style = Class.create();
Button.Style.prototype = {
  initialize : function(style, editor){
    this.style = style;
    this.editor = editor;
    this.createElements();
  },
  
  createElements : function(){
    this.el = Builder.node('input', {className : 'style-button', type : 'submit', value : this.style});
    this.el.observe('click', this.onClick.bind(this));
  },
  
  updateStatus : function(){
    var el = this.editor.getSelectedElement();
    
    if (el.nodeName == this.getNodename()){
      this.el.addClassName('active');
    }else{
      this.el.removeClassName('active');
    }
  },
  
  getNodename : function(){
    switch(this.style){
      case 'Bold': 
        return 'B';
      case 'Italic': 
        return 'I';
    }
  },
  
  onClick : function(e){
    if(this.editor.getSelection()){
      this.editor.applyStyle(this.style);
    }
    
    Event.stop(e);
  }
};

Button.Link = Class.create();
Button.Link.prototype = {
  initialize : function(editor){
    this.editor = editor;
    this.createElements();
  },
  
  createElements : function(){
    this.el = Builder.node('input', {className : 'style-button', type : 'submit', value : 'Link'});
    this.el.observe('mouseup', this.onClick.bind(this));
  },
  
  updateStatus : function(){
  },
  
  onClick : function(e){
    this.editor.createLink();
    
    Event.stop(e);
  }
};

Button.Image = Class.create();
Button.Image.prototype = {
  initialize : function(editor){
    this.editor = editor;
    this.createElements();
  },
  
  createElements : function(){
    this.el = Builder.node('input', {className : 'style-button', type : 'submit', value : 'Insert image'});
    this.el.observe('click', this.onClick.bind(this));
  },
  
  updateStatus : function(){
  },
  
  onClick : function(e){
    window.dialog_ = new Dialog(this.el, this.editor);
    window.dialog_.loadContent('/attachments/new');
    Event.stop(e);
  }
};

Button.BlockStyle = Class.create();
Button.BlockStyle.prototype = {
  initialize : function(editor){
    this.editor = editor;
    this.createElements();
  },
  
  createElements : function(){
    this.el = Builder.node('select', {size : '6'}, [
      Builder.node('option', {value:'P'}, 'None'),
      Builder.node('option', {value:'H1'}, 'Heading'),
      Builder.node('option', {value:'H2'}, 'Subheading'),
      Builder.node('option', {value:'CENTER'}, 'Centered'),
      Builder.node('option', {value:'PRE'}, 'Source code')
    ]);
    
    this.el.value = 'P';
    
    this.el.observe('change', this.onChange.bind(this));
  },
  
  updateStatus : function(){
    var el = this.editor.getSelectedElement();
    
    $A(this.el.childNodes).each(function(o){
      if ((el.nodeName==o.value) || (el.up(o.value))){
        this.el.value = o.value;
      }
    }.bind(this));
  },
  
  onChange : function(e){
    var v = this.el.value;
    
    $A(v.split(' ')).each(function(nodename){
      this.editor.setBlockType(nodename);
    }.bind(this));
    
    Event.stop(e);
  }
};

Editor = Class.create();
Editor.prototype = {
  initialize : function(el, content){
    // In the test environment?
    if (!el){
      return;
    }
    
    this.parent = $(el);
    this.content = $(content);

    this.saveScrollPosition();
    this.createElements();
    this.setEditable();

    this.waitForIframeToLoad();
  },
  
  waitForIframeToLoad : function(){
    if( (!this.document) || (!this.document.body)){
      setTimeout(this.waitForIframeToLoad.bind(this), 100);
      return;
    }
      
    this.setContent();
    this.appendListeners();
    this.pe = new PeriodicalExecuter(this.showAncestors.bind(this), 0.1);
    this.showEditingToolbar();

    this.focus();
    this.selectNode(this.document.body.firstChild);

    this.applyScrollPosition();
  },
  
  focus : function(){
    if (safari){
      this.el.iframe.focus();
    }else{
      this.el.iframe.focus();
      this.window.focus();
    }
  },
  
  showEditingToolbar : function(){
    $('editing-toolbar').show();
    //var effect = new Effect.SlideDown('editing-toolbar', {duration: 0.5});
    $('rest-of-col1').hide();
    $('enable-editing').hide();
  },
  
  showSavingDialog : function(){
    $('editing-toolbar').hide();
    $('editor-saving').show();
  },
  
  hideEditingToolbar : function(){
    $('rest-of-col1').show();
    $('enable-editing').show();
    $('editing-toolbar').hide();
    $('editor-saving').hide();
  },
  
  createButtons : function(){
    this.buttons = 
      $A(['Bold', 'Italic']).map(function(style){
        var button = new Button.Style(style, this);
        return button;
      }.bind(this));
    
    this.buttons.push(new Button.Image(this));
    this.buttons.push(new Button.Link(this));
    this.buttons.push(new Button.BlockStyle(this));
    
    return this.buttons;
  },
  
  createElements : function(el){
    this.parent.show();

    var uri = '';
    //javascript:void(0)
    
    this.el = {
      iframe : Builder.node('iframe', {className : 'editor', src : uri})
    };

    this.el.toolbar = Builder.node('div', {}, [
      this.el.ancestors = Builder.node('div'),
      this.el.buttons = Builder.node('div', {}, 
        this.createButtons().pluck('el')
      )
    ]);
    
    this.el.iframe.height = this.content.offsetHeight;
    
    // Rebuild the contents of the toolbar node
    $('toolbar').update();
    $('toolbar').appendChild(this.el.toolbar);
    
    this.parent.appendChild(this.el.iframe);
  },
  
  appendListeners : function(){
    $A(this.document.getElementsByTagName('a')).each(this.addListener.bind(this));
  },
  
  addListener : function(el){
    $(el).observe('click', function(e){
      var link = new LinkDialog(el, this);
      Event.stop(e);
    }.bind(this));
  },
  
  setContent : function(){
    var content = this.content.innerHTML;
    
    if(content===""){
      content += "<p><br /></p>";
    }
    
    this.document.body.innerHTML = content;
    this.content.hide();
  },

  normalizeElement : function(el){
    if(safari){
      return this.normalizeElementSafari(el);
    }

    if(firefox){
      return el;
    }

    if(ie){
      return this.normalizeElementIE(el);
    }
    
    return el;
  },
  
  convertElement : function(element, nodeName, doc){
    var replacement = (doc ? doc : this.document).createElement(nodeName);
    replacement.innerHTML = element.innerHTML;
    element.parentNode.insertBefore(replacement, element);
    element.remove();
    return replacement;
  },

  normalizeElementSafari : function(element){
    // Get rid of safari css
    $(element).getElementsBySelector("span").each(function(el){
      if(!el){
	      return;
      }
      if(el.getStyle('font-weight')=='bold'){
        this.convertElement(el, 'B', document);
	      return;
      }
      if(el.getStyle('font-style')=='italic'){
        this.convertElement(el, 'I', document);
	      return;
      }
    }.bind(this));

    $(element).getElementsBySelector("span").each(function(el){
      // Remove useless spans
      $A(el.childNodes).each(function(child){
        el.parentNode.insertBefore(child, el);
      });
      
      el.remove();
    });
    
    // Remove unnecessary classes
    $(element).getElementsBySelector("br").each(function(el){
      el.removeAttribute('class');
    });

    return element;
  },
  
  normalizeElementIE : function(element){
    // Convert some elements
    $(element).getElementsBySelector("strong").each(function(el){
      this.convertElement(el, 'B', document);
    }.bind(this));
    $(element).getElementsBySelector("em").each(function(el){
      this.convertElement(el, 'I', document);
    }.bind(this));
    
    return element;
  },
  
  setEditable : function(){
    this.window = this.el.iframe.contentWindow;
    this.document = this.window.document;

    var overflow = ie ? 'overflow:auto' : 'overflow:hidden';
    
    this.document.open();
    this.document.write('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"><html><head><style>@import url(/stylesheets/user.css); html,body{border: none; padding: 0; margin: 0;' + overflow + ';}</style></head><body id="content"></body></html>');
    this.document.close();

    this.document.designMode = 'on';
    
    // Apply prototype element helpers to the body element
    $(this.document.body);

    try{
			this.document.execCommand("useCSS", false, true); // old moz call
			this.document.execCommand("styleWithCSS", false, false); // new moz call
		}catch(e){
		}
  },
  
  createLink : function(){
    var link, dialog;
    
    if(this.getSelection()){
      link = this.createNodeFromSelection();
      link = this.convertElement(link, 'a');
      link.className = 'wiki-link';
      link.setAttribute('href', Wiki.linkFromText(link.innerHTML));
      this.addListener(link);
      this.setSelectedNode(link);
      dialog = new LinkDialog(link, this);
    }
  },
  
  setBlockType : function(nodeName){
    var el, block;
    
    if (this.getSelectedBlock()){
      // We are in a block level element - easy
      el = this.getSelectedBlock();
      
      el = this.convertElement(el, nodeName);
      this.setSelectedNode(el.firstChild);
    }else{
      // We are in a inline element that is parented to the body (dumb)

      el = this.getSelectedNode();
      
      block = this.document.createElement(nodeName);
      block.innerHTML = el.nodeType == 1 ? el.innerHTML : el.nodeValue;
      el.parentNode.insertBefore(block, el);
      el.parentNode.removeChild(el);

      this.setSelectedNode(block.firstChild);
    }
  },
  
  disableEditing : function(){
    /*if (!safari){
      this.el.iframe.hide();
      this.content.show();
    }*/
  },
  
  enableEditing : function(){
    //this.el.iframe.show();
    //this.content.hide();
  },
  
  showAncestors : function(){
    this.el.iframe.height = (ie ? this.document.body.scrollHeight + 4 : this.document.body.offsetHeight + 25);

    if($('debugarea')){
    	$('debugarea').value = this.document.body.innerHTML;
    }

    if (this._selectedNode != this.getSelectedElement()){
      this.buttons.invoke('updateStatus');
      //this.el.ancestors.update(this.getSelectedElement().ancestorsAndSelf().pluck('nodeName').join(' &gt; '));
    }
    
    this._selectedNode = this.getSelectedElement();
  },

  createNodeFromSelection : function(nodeName){
    var el;

    if (safari){
      this.execCommand('fontsize', '1.0em');
      el = $(this.document.body).getElementsBySelector('span').find(function(el){
        return (/font-size/).test(el.style.cssText);
      });
      el.style.cssText = "";
    }
    if (firefox){
      this.execCommand('fontsize', 3);
      el = $(this.document.body).getElementsBySelector('font').find(function(el){
        return el.attributes.size;
      });
      el.size = null;
    }
    if (ie){
      this.execCommand('fontsize', 3);
      el = $(this.document.body).getElementsBySelector('font').find(function(el){
        return el.getAttribute('size');
      });
      el.size = null;
    }
    
    return $(el);
  },
  
	execCommand : function(command){
	  var argument = arguments[1];
	  return this.document.execCommand(command, false, argument);
	},

  applyStyle : function(style){
    this.execCommand(style);
  },
  
  getSelection : function(){
    if (this.window){
      return ie ? (document.selection && document.selection.createRange()) : this.window.getSelection();
    }
  },
  
  setSelectedNode : function(el){
    this._cachedSelectedNode = el;
    this.selectNode(el);
    this.focus();
  },
  
  getSelectedElement : function(){
    var el = this.getSelectedNode();

    if (el){
      if (el.nodeType==3){
        el = el.parentNode;
      }

  		return $(el);
    }else{
      return null;
    }
  },
  
  getSelectedNode : function(){
    if (!this._cachedSelectedNode){
      this._cachedSelectedNode = $(this.document.body);
    }

    var el = this.getSelection();
    
    if (ie){
      el = el ? el.parentElement() : this._cachedSelectedNode;
    }else{
      el = (el && el.anchorNode) ? el.anchorNode : this._cachedSelectedNode;
    }
    
    this._cachedSelectedNode = el;
    
    return this._cachedSelectedNode;
  },
  
  insertImage : function(src){
    var el, image;
    
    if (safari){
      // Hacks!
      el = this.getSelectedElement();
      image = this.document.createElement("img");
        
      image.src = src;
      
      el.parentNode.insertBefore(image, el);
    }else{
      this.execCommand('insertimage', src);
    }
  },

  getSelectedBlock : function(){
    var el = this.getSelectedElement(true).ancestorsAndSelf().find(function(el){
      return el.getStyle('display') == 'block';
    });
    
    return ((!el) || (el.nodeName == 'BODY')) ? false : el;
  },
  
  selectNode : function(el){
    var r;
    
    // Experimental...
    
    if (firefox){
      // see http://www.sitepoint.com/article/life-autocomplete-textboxes
      // see http://www.faqts.com/knowledge_base/view.phtml/aid/13562
      
      if(el.nodeType==1){
        el = el.firstChild;
      }

      //console.log(el.length);
      
      if (el){
        r = this.document.createRange();
        r.setStart(el,0);
        r.setEnd(el,0);

        this.window.getSelection().removeAllRanges();
        this.window.getSelection().addRange(r);
      }

      //r.setEnd(el,1);
     //console.log(r);
    }
    
    if (safari){
      // From http://lists.apple.com/archives/webkitsdk-dev/2006/Jan/msg00032.html
      this.window.getSelection().setBaseAndExtent(el, 0, el, 0);
    }
    
    if(ie){
      return;
      
      // see http://msdn.microsoft.com/workshop/author/dhtml/reference/objects/obj_textrange.asp
      // see http://www.thescripts.com/forum/thread475196.html
      
      // From http://codingforums.com/archive/index.php?t-51493.html
      /*cursorPos=document.selection.createRange().duplicate();
      clickx = cursorPos.getBoundingClientRect().left;
      clicky = cursorPos.getBoundingClientRect().top;

      cursorPos = document.body.createTextRange();
      cursorPos.moveToPoint(clickx, clicky);
      */
      //cursorPos.select();
    }
  },
  
  getContent : function(){
    return this.document.body.innerHTML;
  },
  
  updateContent : function(){
    this.content.innerHTML = this.getContent();
  },
  
  getPagePath : function(){
    return $F('page_path');
  },
  
  abort : function(){
    this.hideEditingToolbar();
    this.close();
  },
  
  save : function(){
    this.showSavingDialog();

    this.updateContent();
    this.normalizeElement(this.content);

    var request = new Ajax.Request('/pages/' + this.getPagePath(), {
  		parameters : {
  			_method : 'put',
  			'page[content]' : this.content.innerHTML
  		},
      onComplete : this.hideEditingToolbar.bind(this)
    });

    //postBody : '_method=put&page[content]=' + escape(this.content.innerHTML),

    this.close();
  },
  
  close : function(){
    this.saveScrollPosition();
    this.pe.stop();

    if (this.dialog){
      this.dialog.close();
    }

    this.content.show();
    this.parent.removeChild(this.el.iframe);

    this.applyScrollPosition();
  },

  saveScrollPosition : function(){
    this.scrollTop = ie ? document.documentElement.scrollTop : document.body.scrollTop;
  },
  
  applyScrollPosition : function(){
    if (ie){
      document.body.scrollTop = this.scrollTop + 'px';
    }else{
      document.body.scrollTop = this.scrollTop;
    }
  }
};