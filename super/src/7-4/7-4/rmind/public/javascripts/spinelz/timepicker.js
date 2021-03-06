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


/**
 * TimePicker
 */
var TimePicker = Class.create();
TimePicker.className = {
  container:             'timepicker_container',
//  container:             'timepicker',
  header:                'timepicker_header',
  preYears:              'timepicker_preYears',
  nextYears:             'timepicker_nextYears',
  years:                 'timepicker_years',
  mark:                  'timepicker_mark',
  ym:                    'timepicker_ym',
  table:                 'timepicker_table',
  thRight:               'right',
  tdRight:               'right',
  tdBottom:              'bottom',
  date:                  'timepicker_date',
  holiday:               'timepicker_holiday',
  regularHoliday:        'timepicker_regularHoliday',
  schedule:              'timepicker_schedule',
  highlightDay:          'timepicker_highlightDay',
  scheduleListContainer: 'timepicker_scheduleListContainer',
  scheduleItem:          'timepicker_scheduleItem',
  scheduleTimeArea:      'timepicker_scheduleItemTimeArea',
  scheduleHandler:       'timepicker_scheduleHandler',
  holidayName:           'timepicker_holidayName',
  dateContainer:         'timepicker_dateContainer',
  tableHeader:           'timepicker_tableHeader',
  rowContent:            'timepicker_rowContent',
  selected:              'timepicker_selected',
  displayToggle:         'timepicker_displayToggle',

  nextYearMark:          'timepicker_nextYearMark',
  nextMonthMark:         'timepicker_nextMonthMark',
  nextWeekMark:          'timepicker_nextWeekMark',
  preYearMark:           'timepicker_preYearMark',
  preMonthMark:          'timepicker_preMonthMark',
  preWeekMark:           'timepicker_preWeekMark',
  
  weekTable:             'timepicker_weekContainerTable',
  weekMainTable:         'timepicker_weekMainTable',
  timeLine:              'timepicker_timeline',
  timeLineTimeTop:       'timepicker_timelineTimeTop',
  timeLineTime:          'timepicker_timelineTime',
  timeLineTimeIe:        'timepicker_timelineTime_ie',
  timeLineTimeIeTop:     'timepicker_timelineTime_ieTop',
  headerColumn:          'timepicker_headerColumn',
  columnTopDate:         'timepicker_columnTopDate',
  columnDate:            'timepicker_columnDate',
  columnDateOdd:         'timepicker_columnOddDate',
  scheduleItemSamll:     'timepicker_scheduleItemSmall',
  scheduleItemLarge:     'timepicker_scheduleItemLarge',
  scheduleItemSelect:    'timepicker_scheduleItemSelect',
  deleteImg:             'timepicker_deleteImage',
  privateImg:            'timepicker_privateImage',
  scheduleContainer:     'timepicker_weekScheduleContainer',
  selector:              'timepicker_selector',
  cover:                 'timepicker_cover'
}
Object.extend(TimePicker.prototype, Calendar.prototype);
Object.extend(TimePicker.prototype, {
  initialize: function(element) {
    this.options = Object.extend({
      initDate:              new Date(),
      cssPrefix:             'custom_',
      holidays:              [],
      schedules:             [],
      size:                  Calendar.size.large,
      regularHoliday:        [0, 6],
      displayIndexes:        [0, 1, 2, 3, 4, 5, 6],
      displayTime:           [{hour: 0, min: 0}, {hour: 24, min: 0}],
      weekIndex:             0,
      dblclickListener:      null,
      afterSelect:           Prototype.emptyFunction,
      beforeRefresh:         Prototype.emptyFunction,
      changeSchedule:        Prototype.emptyFunction,
      changeCalendar:        Prototype.emptyFunction,
      displayType:           'month',
      highlightDay:          true,
      beforeRemoveSchedule:  function() {return true;},
      dblclickSchedule:      null,
      updateTirm:            Prototype.emptyFunction,
      displayTimeLine:       true,
      clickDateText:         null,
      getMonthHeaderText:    Prototype.emptyFunction,
      getMonthSubHeaderText: Prototype.emptyFunction,
      getWeekHeaderText:     Prototype.emptyFunction,
      getWeekSubHeaderText:  Prototype.emptyFunction,
      getDayHeaderText:      Prototype.emptyFunction,

      setPosition:           true,
      headerTitle:           '',
      standardTime:          false,
      oneDayLabel:           '24H',
      standardTimeLabel:     'standard'
    }, arguments[1] || {});

    if (this.options.standardTime) {
      this.options.displayTime = this.options.standardTime;
      this.options.oneDay      = [{hour: 0, min: 0}, {hour: 24, min: 0}];
    }

    this.element    = $(element);
    this.date       = new Date();
    var customCss   = CssUtil.appendPrefix(this.options.cssPrefix, TimePicker.className);
    this.classNames = new CssUtil([TimePicker.className, customCss]);

    this.builder = new TimePickerBuilder(this);
    this.builder.beforeBuild();
    this.calendar = this.builder.build();
    this.builder.afterBuild();
    this.element.appendChild(this.calendar);
    Element.hide(element);
    Element.setStyle(this.element, {position: 'absolute'});
    
//    Event.observe(document, 'click', this.hide.bind(this));
    Event.observe(document, "mouseup", this.onMouseUp.bindAsEventListener(this));
  },

  refresh: function() {
    this.options.beforeRefresh(this);
    this.destroy();
    this.selectedBase = null;
    Element.remove(this.calendar);
    this.builder = new TimePickerBuilder(this);
    this.builder.beforeBuild();
    this.calendar = this.builder.build();
    this.element.appendChild(this.calendar);
    this.builder.afterBuild();
//    Event.observe(window, 'resize', this.windowResize);
  },

  show: function(event, triggerId) {
    Event.stop(event);
    var pointer = [Event.pointerX(event), Event.pointerY(event)];
    if (this.options.setPosition.constructor == Function) {
      this.options.setPosition(this.element, pointer);
    } else if (this.options.setPosition) {
      var parentOffset = Position.cumulativeOffset(this.element.parentNode);
      Element.setStyle(this.element, {
        left:   pointer[0] - parentOffset[0] + 'px',
        top:    pointer[1] - parentOffset[1] + 'px'
      });
    }
    Element.setStyle(this.element, {zIndex: ZindexManager.getIndex()});
    Element.show(this.element);
    this.builder.setColumnWidth();
    this.builder.setCover();
  },

  hide: function() {
    Element.hide(this.element);
    this.clearSelected();
  },

  setTrigger: function(trigger, targets) {
    trigger = $(trigger);
    Event.observe(trigger, 'click', this.show.bindAsEventListener(this));
  },

  setTargets: function(targets) {
    this.targets = targets;
  },

  onMouseUp: function(event) {
    var calendar = this;
    var dimention = Element.getDimensions(this.element);
    var position = Position.cumulativeOffset(this.element);
    var x = Event.pointerX(event);
    var y = Event.pointerY(event);

    if ((x < position[0]) || ((position[0] + dimention.width) < x) ||
        (y < position[1]) || ((position[1] + dimention.height) < y)) {
      this.hide();
    }

    if (calendar.mouseDown) {
      setTimeout(function() {
        if (calendar.mouseDown) {
          calendar.mouseDown = false;
          calendar.hide();
        }
      }, 10);
    }

    var term = this.builder.getSelectedTerm();
    if (term) {
      var start = term.first();
      var finish = term.last();
      this.setTime(this.targets.start.hour, start.getHours());
      this.setTime(this.targets.start.min, start.getMinutes());
      this.setTime(this.targets.finish.hour, finish.getHours());
      this.setTime(this.targets.finish.min, finish.getMinutes());
      this.hide();
    }
  },

  setTime: function(target, value) {
    $A($(target).options).each(function(option) {
      if (option.value == value) {
        option.selected = true;
      } else {
        option.selected = false;
      }
    });
  }
});


