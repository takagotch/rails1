// Copyright (c) 2005 spinelz.org (http://script.spinelz.org/)
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

TabBox = Class.create();
TabBox.className = {
  tabBox:            'tabBox_tabBox',
  panelContainer:    'tabBox_panelContainer',
  tabContainer:      'tabBox_tabContainer',
  tab:               'tabBox_tab',
  tabLeftInactive:   'tabBox_tabLeftInactive',
  tabLeftActive:     'tabBox_tabLeftActive',
  tabMiddleInactive: 'tabBox_tabMiddleInactive',
  tabMiddleActive:   'tabBox_tabMiddleActive',
  tabRightInactive:  'tabBox_tabRightInactive',
  tabRightActive:    'tabBox_tabRightActive',
  tabTitle:          'tabBox_tabTitle',
  closeButton:       'tabBox_closeButton'
}
TabBox.prototype = {
  
  initialize: function(element) {
    var options = Object.extend({
      selected:         1,
      cssPrefix:        'custom_',
      beforeSelect:     function() {return true},
      afterSelect:      Prototype.emptyFunction,
      onRemove:         function() {return true},
      sortable:         false,
      closeButton:      false,
      afterSort:        Prototype.emptyFunction,
      onSort:           Prototype.emptyFunction,
      lazyLoadUrl:      [],
      onLazyLoad:       Prototype.emptyFunction,
      afterLazyLoad:    Prototype.emptyFunction,
      lazyLoadFailure:  Prototype.emptyFunction,
      failureLimitOver: Prototype.emptyFunction,
      failureLimit:     5,
      tabRow:           null,
      titleLength:      null
    }, arguments[1] || {});
    
    this.options = options;
    this.element = $(element);
    Element.setStyle(this.element, {visibility: 'hidden'});
    Element.hide(this.element);
    this.selected = (this.options.selected > 0) ? this.options.selected - 1 :  0 ;
    
    var customCss = CssUtil.appendPrefix(this.options.cssPrefix, TabBox.className);
    this.classNames = new CssUtil([TabBox.className, customCss]);
    this.classNames.addClassNames(this.element, 'tabBox');
        
    this.start();
    Element.setStyle(this.element, {visibility: 'visible'});
    Element.show(this.element);

    if (this.options.lazyLoadUrl.length > 0) this.lazyLoad(0);
  },
  
  start: function() {
    this.tabs = [];
    this.panelList = [];

    this.tabId = this.element.id + '_tab';
    this.tabLeftId = this.tabId + '_left';
    this.tabMiddleId = this.tabId + '_middle';
    this.tabRightId = this.tabId + '_right';
    this.tabContainerId = this.element.id + '_tabContainer';
    this.panelId = this.element.id + '_panel';
    this.panelContainerId = this.element.id + '_panelContainer';
    
    this.tabContainer = null;  
    this.panelContainer = null;
    this.build();  
    if (this.options.sortable) this.setDrag();
  },

  setDrag: function() {
    Sortable.create(this.tabContainerId, {
      tag:         'div',
      overlap:     'horizontal',
      constraint:  'horizontal',
      onChange:    this.options.onSort,
      onUpdate:    this.options.afterSort,
      starteffect: Prototype.emptyFunction,
      endeffect:   Prototype.emptyFunction
    });
  },
  
  build: function() {
    this.buildContainers();
    
    Element.cleanWhitespace(this.element);
    var tabSets = this.element.childNodes;
    
    if (tabSets.length <= this.selected) {
      this.selected = 0;
    }
    var i = 0;
    while(tabSets.length > 0) {
      this.buildTabSet(tabSets[0], i);
      i++;
    }
    this.addContainers();
    this.selectTab();
  },

  buildTabSet: function(element, i) {
    if (element.nodeType != 1) {
      Element.remove(element);
      return;
    }
    Element.cleanWhitespace(element);
    var panelContents = element.childNodes[1];
    this.buildPanel(panelContents, i);      
    this.buildTab(element, i);
  },

  buildContainers : function() {
    this.tabContainer = Builder.node('div',{id:this.tabContainerId});
    this.classNames.addClassNames(this.tabContainer, 'tabContainer');
    
    this.panelContainer = Builder.node('div', {id:this.panelContainerId});
    this.classNames.addClassNames(this.panelContainer, 'panelContainer'); 
  },
  
  addContainers : function() {
    this.element.appendChild(this.tabContainer);
    this.element.appendChild(this.panelContainer);
  },

  buildTab: function(tab, i) {
    tab.id = this.tabId + i
    this.classNames.addClassNames(tab, 'tab');
    var tabTitle = Builder.node('div', [$A(tab.childNodes)]);    
    this.classNames.addClassNames(tabTitle, 'tabTitle');
    var tabLeft = Builder.node('div', {id:this.tabLeftId + i});
    var tabMiddle = Builder.node('div', {id:this.tabMiddleId + i}, [tabTitle]);
    var tabRight = Builder.node('div',{id:this.tabRightId + i});
    
    tab.appendChild(tabLeft);
    tab.appendChild(tabMiddle);
    tab.appendChild(tabRight);
    Event.observe(tab, 'click', this.selectTab.bindAsEventListener(this));
    Event.observe(tab, 'mouseover', this.onMouseOver.bindAsEventListener(this));
    Event.observe(tab, 'mouseout', this.onMouseOut.bindAsEventListener(this));

    if (this.options.closeButton) {
      var button = Builder.node('div', {
        id: this.element.id.appendSuffix('closeButton_' + i)
      });
      this.classNames.addClassNames(button, 'closeButton');
      tabMiddle.appendChild(button);
      Event.observe(button, 'click', this.onRemove.bindAsEventListener(this));
    }

    if (this.options.tabRow && !isNaN(this.options.tabRow) && (i % this.options.tabRow == 0)) {
      Element.setStyle(tab, {clear: 'left', styleFloat: 'none'});
    }

    this.setTitle(tabMiddle);
    this.tabs[i] = tab;
    this.setTabInactive(tab);
    this.tabContainer.appendChild(tab);  
  },

  setTitle: function(container) {
    var node = Element.getTextNodes(container, true)[0];
    title = node.nodeValue.replace(/^(\s)*/, '');
    title = title.replace(/(\s)*$/, '');
    var sortTitle = title;
    if (this.options.titleLength && !isNaN(this.options.titleLength)) {
      sortTitle = title.substring(0, this.options.titleLength);
    }
    node.nodeValue = sortTitle;
    container.parentNode.title = title;
  },
  
  buildPanel: function(panelContent, i) {
    var panel = Builder.node('div', {id: this.panelId + i});
    panel.appendChild(panelContent);
    Element.hide(panel);
    this.panelList[i] = panel;
    this.panelContainer.appendChild(panel);
  },
  
  selectTab: function(e){
    if (!this.options.beforeSelect()) return;
    if (!e) {
      this.setTabActive(this.tabs[this.selected]);
      Element.show(this.panelList[this.selected]);
      return;
    }
    var currentPanel = this.getCurrentPanel();
    var currentTab = this.getCurrentTab();
    
    var targetElement = null;
    if (e.nodeType) {
      targetElement = e; 
    } else {
      targetElement = Event.element(e);
    }
    var targetIndex = this.getTargetIndex(targetElement);
    if (targetIndex == this.selected) {
      return;
    }
    var targetPanel = this.panelList[targetIndex];
    var targetTab = this.tabs[targetIndex];
    
    if (currentTab) this.setTabInactive(currentTab);
    this.setTabActive(targetTab);

    if (currentPanel) Element.toggle(currentPanel);
    Element.toggle(targetPanel);

    this.selected = targetIndex;
    this.options.afterSelect(targetPanel, currentPanel);
  },
  
  setTabActive: function(tab) {
    var tabChildren = tab.childNodes;
    this.classNames.refreshClassNames(tabChildren[0], 'tabLeftActive');
    this.classNames.refreshClassNames(tabChildren[1], 'tabMiddleActive');
    this.classNames.refreshClassNames(tabChildren[2], 'tabRightActive');
  },
  
  setTabInactive: function(tab) {
    var tabChildren = tab.childNodes;
    this.classNames.refreshClassNames(tabChildren[0], 'tabLeftInactive');
    this.classNames.refreshClassNames(tabChildren[1], 'tabMiddleInactive');
    this.classNames.refreshClassNames(tabChildren[2], 'tabRightInactive');
  },

  getTargetIndex: function(element) {
    while(element) {
      if (element.id && element.id.indexOf(this.tabId, 0) >= 0) {
        var index = element.id.substring(this.tabId.length);
        if (!isNaN(index)) {
          return index;
        }
      }
      element = element.parentNode;
    }
  },

  onRemove: function(event) {
    Event.stop(event);
    var element = Event.element(event);
    var index = this.getTargetIndex(element);
    var tab = this.tabs[index];
    if (this.options.onRemove(tab)) {
      this.remove(tab);
    }
  },

  remove: function(tab) {
    if (tab) {
      var index = this.getTargetIndex(tab);
      var nextActiveTab = this.getNextTab();
      if (!nextActiveTab) nextActiveTab = this.getPreviousTab();
      Element.remove(tab);
      Element.remove(this.panelList[index]);
      this.tabs[index] = null;
      this.panelList[index] = null;
  
      if (index == this.selected) {
        if (nextActiveTab) {
          this.selectTab(nextActiveTab);
        }
      }
    }
  },

  addByElement: function(element) {
    this.buildTabSet($(element), this.tabs.length);
    if (this.options.sortable) this.setDrag();
  },

  add: function(title, content) {
    var contents = [];
    var node = Builder.node('div');
    node.innerHTML = title;
    contents.push(node);
    node = Builder.node('div');
    node.innerHTML = content;
    contents.push(node);
    this.addByElement(Builder.node('div', contents));
  },

  lazyLoad: function(index) {
    this.errorCount = 0;
    this.loadedList = [];
    this.load(index);
  },

  load: function(index) {
    var container = this.panelList[index];
    var url = this.options.lazyLoadUrl[index];
    var self = this;
    if (container && url) {
      new Ajax.Updater(
        {success: container},
        url,
        {
          onSuccess: function() {
            self.setLoaded(index);
            self.options.onLazyLoad(container, self);
            self.load(++index);
            if (self.isFinishLazyLoad()) self.options.afterLazyLoad(self);
          },
          onFailure: function() {
            self.errorCount++;
            self.options.lazyLoadFailure(container, self);
            if (self.errorCount <= self.options.failureLimit) {
              self.load(index);
            } else {
              self.options.failureLimitOver(self);
            }
          },
          asynchronous: true, 
          evalScripts: true
        }
      );
    }
  },

  isFinishLazyLoad: function() {
    return this.loadedList.length == this.panelList.length;
  },

  setLoaded: function(i) {
    this.loadedList.push(i);
  },

  onMouseOver: function(event) {
    var targetElement = Event.element(event);
    var targetIndex = this.getTargetIndex(targetElement);
    if (targetIndex != this.selected) {
      var targetTab = this.tabs[targetIndex];
      this.setTabActive(targetTab);
    }
  },

  onMouseOut: function(event) {
    var targetElement = Event.element(event);
    var targetIndex = this.getTargetIndex(targetElement);
    if (targetIndex != this.selected) {
      var targetTab = this.tabs[targetIndex];
      this.setTabInactive(targetTab);
    }
  },

  hasNextTab: function() {
    return this.getNextTab() ? true : false;
  },

  hasPreviousTab: function() {
    return this.getPreviousTab() ? true : false;
  },

  getNextTab: function() {
    return Element.next(this.getCurrentTab());
  },

  getPreviousTab: function() {
    return Element.previous(this.getCurrentTab());
  },

  selectNextTab: function() {
    this.selectTab(this.getNextTab());
  },

  selectPreviousTab: function() {
    this.selectTab(this.getPreviousTab());
  },

  tabCount: function() {
    return this.tabs.inject(0, function(i, t) {
      return t ? ++i : i;
    })
  },

  getCurrentPanel: function() {
    return this.panelList[this.selected];
  },

  getCurrentTab: function() {
    return this.tabs[this.selected];
  }
}
