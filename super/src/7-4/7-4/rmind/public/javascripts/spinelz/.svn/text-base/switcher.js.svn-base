var Switcher = Class.create();
Switcher.classNames = {
  open:  'switcher_state_open',
  close: 'switcher_state_close'
}
Switcher.prototype = {
  initialize: function(sw, content) {
    this.options = Object.extend({
      open:        false,
      duration:    0.4,
      beforeOpen:  Prototype.emptyFunction,
      afterOpen:   Prototype.emptyFunction,
      beforeClose: Prototype.emptyFunction,
      afterClose:  Prototype.emptyFunction,
      effect:      false,
      cssPrefix:   'custom_'
    }, arguments[2] || {});

    this.sw = $(sw);
    this.content = $(content);

    var customCss = CssUtil.appendPrefix(this.options.cssPrefix, Switcher.classNames);
    this.classNames = new CssUtil([Switcher.classNames, customCss]);

    if (this.options.open) {
      Element.show(this.content);
      this.classNames.addClassNames(this.sw, 'open');
    } else {
      Element.hide(this.content);
      this.classNames.addClassNames(this.sw, 'close');
    }

    Event.observe(this.sw, 'click', this.toggle.bind(this));
  },

  toggle: function() {
    if (Element.hasClassName(this.sw, Switcher.classNames.close)) {
      this.open();
    }else {
      this.close();
    }
  },

  open: function() {
    this.options.beforeOpen(this.content);
    this.classNames.refreshClassNames(this.sw, 'open');
    if (this.options.effect) {
      new Effect.BlindDown(this.content, {duration: this.options.duration});
    } else {
      Element.show(this.content);
    }
    this.options.afterOpen(this.content);
  },

  close: function() {
    this.options.beforeClose(this.content);
    this.classNames.refreshClassNames(this.sw, 'close');
    if (this.options.effect) {
      new Effect.BlindUp(this.content, {duration: this.options.duration});
    } else {
      Element.hide(this.content);
    }
    this.options.afterClose(this.content);
  }
}