/**
 * TimePickerBuilder
 */
var TimePickerBuilder = Class.create();
Object.extend(TimePickerBuilder.prototype, CalendarDay.prototype);
Object.extend(TimePickerBuilder.prototype, {
  initialize: function(calendar) {
    var day       = calendar.date.getDay();
    this.calendar = calendar;
    this.setDisplayTime();
    this.calendar.options.displayIndexesOld = this.calendar.options.displayIndexes;
    this.calendar.options.displayIndexes    = [day];
    this.calendar.options.weekIndexOld      = this.calendar.options.weekIndex;
    this.calendar.options.weekIndex         = day;
    this.week                               = this.getWeek();
  },

  buildHeader: function() {
    var headerNodes = Builder.node('TR');
    headerNodes.appendChild(this.buildHeaderCenter());
    
    className = this.calendar.classNames.joinClassNames('header');
    var tbody = Builder.node('TBODY', [headerNodes]);
    return Builder.node('TABLE', {className: className}, [tbody]);
  },

  buildHeaderCenter: function() {
    var contents = [];
    var node = Builder.node('SPAN', [this.calendar.options.headerTitle]);
    contents.push(node);
    var container = Builder.node('TD', contents);
    return container;
  },

  buildTimeLine: function() {
    var time = new Date();
    var hour = 0, hoursOfDay = 24;
    time.setHours(hour);
    time.setMinutes(0);
    var nodes = [];
    var timelineClass    = 'timeLineTime';
    var timelineTopClass = 'timeLineTime'
    if (UserAgent.isIE()) {
      timelineClass    = 'timeLineTimeIe';
      timelineTopClass = 'timeLineTimeIeTop';
    }

    var node = Builder.node('DIV');
    this.calendar.classNames.addClassNames(node, 'timeLineTimeTop');
    nodes.push(node);
    while (hour < hoursOfDay) {
      if (this.includeDisplayTime(hour)) {
        node = Builder.node('DIV', [this.formatTime(time)]);
        if (nodes.length == 0) {
          this.calendar.classNames.addClassNames(node, timelineTopClass);
        } else {
          this.calendar.classNames.addClassNames(node, timelineClass);
        }
        nodes.push(node);
      }
      hour++;
      time.setHours(hour);
    }

    var td = Builder.node('TD', nodes);
    this.calendar.classNames.addClassNames(td, 'timeLine');
    return td;
  },
  
  buildCalendarHeader: function() {
    var node = null;
    if (this.calendar.options.displayTime == this.calendar.options.standardTime) {
      node = Builder.node('DIV', [this.calendar.options.oneDayLabel]);
    } else {
      node = Builder.node('DIV', [this.calendar.options.standardTimeLabel]);
    }
    Event.observe(node, 'click', this.toggleDisplayTime.bindAsEventListener(this, node));
    this.calendar.classNames.addClassNames(node, 'headerColumn');
    return Builder.node('TR', [Builder.node('TD', {align: 'center'}, [node])]);
  },

  abstractSelect: function(event, method) {
    var element = this.findClickedElement(event);
    if (element) {
      if (Element.hasClassName(element, TimePicker.className.columnDate) ||
          Element.hasClassName(element, TimePicker.className.columnDateOdd) ||
          Element.hasClassName(element, TimePicker.className.columnTopDate)) {
  
        var date = this.getDate(element);
        method(date, element);
      }
    }
  },

  toggleDisplayTime: function(event, element) {
    Event.stop(event);
//    var text = Element.getTextNodes(element).first().nodeValue;
    if (this.calendar.options.displayTime == this.calendar.options.oneDay) {
      this.calendar.options.displayTime = this.calendar.options.standardTime;
    } else {
      this.calendar.options.displayTime = this.calendar.options.oneDay;
    }
    this.calendar.refresh();
  },

  findClickedElement: function(event) {
    var container = $(this.getScheduleContainerId());
    var position = Position.cumulativeOffset(container);
    var x = Event.pointerX(event) - position[0];
    var y = Event.pointerY(event) - position[1];
    var descendans = this.calendarTable.rows[0].cells[0].getElementsByTagName('div');
    var height = parseInt(Element.getHeight(container), 10) / descendans.length;
    var cellIndex = Math.floor(y / height);
    return descendans[cellIndex];
  },

  beforeBuild: function() {
    this.column = {};
    var rule = CssUtil.getCssRuleBySelectorText('.' + TimePicker.className.columnDate);
    this.column.height = parseInt(rule.style['height'], 10) + 1;
  },

  afterBuild: function() {
    this.setColumnWidth();
    this.setCover();
  }
});
