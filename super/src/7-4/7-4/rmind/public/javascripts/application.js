// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

Ajax.Responders.register(
    {
        onCreate: function() {
            $('spinner').show() ;
        },
        onComplete: function() {
            if (Ajax.activeRequestCount == 0)
                $('spinner').hide() ;
        }
    }
) ;

var CheckboxWatcher = Class.create() ;
CheckboxWatcher.prototype = {
    initialize: function(chkBox, target) {
        this.chkBox = $(chkBox) ;
        this.chkBox.onclick =
            this.onclick.bindAsEventListener(this) ;
        this.target = target;
    },

    onclick: function(evt) {
        new Ajax.Request(this.target ,
                         {
                             asynchronous:true,
                             evalScripts:true,
                             method:'post'
                         }
                        )
    }
} ;

var SubTitleWithSwitch = Class.create() ;
SubTitleWithSwitch.prototype = {
    initialize: function(header, contents) {
        this.header = $(header) ;
        this.header.addClassName('sub_title') ;
        this.header_text = this.header.innerHTML ;
        this.contents = contents ;
        this.header.onclick =
            this.onclick.bindAsEventListener(this) ;
    },

    onclick: function(evt) {
        contents = $(this.contents) ;
        if (contents.visible()) {
            this.header.addClassName('sub_title_hide') ;
            this.header.innerHTML = this.header_text + '....' ;
            contents.hide() ;
        } else {
            this.header.removeClassName('sub_title_hide') ;
            this.header.innerHTML = this.header_text;
            contents.show() ;
        }
    }
} ;

var TaskWindow = {
    create: function(div_id) {
        var param = {
            modal:false,
            resize: true,
            maxButton: false,
            minButton: false,
            endDrag: this.recordPos ,
            endResize: this.recordPos
        } ;

        this.w = new Window('task_window',param) ;
    },

    show: function() {
        var c = new CookieManager({shelfLife:30});
        var pos = c.getCookie('pos') ;
        if (pos) {
            var x = pos.split(',')[0] ;
            var y = pos.split(',')[1] ;
            Element.setStyle(this.w.element, {left: x, top: y}) ;
        }

        var size = c.getCookie('size') ;
        if (size) {
            var w = size.split(',')[0] ;
            var h = size.split(',')[1] ;
            Element.setStyle(this.w.element, {width: w, height: h}) ;
        }
        if (! Element.visible(this.w.element)) {
            this.w.open();
            if (!pos) {
                this.w.center() ;
            }
        }
    },

    recordPos: function() {
        var win = TaskWindow.w ;
        var pos = [Element.getStyle(win.element, 'left'), Element.getStyle(win.element, 'top')];
        var size = [Element.getStyle(win.element, 'width'), Element.getStyle(win.element, 'height')];
        var c = new CookieManager({shelfLife:30});
        c.setCookie('pos', pos) ;
        c.setCookie('size', size) ;
    }
} ;
