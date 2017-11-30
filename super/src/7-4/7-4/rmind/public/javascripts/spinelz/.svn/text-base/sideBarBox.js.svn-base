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


SideBarBox = Class.create();

SideBarBox.className = {
  panelContainer : 'sideBarBox_panelContainer',
  tabContainer : 'sideBarBox_tabContainer',
  title : 'sideBarBox_tabTitle',
  tab : 'sideBarBox_tab',
  tabTopInactive : 'sideBarBox_tabTopInactive',
  tabTopActive : 'sideBarBox_tabTopActive',
  tabMiddleInactive : 'sideBarBox_tabMiddleInactive',
  tabMiddleActive : 'sideBarBox_tabMiddleActive',
  tabBottomInactive : 'sideBarBox_tabBottomInactive',
  tabBottomActive : 'sideBarBox_tabBottomActive'  
}

SideBarBox.prototype = {
  
  initialize: function(element) {
    var options = Object.extend({
      selected:     1,
      beforeSelect: function() {return true},
      afterSelect:  Prototype.emptyFunction,
      visible:      false,
      close:        true,
      cssPrefix:    'custom_'
    }, arguments[1] || {});
    
    this.options = options;
    this.element = $(element);
    Element.setStyle(this.element, {visibility: 'hidden'});
    
    var customCss = CssUtil.appendPrefix(this.options.cssPrefix, SideBarBox.className);
    this.classNames = new CssUtil([SideBarBox.className, customCss]);
    
    this.start();
    Element.setStyle(this.element, {visibility: 'visible'});
  },
  
  start: function() {
    this.tabs = [];
    this.panelContents = [];
    this.tabSets = [];
    
    this.visible = this.options.visible;
    this.selected = (this.options.selected > 0) ? this.options.selected - 1 :  0 ;
    this.selected = (this.visible) ? this.selected : -1;
    
    this.tabId = this.element.id + '_tab';
    this.tabTopId = this.tabId + '_top';
    this.tabMiddleId = this.tabId + '_middle';
    this.tabBottomId = this.tabId + '_bottom';
    this.tabContainerId = this.element.id + '_tabContainer';
    this.panelId = this.element.id + '_panel';
    this.panelContainerId = this.element.id + '_panelContainer';

    this.tabContainer = null;  
    this.panelContainer = null;
    
    this.buildTabBox();  
  },
  
  buildTabBox: function() {
    this.buildContainers();
    
    Element.cleanWhitespace(this.element);
    this.tabSets = this.element.childNodes;
    if (this.visible && this.selected >= this.tabSets.length) {
      this.selected = 0;
    }
    var i = 0;
    while(this.tabSets.length > 0){
      var tabSet = this.tabSets[0];
      var tabPanel = $A(tabSet.childNodes).detect(function(c) {
        return (c.nodeType == 1) && (c.tagName.toLowerCase() == 'div');
      });
      this.buildPanel(tabPanel, i);     
      this.buildTab(tabSet, i);
      i++;
    }
    this.addContainers();
  },
  
  buildContainers : function() {
    this.tabContainer = Builder.node('div',{id:this.tabContainerId});
    this.classNames.addClassNames(this.tabContainer, 'tabContainer');
    this.panelContainer = Builder.node('div',
                        {
                          id:this.panelContainerId
                        }
                       );
    this.classNames.addClassNames(this.panelContainer, 'panelContainer');

    if (!this.visible) {
      Element.hide(this.panelContainer);
    }
  },
  
  addContainers : function() {
    this.element.appendChild(this.panelContainer);
    this.element.appendChild(this.tabContainer);
    this.element.appendChild(Builder.node('div', {style:'clear: left'}));
  },
  
  buildTab: function(tab, i) {
    var tabTitle = tab.childNodes;
    tab.id = this.tabId + i;
    this.classNames.addClassNames(tab, 'tab');
    var top = Builder.node('div',{id: this.tabTopId + i});
    var middle = Builder.node('div', {id: this.tabMiddleId + i}, $A(tabTitle));
    var bottom = Builder.node('div', {id: this.tabBottomId + i});
    
    tab.appendChild(top);
    tab.appendChild(middle);
    tab.appendChild(bottom);
    Event.observe(tab, 'click', this.selectTab.bindAsEventListener(this));
    
    this.tabs[i] = tab;
    this.tabContainer.appendChild(tab);
    if ( i != this.selected) {
      this.setTabInactive(tab);
    } else {
      this.setTabActive(tab);
    }
  },
  
  buildPanel: function(panelContent, i) {
    var panel = Builder.node('div', {id: this.panelId + i});
    panel.appendChild(panelContent);
    this.panelContents[i] = panel;
    if(i != this.selected) {
      Element.hide(panel);
    }
    this.panelContainer.appendChild(panel);
  },
  
  selectTab: function(e) {
    if (!this.options.beforeSelect()) return;
    if (!e) {
      this.setTabActive(this.tabs[this.selected]);
      Element.show(this.panelList[this.selected]);
      return;
    }

    var currentPanel = this.panelContents[this.selected];
    var currentTab = this.tabs[this.selected];

    var targetElement = null;
    if (e.nodeType) {
      targetElement = e; 
    } else {
      targetElement = Event.element(e);
    }
    var targetIndex = this.getTargetIndex(targetElement);
    var targetPanel = this.panelContents[targetIndex];
    var targetTab = this.tabs[targetIndex];
    if (this.visible) {
      if (targetTab.id == currentTab.id) {
        if (this.options.close) {
          Effect.SlideRightOutOfView(this.panelContainer);
          this.visible = false;
          this.selected = -1;
          this.setTabInactive(currentTab);
          Element.toggle(targetPanel);
        }
      } else {
        this.setTabActive(targetTab);
        this.setTabInactive(currentTab);
        Element.toggle(currentPanel);
        Element.toggle(targetPanel);
        this.selected = targetIndex;
      }
    } else {
      this.setTabActive(targetTab);
      Element.toggle(targetPanel);
      Effect.SlideRightIntoView(this.panelContainer);
      this.visible = true;  
      this.selected = targetIndex;
    }
    this.options.afterSelect(targetPanel, currentPanel);
  },
  
  setTabActive: function(tab) {
    var tabChildren = tab.childNodes;

    this.classNames.refreshClassNames(tabChildren[0], 'tabTopActive');
    this.classNames.refreshClassNames(tabChildren[1], 'tabMiddleActive');
    this.classNames.refreshClassNames(tabChildren[2], 'tabBottomActive');
  },
  
  setTabInactive: function(tab) {
    var tabChildren = tab.childNodes;
    
    this.classNames.refreshClassNames(tabChildren[0], 'tabTopInactive');
    this.classNames.refreshClassNames(tabChildren[1], 'tabMiddleInactive');
    this.classNames.refreshClassNames(tabChildren[2], 'tabBottomInactive');
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
    return this.panelContents[this.selected];
  },

  getCurrentTab: function() {
    return this.tabs[this.selected];
  }
}
