// Copyright (c) 2006 spinelz.org (http://script.spinelz.org/)
// 
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

var Window = Class.create();
Window.className = {
  window:       'window',
  header:       'window_header',
  headerLeft:   'window_headerLeft',
  headerMiddle: 'window_headerMiddle',
  headerRight:  'window_headerRight',
  buttonHolder: 'window_buttonHolder',
  closeButton:  'window_closeButton',
  maxButton:    'window_maxButton',
  minButton:    'window_minButton',
  body:         'window_body',
  bodyLeft:     'window_bodyLeft',
  bodyMiddle:   'window_bodyMiddle',
  bodyRight:    'window_bodyRight',
  bottom:       'window_bottom',
  bottomLeft:   'window_bottomLeft',
  bottomMiddle: 'window_bottomMiddle',
  bottomRight:  'window_bottomRight'
}

Window.prototype = {
  
  initialize: function(element) {
    var options = Object.extend({
      className:         Window.className.window,
      width:             300,
      height:            300,
      minWidth:          200,
      minHeight:         40,
      drag:              true,
      resize:            true,
      resizeX:           true,
      resizeY:           true,
      modal:             false,
      closeButton:       true,
      maxButton:         true,
      minButton:         true,
      cssPrefix:         'custom_',
      restriction:       false,
      endDrag:           Prototype.emptyFunction,
      endResize:         Prototype.emptyFunction,
      addButton:         Prototype.emptyFunction,
      preMaximize:       function() {return true},
      preMinimize:       function() {return true},
      preRevertMaximize: function() {return true},
      preRevertMinimize: function() {return true},
      preClose:          function() {return true},
      endMaximize:       Prototype.emptyFunction,
      endMinimize:       Prototype.emptyFunction,
      endRevertMaximize: Prototype.emptyFunction,
      endRevertMinimize: Prototype.emptyFunction,
      endClose:          Prototype.emptyFunction,
      dragOptions:       {},
      appendToBody:      false
    }, arguments[1] || {});
    
    var customCss = CssUtil.appendPrefix(options.cssPrefix, Window.className);
    this.classNames = new CssUtil([Window.className, customCss]);
    
    this.element = $(element);
    Element.setStyle(this.element, {visibility: 'hidden'});

    this.options = options;
    this.element.className = this.options.className;
    this.header = null;
    this.windowBody = null;
    this.bottom = null;
    
    this.elementId = this.element.id;
    this.dragHandleId = this.elementId + '_dragHandle';
    
    this.maxZindex = -1;
    this.minFlag = false;
    this.maxFlag = false;
    this.currentPos = [0,0];
    this.currentSize = [0,0];

    this.buildWindow();
    this.cover = new IECover(this.element, {padding: 10});
    
    Element.makePositioned(element);
    Element.hide(this.element);
    Element.setStyle(this.element, {visibility: 'visible'});

    if (this.options.appendToBody) this.appendToBody.callAfterLoading(this);
  },

  buildWindow: function() {
    Element.cleanWhitespace(this.element);
    
    with(this.element.style) {
      width = this.options.width + 'px';
      height= this.options.height + 'px';
    }

    var title = this.element.childNodes[0];
    var content = this.element.childNodes[1];
    this.buildHeader(title);
    this.buildBody(content);
    this.buildBottom();
    var newStyle = {height: this.options.height};
    this.setBodyHeight(newStyle);

    if (this.options.drag) this.createDraggble();

    if (this.options.resize) {
      this.enableResizing();
    }
  },

  buildHeader: function(title) {
    var headerLeft = Builder.node('div');
    this.classNames.addClassNames(headerLeft, 'headerLeft');

    var headerMiddle = Builder.node('div', {id: this.dragHandleId});
    this.classNames.addClassNames(headerMiddle, 'headerMiddle');
    
    var headerRight = Builder.node('div');
    this.classNames.addClassNames(headerRight, 'headerRight');

    var buttonHolder = Builder.node('div');
    this.classNames.addClassNames(buttonHolder, 'buttonHolder');
    
    headerMiddle.appendChild(title);
    var headerList = [headerLeft, headerMiddle, buttonHolder, headerRight];
    this.header = Builder.node('div', headerList);
    this.classNames.addClassNames(this.header, 'header');
    this.element.appendChild(this.header);
    
        
    if (this.options.closeButton) {
      var closeButton = Builder.node('div', {id: this.element.id.appendSuffix('closeButton')});
      this.classNames.addClassNames(closeButton, 'closeButton');
      buttonHolder.appendChild(closeButton);
      Event.observe(closeButton, 'click', this.close.bindAsEventListener(this));
    }
    if (this.options.maxButton) {
      var maxButton = Builder.node('div', {id: this.element.id.appendSuffix('maxButton')});
      this.classNames.addClassNames(maxButton, 'maxButton');
      buttonHolder.appendChild(maxButton);
      Event.observe(maxButton, 'click', this.maximize.bindAsEventListener(this));
    }
    if (this.options.minButton) {
      var minButton = Builder.node('div', {id: this.element.id.appendSuffix('minButton')});
      this.classNames.addClassNames(minButton, 'minButton');
      buttonHolder.appendChild(minButton);
      Event.observe(minButton, 'click', this.minimize.bindAsEventListener(this));
    }

    if (this.options.addButton) {
      var addButton = this.options.addButton;
      if (addButton.constructor == Function) {
        addButton(buttonHolder);
      } else if (addButton.constructor == Array) {
        var self = this;
        var firstChild = buttonHolder.firstChild;
        addButton.each(function(b) {
          var button = Builder.node('div', {id: b.id, className: b.className});
          Event.observe(button, 'click', b.onclick.bindAsEventListener(self));
          if (b.first && firstChild) {
            buttonHolder.insertBefore(button, firstChild);
          } else {
            buttonHolder.appendChild(button);
          }
        });
      }
    }
  },
  
  buildBody: function(contents) {
    var bodyLeft = Builder.node('div', {className: Window.className.bodyLeft});
    this.classNames.addClassNames(bodyLeft, 'bodyLeft');
    
    var bodyMiddle = Builder.node('div');
    this.classNames.addClassNames(bodyMiddle, 'bodyMiddle');
    bodyMiddle.appendChild(contents);
    
    var bodyRight = Builder.node('div');
    this.classNames.addClassNames(bodyRight, 'bodyRight');

    var bodyList = [bodyRight,bodyLeft, bodyMiddle];
    this.windowBody = Builder.node('div', bodyList);    
    this.classNames.addClassNames(this.windowBody, 'body');
    this.element.appendChild(this.windowBody);
  },
  
  buildBottom: function() {
    var bottomLeft = Builder.node('div');
    this.classNames.addClassNames(bottomLeft, 'bottomLeft');
    
    var bottomMiddle = Builder.node('div');
    this.classNames.addClassNames(bottomMiddle, 'bottomMiddle');
    
    var bottomRight = Builder.node('div');
    this.classNames.addClassNames(bottomRight, 'bottomRight');
    
    var bottomList = [bottomLeft, bottomMiddle, bottomRight];
    this.bottom = Builder.node('div', bottomList);
    this.classNames.addClassNames(this.bottom, 'bottom');
    this.element.appendChild(this.bottom);
  },

  createDraggble: function() {
    var self = this;
    var options = Object.extend({
      handle:      this.dragHandleId,
      starteffect: Prototype.emptyFunction,
      endeffect:   Prototype.emptyFunction,
      endDrag:     this.options.endDrag,
      scroll:      window
    }, this.options.dragOptions);

    if (this.options.restriction) {
      options.snap = function(x, y) {
        function constrain(n, lower, upper) {
          if (n > upper) return upper; 
          else if (n < lower) return lower;
          else return n;
        }

        var eDimensions = Element.getDimensions(self.element);
        var pDimensions = Element.getDimensions(self.element.parentNode);

        if (Element.getStyle(self.element.parentNode, 'position') == 'static') {
          var offset = Position.positionedOffset(self.element.parentNode);
          var parentLeft = offset[0];
          var parentTop = offset[1];
          return[
            constrain(x, parentLeft, parentLeft + pDimensions.width - eDimensions.width),
            constrain(y, parentTop, parentTop + pDimensions.height - eDimensions.height)
          ];
        } else {
          return[
            constrain(x, 0, pDimensions.width - eDimensions.width),
            constrain(y, 0, pDimensions.height - eDimensions.height)
          ];
        }
      }
    } else {
      var p = Position.cumulativeOffset(Position.offsetParent(this.element));
      options.snap = function(x, y) {
        return [
          ((x + p[0]) >= 0) ? x : 0 - p[0], 
          ((y + p[1]) >= 0) ? y : 0 - p[1]
        ];
      }
    }
    new DraggableWindowEx(this.element, options);
  },

  setWindowZindex : function(zIndex) {
    zIndex = this.getZindex(zIndex);
    this.element.style.zIndex = zIndex;
  },
  
  getZindex: function(zIndex) {
    return ZindexManager.getIndex(zIndex);
  },
  
  open: function(zIndex) {
    this.opening = true;
    if (this.options.modal) {
      Modal.mask(this.element, {zIndex: zIndex});
    } else {
      this.setWindowZindex(zIndex);
    }
    Element.show(this.element);
    this.cover.resetSize();
    this.opening = false;
    if (this.shouldClose) {
      this.close();
      this.shouldClose = false;
    }
  },
      
  close: function() {
    if (this.opening) this.shouldClose = true;
    if (!this.options.preClose(this)) return;
    this.element.style.zIndex = -1;
    this.maxZindex = -1;
    try {
      Element.hide(this.element);
    } catch(e) {}
    if (this.options.modal) {
      Modal.unmask();
    }
    this.options.endClose(this);
    if (this.opening) this.shouldClose = true;
  },

  minimize: function(event) {
    if (this.minFlag) {
      if (!this.options.preRevertMinimize(this)) return;
      Element.toggle(this.windowBody);
      if (this.maxFlag) {
        this.minFlag = false;
        this.setMax();
      } else {         
        var newStyle = {height:this.currentSize[1]}
        this.setBodyHeight(newStyle);
        this.element.style.width = this.currentSize[0];
        this.element.style.height = this.currentSize[1]; 
        this.element.style.left = this.currentPos[0];
        this.element.style.top = this.currentPos[1];
        this.maxFlag = false;
        this.minFlag = false;
        this.options.endRevertMinimize(this);
      }
    } else {
      if (!this.options.preMinimize(this)) return;
      Element.toggle(this.windowBody);
      if (!this.maxFlag) {
        this.currentPos = [Element.getStyle(this.element, 'left'), Element.getStyle(this.element, 'top')];
        this.currentSize = [Element.getStyle(this.element, 'width'), Element.getStyle(this.element, 'height')];
      }
      this.setMin();
      this.minFlag = true;
      this.options.endMinimize(this);
    }
    this.cover.resetSize();
  },
    
  maximize: function(event) {
    if (this.maxFlag) {
      if (this.minFlag) {
        Element.toggle(this.windowBody);
        this.minFlag = false;
        this.setMax();
      } else {
        if (!this.options.preRevertMaximize(this)) return;
        var newStyle = {height:parseInt(this.currentSize[1])}
        this.setBodyHeight(newStyle);
        this.element.style.width = this.currentSize[0];
        this.element.style.height = this.currentSize[1]; 
        this.element.style.left = this.currentPos[0];
        this.element.style.top = this.currentPos[1];
        this.maxFlag = false;
        this.minFlag = false;        
        document.body.style.overflow = '';
        this.element.style.position = this.position;
        if (this.parent) {
          if (this.nextElement) {
            this.parent.insertBefore(this.element, this.nextElement);
          } else {
            this.parent.appendChild(this.element);
          }
        }
        this.options.endRevertMaximize(this);
      }
    
    } else {
      if (!this.options.preMaximize(this)) return;
      if (!this.minFlag) {
        this.currentPos = [Element.getStyle(this.element, 'left'), Element.getStyle(this.element, 'top')];
        this.currentSize = [Element.getStyle(this.element, 'width'), Element.getStyle(this.element, 'height')];        
      } else {
        Element.toggle(this.windowBody);
        this.minFlag = false;
      }
      this.parent = this.element.parentNode;
      this.nextElement = Element.next(this.element, 0);
      this.position = Element.getStyle(this.element, 'position');
      document.body.style.overflow = 'hidden';
      document.body.appendChild(this.element);
      this.element.style.position = 'absolute';
      this.setMax();
      this.maxFlag = true;
      this.options.endMaximize(this);
    }
    this.cover.resetSize();
  },
    
  setMin : function() {
    var minHeight = this.header.offsetHeight + this.bottom.offsetHeight;
    var minWidth = this.options.minWidth;
    this.element.style.height = minHeight + 'px';
    this.element.style.width = minWidth + 'px';
  },
        
  setMax : function(zIndex) {
    var maxW = Element.getWindowWidth();
    var maxH = Element.getWindowHeight();
    var newStatus = {height:maxH}
    with(this.element.style) {
      width = maxW + 'px';
      height = maxH + 'px';
      left = '0px';
      top = '0px';
    }
    this.setBodyHeight(newStatus);
    this.setWindowZindex(zIndex);  
  },
  
  _getParentWidth: function(parent) {
    if (parent && parent.style) {
      var width = parent.style.width;
      var index = 0;
      if (width) {
        if ((index = width.indexOf('px', 0)) > 0) {
      return parseInt(width);
        } else if ((index = width.indexOf('%', 0)) > 0) {
          var pw = this._getParentWidth(parent.parentNode);
      
          var par = parseInt(width);
          return pw * par / 100;
        } else if (!width.isNaN) {
          return parseInt(width);
        }      
      } else if (parent == document.body){
        return Element.getWindowWidth();
      }
    }
  },

  setHeight: function(height) {
    height = {height: height};
    Element.setStyle(this.element, height);
    this.setBodyHeight(height);
  },
  
  setBodyHeight: function(newStyle) {
    var height = parseInt(newStyle.height);
    if (height > this.options.minHeight) {
      var newHeight = (height - this.header.offsetHeight - this.bottom.offsetHeight) + 'px';
      this.windowBody.childNodes[0].style.height = newHeight;
      this.windowBody.childNodes[1].style.height = newHeight;
      this.windowBody.childNodes[2].style.height = newHeight;
      this.windowBody.style.height = newHeight;
    }
    if (this.cover) this.cover.resetSize();
  },

  center: function() {
    var w = parseInt(Element.getStyle(this.element, 'width'));
    var h = parseInt(Element.getStyle(this.element, 'height'));

    var pOffset = Position.cumulativeOffset(Position.offsetParent(this.element));

    var left = (Element.getWindowWidth() - w) / 2;
    var top = (Element.getWindowHeight() - h) / 2;
    var scrollTop = (document.documentElement.scrollTop || document.body.scrollTop);
    var scrollLeft = (document.documentElement.scrollLeft || document.body.scrollLeft);

    top += scrollTop - pOffset[1];
    left += scrollLeft - pOffset[0];
    top = ((top + pOffset[1]) >= 0) ? top : 0 - pOffset[1];
    left = ((left + pOffset[0]) >= 0) ? left : 0 - pOffset[0];
    Element.setStyle(this.element, {left: left + 'px', top: top + 'px'});
  },

  enableResizing: function() {
    var resTop = this.options.resizeY ? 6 : 0;
    var resBottom = this.options.resizeY ? 6 : 0;
    var resLeft = this.options.resizeX ? 6 : 0;
    var resRight = this.options.resizeX ? 6 : 0;
    this.resizeable = new ResizeableWindowEx(this.element, { 
      top:         resTop,
      bottom:      resBottom,
      left:        resLeft,
      right:       resRight,
      minWidth:    this.options.minWidth,
      minHeight:   this.options.minHeight,
      draw:        this.setBodyHeight.bind(this),
      resize:      this.options.endResize,
      restriction: this.options.restriction,
      zindex:      2000
    });
  },

  disableResizing: function() {
    this.resizeable.destroy();
  },

  appendToBody: function() {
    this.removeFromBody(this.element.id)
    document.body.appendChild(this.element);
  },
  
  removeFromBody: function(dom_id) {
    $A(document.body.childNodes).each(function(node){
      if (node.id == dom_id) node.remove();
    });
  }
}


