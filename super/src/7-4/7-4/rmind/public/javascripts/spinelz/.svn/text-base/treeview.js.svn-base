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

var TreeView = Class.create();
TreeView.className = {
  top: 'treeview',
  dir: 'treeview_dir',
  dirBody: 'treeview_dirBody',
  dirBodyText: 'treeview_dirBodyText',
  dirBodyTextActive: 'treeview_dirBodyTextActive',
  dirContainer: 'treeview_dirContainer',
  dirContainerHover: 'treeview_dirContainerHover',
  file: 'treeview_file',
  fileBody: 'treeview_fileBody',
  fileBodyText: 'treeview_fileBodyText',
  fileBodyTextActive: 'treeview_fileBodyTextActive',
  state_open: 'treeview_stateOpen',
  state_close: 'treeview_stateClose',
  state_empty: 'treeview_stateEmpty',
  dirIcon: 'treeview_dirIcon',
  fileIcon: 'treeview_fileIcon',
  handle: 'treeview_handle'
}

TreeView.iconId = 'treeview_icon';

TreeView.prototype = {
  initialize: function(element) {
    this.element = $(element);
    Element.setStyle(this.element, {visibility: 'hidden'});
    Element.hide(this.element);

    this.options = Object.extend({
      dirSymbol:         'dir',
      fileSymbol:        'file',
      cssPrefix:         'custom_',
      open:              true,
      callBackFunctions: false,
      dirSelect:         true,
      fileSelect:        true,
      noSelectedInsert:  true,
      iconIdPrefix:      TreeView.iconId,
      move:              false,
      unselected:        Prototype.emptyFunction,
      enableUnselected:  true,
      sortOptions:       {},
      openDir:           Prototype.emptyFunction,
      closeDir:          Prototype.emptyFunction,
      emptyImg:          false,
      initialSelected:   null
    }, arguments[1] || {});

    this.customCss = CssUtil.appendPrefix(this.options.cssPrefix, TreeView.className);
    this.classNames = new CssUtil([TreeView.className, this.customCss]);

    this.changeClassNameDirAndFile(this.element);
    var nodes = this.element.childNodes;
    for (var i = 0; i < nodes.length; i++) {
      this.build(nodes[i]);
    }

    this.classNames.addClassNames(this.element, 'top');
    Element.setStyle(this.element, {visibility: 'visible'});
    Element.show(this.element);

    if (this.options.initialSelected) {
      this.selectEffect(this.options.initialSelected);
    }

    if (this.options.move) {
      this.setSortable();
    }
  },

  addChildById: function(element, parent, number) {
    element = $(element);
    parent = $(parent);

    var container = null;
    if (!element || !parent)
      return;
    else if (Element.hasClassName(parent, TreeView.className.dir))
      container = this.getChildDirContainer(parent);
    else if (Element.hasClassName(parent, TreeView.className.top))
      container = parent;
    else
      return;

    this.build(element);

    if (isNaN(number)) {
      container.appendChild(element);
    } else {
      var children = this.getDirectoryContents(container);
      if (children[number]) container.insertBefore(element, children[number]);
      else container.appendChild(element);
    }

    this.refreshStateImg(parent);
    if (this.options.dragAdrop) this.setSortable();
  },

  addChildByPath: function(element, path) {
    element = $(element);
    if (element) this.build(element);
    else return;

    var paths = path.split('/').findAll(function(elm) {
      return (elm != '');
    });

    var last = paths.pop();
    var container = this.search(paths.join('/'));

    var children = this.getDirectoryContents(container);

    if(children[last])
      container.insertBefore(element, children[last]);
    else
      container.appendChild(element);

    this.refreshStateImg(container.parentNode);
    if (this.options.dragAdrop) this.setSortable();
  },

  addChildBySelected: function(element, number) {
    if (!this.selected && !this.options.noSelectedInsert) return;

    if (this.selected)
      this.addChildById(element, this.selected, number);
    else
      this.addChildById(element, this.element, number);
  },

  addSelectItemCallback: function(functionObj) {
    if (!this.options.callBackFunctions) {
      this.options.callBackFunctions = new Array();
    }
    this.options.callBackFunctions.push(functionObj);
  },

  build: function(element) {
    if (element.nodeType != 1) return;

    Element.cleanWhitespace(element);
    this.changeClassNameDirAndFile(element);

    if (Element.hasClassName(element, TreeView.className.dir)) {
      var container = this.createDirectoryContainer(element);
      var body;
      if (this.hasContents(container))
        body = this.createDirectoryBody(element, false);
      else
        body = this.createDirectoryBody(element, true);

      element.appendChild(body);
      element.appendChild(container);

      var nodes = container.childNodes;
      for (var i = 0; i < nodes.length; i++) {
        this.build(nodes[i]);
      }
    } else if (Element.hasClassName(element, TreeView.className.file)) {
      var created = this.createFileBody(element);
      element.appendChild(created);
    }
  },

  changeClassName: function(element, to, from) {
    var nodes = document.getElementsByClassName(from, element);

    var newClassName = this.classNames.joinClassNames(to);
    nodes.each(function(n) {
      n.className = n.className.replace(new RegExp(from), newClassName);
    });

    if (Element.hasClassName(element, from)) {
      element.className = element.className.replace(new RegExp(from), newClassName);
    }
  },

  changeClassNameDirAndFile: function(element) {
    this.changeClassName(element, 'dir', this.options.dirSymbol);
    this.changeClassName(element, 'file', this.options.fileSymbol);
  },

  convertJSON: function() {
    return JSON.stringify(this.parse());
  },

  createDirectoryBody: function(element, isEmpty) {
    var customClass = null;
    var dirBodyClass = this.classNames.joinClassNames('dir');
    if (element.className != dirBodyClass) {
      customClass  = element.className.replace(new RegExp(dirBodyClass + ' '), '');
      element.className = dirBodyClass;
    }

    var bodyNodes = new Array();
    var state;
    if (isEmpty && !this.options.emptyImg)
      state = 'state_empty';
    else if (this.options.open)
      state = 'state_open';
    else
      state = 'state_close';

    var id = this.options.iconIdPrefix.appendSuffix(element.id);
    var stateImg = Builder.node('DIV', {id: id.appendSuffix('stateImg')});
    this.classNames.addClassNames(stateImg, state);
    Event.observe(stateImg, "click", this.toggle.bindAsEventListener(this));

    var itemImg = Builder.node('DIV', {id: id});
    this.classNames.addClassNames(itemImg, 'dirIcon');
    if (customClass) {
      Element.addClassName(itemImg, customClass);
    }
    this.classNames.addClassNames(itemImg, 'handle');

    var bodyText = Builder.node('SPAN', this.getDirectoryText(element));
    this.classNames.addClassNames(bodyText, 'dirBodyText');

    bodyNodes.push(stateImg);
    bodyNodes.push(itemImg);
    bodyNodes.push(bodyText);

    var body = Builder.node('DIV', bodyNodes);
    this.classNames.addClassNames(body, 'dirBody');
    if (this.options.dirSelect) {
      Event.observe(itemImg, "click", this.selectDirItem.bindAsEventListener(this));
      Event.observe(bodyText, "click", this.selectDirItem.bindAsEventListener(this));
    }

    return body;
  },

  createDirectoryContainer: function(element) {
    var container = element.getElementsByTagName('ul')[0];
    if (!container) {
      container = Builder.node('UL');
    }
    this.classNames.addClassNames(container, 'dirContainer');
    if (!this.options.open) Element.hide(container);
    return container;
  },

  createFileBody: function(element) {
    var customClass = null;
    var fileBodyClass = this.classNames.joinClassNames('file');
    if (element.className != fileBodyClass) {
      customClass  = element.className.replace(new RegExp(fileBodyClass + ' '), '');
      element.className = fileBodyClass;
    }

    var id = this.options.iconIdPrefix.appendSuffix(element.id);
    var itemImg = Builder.node('DIV', {id: id});
    this.classNames.addClassNames(itemImg, 'fileIcon');
    if (customClass) {
      Element.addClassName(itemImg, customClass);
    }
    this.classNames.addClassNames(itemImg, 'handle');

    var bodyText = Builder.node('SPAN', $A(element.childNodes));
    this.classNames.addClassNames(bodyText, 'fileBodyText');

    var children = new Array();
    children.push(itemImg);
    children.push(bodyText);

    var body = Builder.node('DIV', children);
    this.classNames.addClassNames(body, 'fileBody');
    if (this.options.fileSelect) {
      Event.observe(itemImg, "click", this.selectFileItem.bindAsEventListener(this));
      Event.observe(bodyText, "click", this.selectFileItem.bindAsEventListener(this));
    }

    return body;
  },

  getChildBody: function(element) {
    var names = [TreeView.className.fileBody, TreeView.className.dirBody];
    return Element.getFirstElementByClassNames(element, names);
  },

  getChildBodyText: function(element) {
    var names = [
      TreeView.className.fileBodyText,
      TreeView.className.fileBodyTextActive,
      TreeView.className.dirBodyText,
      TreeView.className.dirBodyTextActive
    ];
    return Element.getFirstElementByClassNames(element, names);
  },

  getChildBodyTextNode: function(element) {
    var body = this.getChildBody(element);
    var bodyText = this.getChildBodyText(body);
    return this.searchTextNode(bodyText);
  },

  getChildDir: function(element) {
    return document.getElementsByClassName(TreeView.className.dir, element);
  },

  getChildDirBody: function(element) {
    return document.getElementsByClassName(TreeView.className.dirBody, element)[0];
  },

  getChildDirContainer: function(element) {
    return document.getElementsByClassName(TreeView.className.dirContainer, element)[0];
  },

  getChildStateImg: function(element) {
    var body = this.getChildDirBody(element);
    var names = [
      TreeView.className.state_close,
      TreeView.className.state_open,
      TreeView.className.state_empty
    ];

    return Element.getFirstElementByClassNames(body, names);
  },

  getChildren: function(element, ignoreDir, ignoreFile) {
    var parent;
    var children = new Array();
    if(element) {
      parent = $(element).getElementsByTagName('ul')[0];
    } else {
      parent = this.element;
    }
    $A(Element.getTagNodes(parent)).each(
      function(node) {
        if(!ignoreDir && Element.hasClassName(node, TreeView.className.dir)) {
          children.push(node);
        }
        if(!ignoreFile && Element.hasClassName(node, TreeView.className.file)) {
          children.push(node);
        }
      }
    );
    return children;
  },

  getDirectoryContents: function(element) {
    return $A(element.childNodes).findAll(function(child) {
      if ((child.nodeType != 1)) {
        return false;
      }
      if (child.tagName.toLowerCase() == 'li') {
        return true;
      }
      return false;
    });
  },

  getDirectoryText: function(element) {
    return $A(element.childNodes).findAll(function(child) {
      if ((child.nodeType != 1)) {
        return true;
      } else if (child.tagName.toLowerCase() != 'ul') {
        return true;
      }
      return false;
    });
  },

  getHierarchyNumber: function() {
    if (!this.selected) return;
    var element = this.selected;
    var i = 0;
    while (true) {
      if (this.element == element) {
        return i;
      } else {
        element = this.getParentDir(element, true);
        if (!element) return;
        i++;
      }
    }
  },

  getParentDir: function(element, top) {
    var result = Element.getParentByClassName(TreeView.className.dir, element);
    if (!result && top)
      result = Element.getParentByClassName(TreeView.className.top, element);
    return result;
  },

  hasContents: function(element) {
    if (element) {
      if (!Element.hasClassName(element, TreeView.className.dirContainer) &&
          !Element.hasClassName(element, TreeView.className.top)) {
        return false;
      }

      var nodes = element.childNodes;
      for (var i = 0; i < nodes.length; i++) {
        if (nodes[i].nodeType == 1) {
          if (Element.hasClassName(nodes[i], TreeView.className.dir) ||
              Element.hasClassName(nodes[i], TreeView.className.file)) {
            return true;
          }
        }
      }
    }
    return false;
  },

  parse: function(container) {
    if (!container) container = this.element;

    var itemList = [];
    var contents = this.getDirectoryContents(container);

    for (var i = 0; i < contents.length; i++) {
      var node = contents[i];
      var body = this.getChildBody(node);
      var text = this.getChildBodyText(body);

      var item = {};
      item.id = node.id;

      item.name = Element.collectTextNodes(text).replace(/\n/, '');
      if (Element.hasClassName(node, TreeView.className.dir)) {
        item.type = this.options.dirSymbol;
        item.contents = this.parse(this.getChildDirContainer(node));

      } else {
        item.type = this.options.fileSymbol;
       }

       itemList.push(item);
    }

    return itemList;
  },

  refreshStateImg: function(element) {
    if (!Element.hasClassName(element, TreeView.className.dir)) return;

    var container = this.getChildDirContainer(element);
    var img = this.getChildStateImg(element);

    if (!this.hasContents(container) && !this.options.emptyImg)
      this.classNames.refreshClassNames(img, 'state_empty');
    else if (Element.visible(container))
      this.classNames.refreshClassNames(img, 'state_open');
    else
      this.classNames.refreshClassNames(img, 'state_close');
  },

  removeById: function(element) {
    element = $(element);
    if (element) {
      var parent = element.parentNode.parentNode;
      Element.remove(element);
      this.refreshStateImg(parent);
    }
  },

  removeByPath: function(path) {
    var paths = path.split('/').findAll(function(elm) {
      return (elm != '');
    });

    var last = paths.pop();
    var container = this.search(paths.join('/'));

    var target = this.getDirectoryContents(container)[last];
    if (target)
      this.removeById(target);
  },

  removeBySelected: function() {
    if (!this.selected) return;
    this.removeById(this.selected);
    this.selected = false;
  },

  renameById: function(name, element) {
    element = $(element);
    if (!Element.hasClassName(element, TreeView.className.dir) &&
        !Element.hasClassName(element, TreeView.className.file)) {
      return;
    }
    var node = this.getChildBodyTextNode(element);
    node.nodeValue = name;
  },

  renameByPath: function(name, path) {
    var paths = path.split('/').findAll(function(elm) {
      return (elm != '');
    });

    var last = paths.pop();
    var container = this.search(paths.join('/'));

    var target = this.getDirectoryContents(container)[last];
    if (target)
      this.renameById(name, target);
  },

  renameBySelected: function(name) {
    if (!this.selected) return;
    this.renameById(name, this.selected);
  },

  search: function(path) {
    var paths = path.split('/').findAll(function(elm) {
      return (elm != '');
    });

    var container = this.element;
    for (var i = 0; i < paths.length; i++) {
      var num = paths[i];
      var contents = this.getDirectoryContents(container);
      if (contents[num] && Element.hasClassName(contents[num], TreeView.className.dir)) {
        container = this.getChildDirContainer(contents[num]);
      } else {
        return false;
      }
    }
    return container;
  },

  searchTextNode: function(element) {
    var text = null;
    var nodes = element.childNodes;

    for (var i = 0; i < nodes.length; i++) {
      if (nodes[i].nodeType == 3) {
        text = nodes[i];
        break;
      } else if (nodes[i].nodeType == 1) {
        var tmp = this.searchTextNode(nodes[i]);
        if (tmp) {
          text = tmp;
          break;
        }
      }
    }
    return text;
  },

  selectDirItem: function(event) {
    var itemBody = Element.getParentByClassName(TreeView.className.dirBody, Event.element(event));
    this.selectItem(itemBody);
  },

  selectEffect: function(element) {
    element = $(element);
    if(element) {
      var itemBody = element.firstChild;
      if (this.selectItemUnselect(itemBody, false)) {
        return;
      }
      this.selectItemSelect(itemBody, false);
    }
  },

  selectFileItem: function(event) {
    var itemBody = Element.getParentByClassName(TreeView.className.fileBody, Event.element(event));
    this.selectItem(itemBody);
  },

  selectItem: function(itemBody) {
    if (this.selectItemUnselect(itemBody, true)) {
      return;
    }
    this.selectItemSelect(itemBody, true);
  },

  selectItemSelect: function(itemBody, callback) {
    this.selected = itemBody.parentNode;
    var text = this.getChildBodyText(itemBody);
    if (Element.hasClassName(text, TreeView.className.dirBodyText)) {
      this.classNames.refreshClassNames(text, 'dirBodyTextActive');
      this.defaultCss = 'dirBodyText';
    } else if (Element.hasClassName(text, TreeView.className.fileBodyText)) {
      this.classNames.refreshClassNames(text, 'fileBodyTextActive');
      this.defaultCss = 'fileBodyText';
    }
    if (callback) {
      if (this.options.callBackFunctions) {
        for (var i = 0; i < this.options.callBackFunctions.length; i++) {
          this.options.callBackFunctions[i](itemBody.parentNode);
        }
      }
    }
  },

  selectItemUnselect: function(itemBody, callback) {
    if (this.selected) {
      var selectedBody = this.getChildBody(this.selected);
      var selectedText = this.getChildBodyText(selectedBody);
      this.classNames.refreshClassNames(selectedText, this.defaultCss);
      if (this.selected == itemBody.parentNode && this.options.enableUnselected) {
        this.selected = false;
        this.defaultCss = false;
        if (callback) {
          this.options.unselected();
        }
        return true;
      }
    }
    return false;
  },

  setSortable: function() {
    var options = Object.extend({
      dropOnEmpty: true,
      tree: true,
      hoverclass: 'treeview_dirContainerHover',
      scroll: window,
      ghosting: true
    }, this.options.sortOptions);
    Sortable.create(this.element, options);
  },

  toggle: function(event) {
    Event.stop(event);
    var src = Event.element(event);
    var parent = this.getParentDir(src);
    var container = this.getChildDirContainer(parent);

    if (!this.hasContents(container) && !this.options.emptyImg) return;

    Element.toggle(container);
    this.refreshStateImg(parent);

    if (!this.hasContents(container) && !this.options.emptyImg)
      this.options.openDir(parent, container);
    else if (Element.visible(container))
      this.options.openDir(parent, container);
    else
      this.options.closeDir(parent, container);
  }
}