// Copyright (c) 2005 spinelz.org (http://script.spinelz.org/)
// 
// This code is substantially based on code from script.aculo.us which has the 
// following copyright and permission notice
//
// Copyright (c) 2005 Thomas Fuchs (http://script.aculo.us, http://mir.aculo.us)
// 
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

var DraggableWindowEx = Class.create();
Object.extend(DraggableWindowEx.prototype, Draggable.prototype);
Object.extend(DraggableWindowEx.prototype, {
  initDrag: function(event) {
    if(Event.isLeftClick(event)) {    
      // abort on form elements, fixes a Firefox issue
      var src = Event.element(event);
      if(src.tagName && (
        src.tagName=='INPUT' ||
        src.tagName=='SELECT' ||
        src.tagName=='OPTION' ||
        src.tagName=='BUTTON' ||
        src.tagName=='TEXTAREA')) return;
        
      if(this.element._revert) {
        this.element._revert.cancel();
        this.element._revert = null;
      }
      
      var pointer = [Event.pointerX(event), Event.pointerY(event)];
      var pos     = Position.cumulativeOffset(this.element);
      this.offset = [0,1].map( function(i) { return (pointer[i] - pos[i]) });

      var zIndex = ZindexManager.getIndex();
      this.originalZ = zIndex;
      this.options.zindex = zIndex;
      Element.setStyle(this.element, {zIndex: zIndex});
      
      Draggables.activate(this);
      Event.stop(event);
    }
  },

  endDrag: function(event) {
    if(!this.dragging) return;
    this.stopScrolling();
    this.finishDrag(event, true);

    this.options.endDrag();
    Event.stop(event);
  }
});

