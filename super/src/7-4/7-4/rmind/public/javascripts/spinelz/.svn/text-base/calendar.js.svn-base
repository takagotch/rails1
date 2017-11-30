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

var Calendar = Class.create();
Calendar.className = {
  container:             'calendar',
  header:                'calendar_header',
  preYears:              'calendar_preYears',
  nextYears:             'calendar_nextYears',
  years:                 'calendar_years',
  mark:                  'calendar_mark',
  ym:                    'calendar_ym',
  table:                 'calendar_table',
  thRight:               'right',
  tdRight:               'right',
  tdBottom:              'bottom',
  date:                  'calendar_date',
  holiday:               'calendar_holiday',
  regularHoliday:        'calendar_regularHoliday',
  schedule:              'calendar_schedule',
  highlightDay:          'calendar_highlightDay',
  scheduleListContainer: 'calendar_scheduleListContainer',
  scheduleItem:          'calendar_scheduleItem',
  scheduleTimeArea:      'calendar_scheduleItemTimeArea',
  scheduleHandler:       'calendar_scheduleHandler',
  holidayName:           'calendar_holidayName',
//  holidayContainer:      'calendar_holidayContainer',
  dateContainer:         'calendar_dateContainer',
  tableHeader:           'calendar_tableHeader',
  rowContent:            'calendar_rowContent',
  selected:              'calendar_selected',

  nextYearMark:          'calendar_nextYearMark',
  nextMonthMark:         'calendar_nextMonthMark',
  nextWeekMark:          'calendar_nextWeekMark',
  preYearMark:           'calendar_preYearMark',
  preMonthMark:          'calendar_preMonthMark',
  preWeekMark:           'calendar_preWeekMark',
  
  weekTable:             'calendar_weekContainerTable',
  weekMainTable:         'calendar_weekMainTable',
  timeLine:              'calendar_timeline',
  timeLineTimeTop:       'calendar_timelineTimeTop',
  timeLineTime:          'calendar_timelineTime',
  headerColumn:          'calendar_headerColumn',
  columnTopDate:         'calendar_columnTopDate',
  columnDate:            'calendar_columnDate',
  columnDateOdd:         'calendar_columnOddDate',
  scheduleItemSamll:     'calendar_scheduleItemSmall',
  scheduleItemLarge:     'calendar_scheduleItemLarge',
  scheduleItemNoBorder:  'calendar_scheduleItemNoBorder',
  scheduleItemSelect:    'calendar_scheduleItemSelect',
  deleteImg:             'calendar_deleteImage',
  privateImg:            'calendar_privateImage',
  scheduleContainer:     'calendar_weekScheduleContainer',
  selector:              'calendar_selector',
  cover:                 'calendar_cover'
}

Calendar.smallClassName = {
  container: 'calendar_small',
  header:    'calendar_header_small',
  calendar:  'calendar_calendar_small',
  table:     'calendar_tableSmall'
}

Calendar.size = {
  large: 'large',
  small: 'small'
}

/**
 * Calendar Class
 */
Calendar.prototype = {
  
  initialize: function(element) {
    this.building = true;
    this.element = $(element);
    Element.setStyle(this.element, {visibility: 'hidden'});
    Element.hide(this.element);

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
      monthHeaderFormat:     null,
      weekHeaderFormat:      null,
      weekSubHeaderFormat:   null,
      dayHeaderFormat:       null,
      dayOfWeek:             DateUtil.dayOfWeek
    }, arguments[1] || {});

    this.options.holidays = this.toHolidayHash(this.options.holidays);
//    this.options.schedules = this.toScheduleHash(this.options.schedules);
    
    this.setIndex();
    
    this.classNames = null;
    if (this.options.size == Calendar.size.large) {
      this.classNames = Calendar.className;
    } else {
      this.classNames = $H({}).merge(Calendar.className);
      this.classNames = this.classNames.merge(Calendar.smallClassName);
    }
    var customCss = CssUtil.appendPrefix(this.options.cssPrefix, this.classNames);
    this.classNames = new CssUtil([this.classNames, customCss]);
    
    this.date = this.options.initDate;
    
    this.calendar = this.build();
    this.element.appendChild(this.calendar);

    Event.observe(document, "mouseup", this.onMouseUp.bindAsEventListener(this));
    Element.setStyle(this.element, {visibility: 'visible'});
    Element.show(this.element);
    this.builder.afterBuild();
    this.windowResize = this.onResize.bind(this);
    if (this.options.size != 'small') Event.observe(window, "resize", this.windowResize);
    this.building = false;
  },

  onResize: function() {
    try {
      var oldDimentions = this.builder.containerDimensions;
      var dimentions    = Element.getDimensions(this.builder.container);
      if (dimentions.height != oldDimentions.height || dimentions.width != oldDimentions.width) {
        this.refresh();
      }
    } catch(e) {}
  },

  destroy: function() {
    Event.stopObserving(window, 'resize', this.windowResize);
  },

  setIndex: function() {
    var options = this.options;
    var bottom  = [];
    var up      = [];
    var index   = null;
    options.displayIndexes.sort();
    options.displayIndexes.each(function(i) {
      if (index == null) {
        if (options.weekIndex <= i) {
          index = i;
          up.push(i);
        } else {
          bottom.push(i);
        }
      } else {
        up.push(i);
      }
    });
    options.displayIndexes = up.concat(bottom);
    this.setLastWday();
  },

  setLastWday: function() {
    var firstIndex = this.options.weekIndex;
    var sat = 6;
    var sun = 0;
    var week = $R(firstIndex, sat, false).toArray();
    if (firstIndex != sun) {
      week = week.concat($R(sun, firstIndex - 1, false).toArray());
    }
    this.lastWday = week.last();
    this.wdays = week;
  },
  
  build: function() {
    if (this.builder) {
      this.builder.destroy();
    }
    
    if (this.options.displayType == 'week') {
      this.builder = new CalendarWeek(this);
    } else if (this.options.displayType == 'day') {
      this.builder = new CalendarDay(this);
    } else {
      this.builder = new CalendarMonth(this);
    }

    this.builder.beforeBuild();
    return this.builder.build();
  },
  
  /*** Calendar ***/
  /********************************** public method **********************************/
  undo: function() {
    if (this.cached) {
      this.cached.start = this.cached.start_old;
      this.cached.finish = this.cached.finish_old;
      this.cached = null;
      this.refreshSchedule();
    }
  },

  hideSatSun: function() {
    var sun = 0;
    var sat = 6;
    this.options.displayIndexes = this.options.displayIndexes.without(sun, sat);
    this.setIndex();
    this.refresh();
  },

  showSatSun: function() {
    var sun     = 0;
    var sat     = 6;
    var indexes = this.options.displayIndexes;
    if (!indexes.include(sun)) {
      indexes.push(sun);
    }
    if (!indexes.include(sat)) {
      indexes.push(sat);
    }
    this.setIndex();
    this.refresh();
  },

  changeDisplayIndexes: function(indexes) {
    this.options.displayIndexes = indexes;
    this.setIndex();
    this.refresh();
  },

  changeDisplayTime: function(time) {
    this.options.displayTime = time;
    this.refresh();
  },

  refresh: function() {
    try {
      if (!this.building) {
        this.building = true;
        this.options.beforeRefresh(this);
        this.destroy();
        this.selectedBase = null;
        Element.remove(this.calendar);
        this.calendar = this.build();
        this.element.appendChild(this.calendar);
        this.builder.afterBuild();
        if (this.options.size != 'small') Event.observe(window, 'resize', this.windowResize);
        this.building = false;
      }
    } catch (e) {}
  },
  
  changeCalendar: function(event) {
    this.builder.changeCalendar(event);
  },

  changeDisplayType: function(type) {
    this.options.displayType = type;
    this.refresh();
  },

  selectDate: function(event) {
    var calendar = this;
    this.abstractSelect(event, function(date, element) {
      if (calendar.selectedBase || calendar.hasSelectedDate()) {
        if (event.ctrlKey) {
          if (Element.hasClassName(element, Calendar.className.selected)) {
            calendar.addSelectedClass(element);
            return;
          }
        } else if (calendar.selectedBase) {
          var selectedId = calendar.selectedBase.id;
          $(selectedId).className = calendar.selectedBase.className;
          calendar.clearSelected();
          if (selectedId == element.id) {
            calendar.selectedBase = null;
            return;
          }
        }
      }

      calendar.selectedBase = {id: element.id, date: date, className: element.className};
      calendar.addSelectedClass(element);
      if (date && calendar.options.displayType == 'month' && calendar.options.size == Calendar.size.small) {
        calendar.options.afterSelect(date, calendar);
      }
    });

    if (calendar.options.displayType != 'month' || calendar.options.size != Calendar.size.small) {
      this.mouseDown = true;
    }
  },

  clearSelect: function() {
    // BETA
    this.selectedBase = null;
    this.clearSelected();
  },

  showDayOfWeek: function(dayOfWeek) {
    var indexes = this.options.displayIndexes;
    this.recurrence(dayOfWeek, function(d) {
      if (!indexes.include(d)) {
        indexes.push(d);
      }
    });
    this.setIndex();
    this.refresh();
  },

  hideDayOfWeek: function(dayOfWeek) {
    var indexes = this.options.displayIndexes;
    var self = this;
    this.recurrence(dayOfWeek, function(d) {
      var index = self.findIndex(indexes, d);
      if (index) {
        indexes.remove(index);
      } else if (!index.isNaN) {
        indexes.shift();
      }
    });
    this.refresh();
  },

  addHoliday: function(object) {
    object = this.inspectArgument(object);
    var newHash = this.toHolidayHash(object);
    this.options.holidays = this.options.holidays.merge(newHash);
    this.refresh();
  },

  removeHoliday: function(date) {
    var calendar = this;
    date = calendar.inspectDateArgument(date);
    if (!date) return;

    this.recurrence(date, function(d) {
      var key = d.toDateString();
      if (calendar.options.holidays[key])
        delete calendar.options.holidays[key];
    });
    this.refresh();
  },

  refreshHoliday: function(object, rebuild) {
    object = this.inspectArgument(object);
    this.options.holidays = this.toHolidayHash(object);
    if (rebuild) this.refresh();
  },

  clearHoliday: function() {
    this.refreshHoliday([], true);
  },

  getHoliday: function(date) {
    date = this.inspectDateArgument(date);
    if (!date) return;

    var calendar = this;
    var holidays = [];
    this.recurrence(date, function(o) {
      var h = calendar.options.holidays[o.toDateString()];
      if (h) holidays.push(h);
    });

    return holidays; 
  },

  addSchedule: function(schedule) {
    var schedules = this.options.schedules;
    if (schedule.constructor == Array) {
      schedule.each(function(s) {
        var find = schedules.detect(function(tmp) {return s.id == tmp.id});
        if (!find) schedules.push(s);
      });
    } else {
      var find = schedules.detect(function(tmp) {return tmp.id == schedule.id});
      if (!find) schedules.push(schedule);
    }
    this.refreshSchedule();
  },

  replaceSchedule: function(schedules) {
    this.options.schedules = schedules;
    this.refreshSchedule();
  },

  removeSchedule: function(ids, refresh) {
    if (ids.constructor != Array) ids = [ids];
    var self = this;
    ids.each(function(id) {
      var index = null;
      self.options.schedules.each(function(s, i) {
        if (s.id == id) {
          index = i;
          throw $break;
        }
      });

      if (index != null) {
        var schedule = self.options.schedules[index];
        if (schedule) {
          self.options.schedules.remove(index);
        }
      }
    });
    if (refresh) this.refreshSchedule();
  },

  refreshSchedule: function() {
    this.builder.scheduleNodes.each(function(node) {
      Element.remove(node);
    });
    this.builder.afterBuild();
  },

  mergeSchedule: function(schedule) {
    var index = -1;
    this.options.schedules.each(function(s, i) {
      if (s.id == schedule.id) {
        index = i;
        throw $break;
      }
    });
    if (index != -1) {
      this.options.schedules[index] = schedule;
      this.refreshSchedule();
    } else {
      this.addSchedule(schedule);
    }
  },

  clearSchedule: function() {
    this.options.schedules = [];
    this.refreshSchedule();
  },

  getSchedule: function(object) {
    var result = [];
    var calendar = this;
    object = this.inspectArgument(object || {});

    this.recurrence(object, function(o) {
      var schedule = calendar.options.schedules[o.date.toDateString()];
      if (!schedule) return;

      if (o.start) {
        schedule = schedule.detect(function(s) {
          return ((s.start.hour == o.start.hour) && (s.start.min == o.start.min));
        });
        if (schedule) result.push(schedule);
      } else if (o.number) {
        schedule = schedule[o.number];
        if (schedule) result.push(schedule);
      } else {
        result = result.concat(schedule);
      }
    });

    return result;
  },

  getSelected: function() {
    return this.element.getElementsByClassName(Calendar.className.selected, this.element);
  },

  changeSchedule: function() {
    var calendar = this;
    return function(drag, drop) {
      var array = drag.id.split('_');
      var i = array.pop();
      var date = array.pop();
      
      date = calendar.getDate(date);    
      var newDate = calendar.getDate(drop);
      
      var schedule = calendar.getSchedule({date: date, number: i});
      if (schedule.length != 1) return;

      schedule = schedule.pop();
      schedule.date = newDate;
      calendar.removeSchedule({date: date, number: i}, false);
      calendar.addSchedule(schedule);

      calendar.options.changeSchedule(schedule);
    }
  },

  getSelectedDates: function() {
    return this.builder.getSelectedDates();
  },

  getSelectedTerm: function() {
    return this.builder.getSelectedTerm();
  },
  
  /********************************** private method **********************************/
  abstractSelect: function(event, method) {
    this.builder.abstractSelect(event, method);
  },

  createRange: function(a, b) {
    var range = null;
    if (a <= b)
      range = $R(a, b);
    else
      range = $R(b, a);
    return range;
  },

  formatTime: function(time) {
    var hour = (time.hour < 10) ? '0' + time.hour : time.hour;
    var min = (time.min < 10) ? '0' + time.min : time.min;
    return hour + ':' + min;
  },

  clearSelected: function() {
    var elements = this.getSelected();
    var self = this;
    elements.each(function(e) {
      if (Element.hasClassName(e, Calendar.className.selected))
        self.removeSelectedClass(e);
    });
  },

  onDblClick: function(event) {
    this.abstractSelect(event, this.options.dblclickListener);
  },

  onMouseUp: function(event) {
    var e = event || window.event;
    var calendar = this;
    if (calendar.mouseDown) {
      setTimeout(function() {
        calendar.mouseDown = false;
        calendar.options.afterSelect(event);
      }, 10);
    }
  },

  setRegularHolidayClass: function(node) {
    this.classNames.refreshClassNames(node, 'regularHoliday');
  },

  setHolidayClass: function(node) {
    this.classNames.refreshClassNames(node, 'holiday');
  },

  setWorkdayClass: function(node) {
    this.classNames.refreshClassNames(node, 'date');
  },

  setScheduleClass: function(node) {
    this.classNames.refreshClassNames(node, 'schedule');
  },

  addHighlightClass: function(node) {
    Element.addClassName(node, Calendar.className.highlightDay);
  },

  addSelectedClass: function(node) {
    Element.addClassName(node, Calendar.className.selected);
  },

  removeSelectedClass: function(node) {
    Element.removeClassName(node, Calendar.className.selected);
  },

  getDatasWithMonthAndYear: function(array) {
    var calendar = this;
    var result =  array.findAll(function(h) {
      return calendar.isSameYearAndMonth(h.date);
    });

    return result;
  },

  isSameYearAndMonth: function(a, b) {
    if (a.constructor == Date) {
      if (!b) b = this.date;
      return ((a.getYear() == b.getYear()) && (a.getMonth() == b.getMonth()));
    } else {
      return (a.year == b.year && a.month == b.month && a.day == a.day);
    }
  }, 

  isSameDate: function(a, b) {
    if (a.constructor == Date) {
      if (!b) b = this.date;
      return (this.isSameYearAndMonth(a, b) && (a.getDate() == b.getDate()));
    } else {
      return (this.isSameYearAndMonth(a, b) && a.day == b.day);
    }
  }, 

  isSameTime: function(a, b) {
    return ((a.hour == b.hour) && (a.min == b.min));
  },

  betweenDate: function(schedule, date) {
    var start  = this.toDateNumber(schedule.start);
    var finish = this.toDateNumber(schedule.finish);
    date = this.toDateNumber(date);
    return start <= date && date <= finish;
  },

  toDateNumber: function(date) {
    if (date.constructor == Date) {
      return date.getFullYear() * 10000 + date.getMonth() * 100 + date.getDate();
    } else {
      return date.year * 10000 + date.month * 100 + date.day;
    }
  },

  getTimeDiff: function(a, b) {
    var time = {hour: b.hour - a.hour, min: b.min - a.min};
    if (time.min >= 60) {
      time.hour++;
      time.min -= 60;
    } else if (time.min < 0) {
      time.hour--;
      time.min += 60;
    }
    return time;
  },

  findIndex: function(array, value) {
    var index = null;
    array.each(function(v, i) {
      if (v == value) {
        index = i;
        throw $break;
      }
    });
    return index;
  },

  recurrence: function(object, method) {
    var calendar = this;
    if (object.constructor == Array) {
      object.each(function(o) {calendar.recurrence(o, method)});
    } else if (object.keys) {
      object.each(function(pair) {calendar.recurrence(pair[1], method)});
    } else {
      method(object);
    }
  },

  toHolidayHash: function(object) {
    var calendar = this;
    var hash = {};

    this.recurrence(object, function(o) {
      if (!o.name) return;
      if (o.date.constructor == Object)
        o.date = new Date(o.date.year, o.date.month, o.date.day);

      hash[o.date.toDateString()] = o;
    });
    return $H(hash);
  },

//  toScheduleHash: function(object) {
//    var calendar = this;
//    var hash = {};
//
//    this.recurrence(object, function(o) {
//      if (!o.description) return;
//      if (o.date.constructor == Object)
//        o.date = new Date(o.date.year, o.date.month, o.date.day);
//
//      var date = o.date.toDateString();
//      o.date = date;
//
//      if (hash[date]) {
//        hash[date].push(o);
//        hash[date].sort(calendar.sortSchedule);
//      } else {
//        hash[date] = [o];
//      }
//    });
//    return $H(hash);
//  },

  inspectArgument: function(object, time) {
    return this.builder.inspectArgument(object, time);
  },

  inspectDateArgument: function(date) {
    return this.builder.inspectDateArgument(date);
  },

  sortSchedule: function(a, b) {
    if (a.start.hour == b.start.hour) {
      if (a.start.min == b.start.min)
        return 0;
      if (a.start.min < b.start.min)
        return -1;
      return 1;
    }
    if (a.start.hour < b.start.hour) return -1;

    return 1;
  },

  hasSelectedDate: function() {
    return (this.getSelected().length != 0);
  },

  getDate: function(element) {
    return this.builder.getDate(element);
  },

  isRegularHoliday: function(day) {
    return this.options.regularHoliday.include(day);
  },

  isHoliday: function(date) {
    return this.options.holidays[date.toDateString()];
  },

  isScheduleDay: function(date) {
    return this.options.schedules[date.toDateString()];
  },

  cacheSchedule: function(schedule) {
    this.cached = schedule;
    schedule.start_old = Object.clone(schedule.start);
    schedule.finish_old = Object.clone(schedule.finish);
  }
}


/**
 * AbstractCalendar Class
 */
var AbstractCalendar = Class.create();
AbstractCalendar.id = {
  container:         'container',
  scheduleContainer: 'scheduleContainer',
  selector:          'selector'
}
AbstractCalendar.prototype = {
  destroy:     Prototype.emptyFunction,
  beforeBuild: Prototype.emptyFunction,

  build: function() {
    this.header = this.buildHeader();
    var node = Builder.node(
      'DIV', 
      {
        id:        this.getContainerId(),
        className: this.calendar.classNames.joinClassNames('container')
      },
      [this.header, this.buildCalendar()]);

    return node;
  },

  buildHeader: function() {
    var headerNodes = Builder.node('TR');
    headerNodes.appendChild(this.buildHeaderLeft());
    headerNodes.appendChild(this.buildHeaderCenter());
    headerNodes.appendChild(this.buildHeaderRight());
    
    className = this.calendar.classNames.joinClassNames('header');
    var tbody = Builder.node('TBODY', [headerNodes]);
    return Builder.node('TABLE', {className: className}, [tbody]);
  },

  buildSelector: function() {
    // create selector
    var selector = Builder.node('DIV', {id: this.getSelectorId()});
    this.calendar.classNames.addClassNames(selector, 'selector');
    Element.setOpacity(selector, 0.6);
    Element.hide(selector);
    Element.setStyle(selector, {zIndex: ZindexManager.getIndex()})
    return selector;
  },

  buildCover: function() {
    this.cover = Builder.node('div', {id: this.calendar.element.id.appendSuffix('cover')});
    this.calendar.classNames.addClassNames(this.cover, 'cover');
    Event.observe(this.cover, 'mousedown', this.calendar.selectDate.bindAsEventListener(this.calendar));
    if (this.calendar.options.displayType != 'month' || this.calendar.options.size != 'samll') {
      Event.observe(this.cover, 'mousemove', this.multipleSelection.bindAsEventListener(this));
    }
    return this.cover;
  },

  buildScheduleContainer: function() {
    this.container = Builder.node('DIV', {style: 'position: relative', id: this.getScheduleContainerId()});
    return this.container;
  },

  // the default is empty.
  // overwride this method.
  setScheduleContainerEvent: Prototype.emptyFunction,

  changeCalendar: function(event) {
    var element = Event.element(event);
    var date    = this.calendar.date;
    var oldDate = new Date(date.toDateString());

    if (Element.hasClassName(element, Calendar.className.preYearMark)) {
      date.setFullYear(date.getFullYear() - 1);
    } else if (Element.hasClassName(element, Calendar.className.preMonthMark)) {
      date.setDate(1);
      date.setMonth(date.getMonth() - 1);
    } else if (Element.hasClassName(element, Calendar.className.preWeekMark)) {
      date.setDate(date.getDate() - 7);
    } else if (Element.hasClassName(element, Calendar.className.nextYearMark)) {
      date.setFullYear(date.getFullYear() + 1);
    } else if (Element.hasClassName(element, Calendar.className.nextMonthMark)) {
      date.setDate(1);
      date.setMonth(date.getMonth() + 1);
    } else if (Element.hasClassName(element, Calendar.className.nextWeekMark)) {
      date.setDate(date.getDate() + 7);
    }

    this.calendar.options.changeCalendar(date, oldDate);
    this.calendar.refresh();
  },

  clickDeleteImage: function(schedule) {
    if (this.calendar.options.beforeRemoveSchedule(schedule)) {
      this.calendar.removeSchedule(schedule.id, true);
    }
  },

  showDeleteImage: function(img) {
    Element.show(img);
  },

  hideDeleteImage: function(img) {
    Element.hide(img);
  },

  _constrain: function(n, lower, upper) {
    if (n > upper) return upper; 
    else if (n < lower) return lower;
    else return n;
  },

  getContainerId: function() {
    return this.calendar.element.id.appendSuffix(AbstractCalendar.id.container);
  },

  getScheduleContainerId: function() {
    return this.calendar.element.id.appendSuffix(AbstractCalendar.id.scheduleContainer);
  },

  setColumnWidth: function() {
    var adjustSize = this.getAdjustSize();
    var container = $(this.getScheduleContainerId()) || this.container;
    var indexes = this.calendar.options.displayIndexes;
    this.column.width = container.offsetWidth / indexes.length - adjustSize;
    if (this.column.width < 0) this.column.width = 0;
  },

  setCover: function() {
    var container = $(this.getScheduleContainerId()) || this.container;
    if (!this.cover) {
      container.appendChild(this.buildCover());
    }
    Element.setStyle(this.cover, {height: Element.getHeight(container) + 'px'});
  },

  getDragDistance: function() {
    var adjustSize = this.getAdjustSize();
//    return [this.column.width + adjustSize, this.column.height];
    return [this.column.width + adjustSize, this.column.height / 2];
  },

  getWeek: function() {
    var date = this.calendar.date;
    var baseDay = date.getDay();
    var baseDayIndex = date.getDay();
    var findBaseDay = false;

    return this.calendar.options.displayIndexes.map(function(week, i) {
      var diff = week - baseDay;
      if (!findBaseDay && (diff > 0)) diff -= 7;
      if (baseDayIndex == week) findBaseDay = true;
      return DateUtil.afterDays(date, diff);
    });
  },

  isSameStartDate: function(schedule, date) {
    return ((date.getFullYear() == schedule.start.year) &&
      (date.getMonth() == schedule.start.month) && (date.getDate() == schedule.start.day));
  },

  isSameFinishDate: function(schedule, date) {
    return ((date.getFullYear() == schedule.finish.year) &&
      (date.getMonth() == schedule.finish.month) && (date.getDate() == schedule.finish.day));
  },

  getSelectorId: function() {
    return this.calendar.element.id.appendSuffix(AbstractCalendar.id.selector);
  },

  clickDateText: function(event, date) {
    Event.stop(event);
    this.calendar.date = date;
    this.calendar.options.displayType = 'day';
    this.calendar.refresh();
  },

  getAdjustSize: function() {
    return UserAgent.isIE() ? 3 : 3;
  },

  setContainerInfo: function() {
    this.container           = $(this.getScheduleContainerId());
    this.containerDimensions = Element.getDimensions(this.container);
    this.containerOffset     = Position.cumulativeOffset(this.container);
  },

  mouseOverSubSchedule: function(items) {
    items.each(function(item) {
      Element.addClassName(item, Calendar.className.scheduleItemSelect);
    });
  },

  mouseOutSubSchedule: function(items) {
    items.each(function(item) {
      Element.removeClassName(item, Calendar.className.scheduleItemSelect);
    });
  },

  toDate: function(hash) {
    return DateUtil.toDate(hash);
  }
}


/**
 * CalenderMonth Class
 */
var CalendarMonth = Class.create();
CalendarMonth.id = {
  year:              'year',
  month:             'month',
  column:            'column',
  nextYear:          'nextYear',
  nextMonth:         'nextMonth',
  preYear:           'preYear',
  preMonth:          'preMonth',
  calTable:          'calTable',
  scheduleContainer: 'scheduleContainer',
  container:         'container'
}
Object.extend(CalendarMonth.prototype, AbstractCalendar.prototype);
Object.extend(CalendarMonth.prototype, {

  initialize: function(calendar) {
    this.calendar = calendar;
    this.week     = this.getWeek();
  },

  /*** Month ***/
  /********************************** build functions **********************************/
  buildHeaderLeft: function() {
    var container = Builder.node('TD');
    this.calendar.classNames.addClassNames(container, 'preYears');

    var id = this.calendar.element.id.appendSuffix(CalendarMonth.id.preYear);
    var node = Builder.node('DIV', {id: id});
    this.calendar.classNames.addClassNames(node, 'preYearMark');
    Event.observe(node, "click", this.calendar.changeCalendar.bindAsEventListener(this.calendar));
    container.appendChild(node);

    id = this.calendar.element.id.appendSuffix(CalendarMonth.id.preMonth);
    node = Builder.node('DIV', {id: id});
    this.calendar.classNames.addClassNames(node, 'preMonthMark');
    Event.observe(node, "click", this.calendar.changeCalendar.bindAsEventListener(this.calendar));
    container.appendChild(node);

    return container;
  },

  buildHeaderCenter: function() {
    var text = [];
    if (this.calendar.options.monthHeaderFormat) {
      var date = this.calendar.date;
      var templ = new Template(this.calendar.options.monthHeaderFormat);
      text = [templ.evaluate({year: date.getFullYear(), month: date.getMonth() + 1}), ' '];
    }
    var contents = [];

    var id = this.calendar.element.id.appendSuffix(CalendarMonth.id.month);
    var node = Builder.node('SPAN', {id: id}, [text[0] || DateUtil.months[this.calendar.date.getMonth()]]);
    this.calendar.classNames.addClassNames(node, 'ym');
    contents.push(node);

    id = this.calendar.element.id.appendSuffix(CalendarMonth.id.year);
    node = Builder.node('SPAN', {id: id}, [text[1] || this.calendar.date.getFullYear()]);
    this.calendar.classNames.addClassNames(node, 'ym');
    contents.push(node);

    var container = Builder.node('TD', contents);
    this.calendar.classNames.addClassNames(container, 'years');

    return container;
  },

  buildHeaderRight: function() {
    var container = Builder.node('TD');
    this.calendar.classNames.addClassNames(container, 'nextYears');

    var id = this.calendar.element.id.appendSuffix(CalendarMonth.id.nextMonth);
    var node = Builder.node('DIV', {id: id});
    this.calendar.classNames.addClassNames(node, 'nextMonthMark');
    Event.observe(node, "click", this.calendar.changeCalendar.bindAsEventListener(this.calendar));
    container.appendChild(node);

    id = this.calendar.element.id.appendSuffix(CalendarMonth.id.nextYear);
    node = Builder.node('DIV', {id: id});
    this.calendar.classNames.addClassNames(node, 'nextYearMark');
    Event.observe(node, "click", this.calendar.changeCalendar.bindAsEventListener(this.calendar));
    container.appendChild(node);

    return container;
  },
  
  buildCalendar: function() {
    var container = Builder.node('DIV');
    var scheduleContainer = Builder.node('DIV',
                              {id: this.getScheduleContainerId(), style: 'position: relative'},
                              [this.buildTableData()]);
    this.setScheduleContainerEvent(scheduleContainer);

    // create selector
    var selector = this.buildSelector();
    scheduleContainer.appendChild(selector);
    return Builder.node('DIV', [this.buildTableHeader(), scheduleContainer]);
  },
  
  buildTableHeader: function() {
    var weekArray = new Array();
    var self      = this;
    var tbody     = Builder.node('TBODY');
    var tr        = Builder.node('TR', weekArray);
    var width     = 100 / this.calendar.options.displayIndexes.length + '%';
    var lastIndex = this.calendar.options.displayIndexes.last();

    tbody.appendChild(tr);

    this.calendar.options.displayIndexes.each(function(i) {
      var id = self.calendar.element.id.appendSuffix(CalendarMonth.id.column);
      var text = self.calendar.options.dayOfWeek[i];
      var node = Builder.node('TH', {id: id.appendSuffix(i)}, [text]);
      node.width = width;
      weekArray.push(node);
      if (lastIndex == i) {
        self.calendar.classNames.addClassNames(node, 'thRight');
      }
      Event.observe(node, 'click', self.selectDay.bindAsEventListener(self));
      tr.appendChild(node);
    });
    
    return Builder.node('TABLE', 
      {className: this.calendar.classNames.joinClassNames('table')}, [tbody]);
  },
  
  buildTableData: function() {
    var indexes   = this.calendar.options.displayIndexes;
    var today     = new Date();
    var year      = this.calendar.date.getFullYear();
    var month     = this.calendar.date.getMonth();
    var firstDay  = DateUtil.getFirstDate(year, month).getDay();
    var lastDate  = DateUtil.getLastDate(year, month).getDate();
    var trs       = new Array();
    var tds       = new Array();
    var width     = 100 / indexes.length + '%';
    var lastIndex = indexes.last();
    var node, hday, sday, tmp_date, isOutside, i = null;

    // set start index
    var weekIndex = this.calendar.options.weekIndex;
    var length    = DateUtil.dayOfWeek.length * 5;
    var i         = null;
    var day       = 1;
    if (weekIndex <= firstDay) {
      i = weekIndex;
      length += i;
    } else {
      i = weekIndex - 7;
      length -= i;
    }

    var diff = firstDay - weekIndex;
    if (diff < 0) diff + indexes.length;
    if ((lastDate + diff) > length) {
      length += indexes.length;
    }

    var wday = weekIndex;
    
    var find = 0;
    for (; i < length; i++) {
      if (indexes.include(wday)) {
        if (i < firstDay) {
          tmp_date = new Date(
            this.calendar.date.getFullYear(),
            this.calendar.date.getMonth(),
            i - firstDay + 1
          );
          node = Builder.node('TD');
          node.innerHTML = '&nbsp;';
          node.date = tmp_date;
          node.width = width;
          tds.push(node);
        } else if (day > lastDate) {
          tmp_date = new Date(
            this.calendar.date.getFullYear(),
            this.calendar.date.getMonth(),
            day
          );
          node = Builder.node('TD');
          node.innerHTML = '&nbsp;';
          node.date = tmp_date;
          tds.push(node);
        } else {
          if (i == firstDay) length += find;
          tmp_date = new Date(
            this.calendar.date.getFullYear(),
            this.calendar.date.getMonth(),
            day
          );
          hday = this.calendar.options.holidays[tmp_date.toDateString()];

          if (this.calendar.options.size == Calendar.size.large) {
            node = this.buildLargeRow(tmp_date, hday, sday, today);
            if (this.calendar.options.dblclickListener) {
              Event.observe(node, 'dblclick', this.calendar.onDblClick.bindAsEventListener(this.calendar));
            }
          } else {
            sday = this.calendar.options.schedules.detect(function(schedule) {
              var startDate = DateUtil.toDate(schedule.start);
              return tmp_date.sameDate(startDate)
            });
            node = this.buildSmallRow(tmp_date, hday, sday, today);
            Event.observe(node, 'mousedown', this.calendar.selectDate.bindAsEventListener(this.calendar));
          }

          node.width = width;
          node.date = tmp_date;

          tds.push(node);
        }
        find++;
      }

      if (i >= firstDay) {
        day++;
      }

      if (wday == lastIndex) {
        trs.push(Builder.node('TR', tds));
        this.calendar.classNames.addClassNames(tds[tds.length - 1], 'tdRight');
        tds = new Array();
      }

      if (wday >= 6) {
        wday = 0;
      } else {
        wday++;
      }
    }

    this.rowMax = trs.length - 1;
    var tbody = Builder.node('TBODY', [trs]);
    this.calendarTable = Builder.node(
    'TABLE', 
    {
      id:        this.getCalendarTableId(),
      className: this.calendar.classNames.joinClassNames('table')
    },
    [tbody]);
    return this.calendarTable;
  },

  buildLargeRow: function(date, holiday, schedule, today) {
    var calendar      = this;
    var row           = Builder.node('TD', {id: this.getDateId(date)});
    var dateContainer = Builder.node('DIV');

    this.calendar.classNames.addClassNames(dateContainer, 'dateContainer');
    row.appendChild(dateContainer);

    var dateNode = null;
    var clickDateText = this.calendar.options.clickDateText;
    if (clickDateText) {
      dateNode = Builder.node('A', {href: '#'}, [date.getDate()]);
      Event.observe(dateContainer, 'mousedown', clickDateText.bindAsEventListener(this, date));
    } else if (clickDateText == null) {
      dateNode = Builder.node('A', {href: '#'}, [date.getDate()]);
      Event.observe(dateContainer, 'mousedown', this.clickDateText.bindAsEventListener(this, date));
    } else {
      dateNode = Builder.node('SPAN', [date.getDate()]);
      Element.setStyle(dateNode, {textDecoration: 'none'});
    }
    if (date.days() == today.days()) {
      this.calendar.addHighlightClass(dateNode);
    }
    dateContainer.appendChild(dateNode);

    if (holiday) {
      this.calendar.setHolidayClass(row);
      var name = Builder.node(
        'SPAN', 
        {className: this.calendar.classNames.joinClassNames('holidayName')},
        holiday.name
      );
      dateContainer.appendChild(name);
      if (holiday.onclick) {
        Event.observe(name, "click", holiday.onclick.bindAsEventListener(this));
      }
    } else if (this.calendar.isRegularHoliday(date.getDay())) {
      this.calendar.setRegularHolidayClass(row);
    } else {
      this.calendar.setWorkdayClass(row);
    }

    return row;
  },

  buildSmallRow: function(date, holiday, schedule, today) {
    var row = Builder.node('TD', {id: this.getDateId(date)}, [date.getDate()]);
    if (schedule) {
      this.calendar.setScheduleClass(row);
      var first = schedule[0];
      if (first) row.title = first.description.stripTags();
    } else if (holiday) {
      this.calendar.setHolidayClass(row);
      row.title = holiday.name.stripTags();
    } else if (this.calendar.isRegularHoliday(date.getDay())) {
      this.calendar.setRegularHolidayClass(row);
    } else {
      this.calendar.setWorkdayClass(row);
    }

    if (date.days() == today.days()) {
      this.calendar.addHighlightClass(row);
    }
    return row;
  },

  beforeBuild: function() {
    this.column = {};
    var rule = CssUtil.getCssRuleBySelectorText('.' + Calendar.className.table + ' td');
    this.column.height = parseInt(rule.style['height'], 10);
    
    rule = CssUtil.getCssRuleBySelectorText('.' + Calendar.className.dateContainer);
    this.column.dateTextHeight = parseInt(rule.style['height'], 10);
  },

  /**********************************
   ***** for make schedule item *****
   **********************************/
  buildSchedule: function(schedule) {
    var id      = 'scheduleItem_' + schedule.id;
    var canEdit = (schedule.edit == undefined || schedule.edit);
    var item    = Builder.node('DIV', {id: id});
    var start = DateUtil.toDate(schedule.start);
    var finish = DateUtil.toDate(schedule.finish);
    if (start.sameDate(finish)) {
      this.calendar.classNames.addClassNames(item, 'scheduleItemNoBorder');
    } else {
      this.calendar.classNames.addClassNames(item, 'scheduleItemLarge');
    }

    if (canEdit) {
      var deleteImg = Builder.node('DIV',
        {
          id:        'scheduleDeleteImg_' + schedule.id,
          className: this.calendar.classNames.joinClassNames('deleteImg')
        }
      );
      Element.hide(deleteImg);
      item.appendChild(deleteImg);

      // set click event on a image.
      Event.observe(deleteImg, 'click', this.clickDeleteImage.bind(this, schedule));
      Event.observe(item, 'mouseover', this.showDeleteImage.bind(this, deleteImg));
      Event.observe(item, 'mouseout', this.hideDeleteImage.bind(this, deleteImg));
    }

    // set dblclick event on a schedule item.
    if (this.calendar.options.dblclickSchedule) {
      Event.observe(
        item, 'dblclick', this.calendar.options.dblclickSchedule.bind(this, schedule));
    }

    // drag handler
    var handler = null;
    if (canEdit) {
      handler = Builder.node('DIV', {className: this.calendar.classNames.joinClassNames('scheduleHandler')});
      item.appendChild(handler);
    }

    var icon = null;
    if (schedule.icon) {
      icon = Builder.node('IMG', {src: schedule.icon, alt: 'icon', style: 'float: left;'});
      item.appendChild(icon);
    }

    // private mark
    if (!schedule.publicity) {
      icon = Builder.node('DIV', {id: 'private_img_' + schedule.id});
      this.calendar.classNames.addClassNames(icon, 'privateImg');
      item.appendChild(icon);
    }

    var body = Builder.node('DIV');
    var text = this.getTimeText(schedule.start, schedule.finish);
    text = Builder.node('DIV', {id: id + '_text', style: 'float: left;'}, [text]);
    this.calendar.classNames.addClassNames(text, 'scheduleTimeArea');
    item.appendChild(text);
    var description = schedule.description.unescapeHTML();
    item.appendChild(Builder.node('DIV', {id: id + '_description'}, [description]));

    item.title = description;
    item.schedule = schedule;

    return [item, handler];
  },

  adjustScheduleStyle: function(item, rowIndex, cellIndex, holder) {
    var self   = this;
    var height = parseInt(Element.getStyle(item, 'height'), 10);
    var top    = parseInt(Element.getStyle(item, 'top'), 10);
    var range  = this.getScheduleRange(item);
    var tops   = [];

    holder.each(function(holded) {
      var holdedRange = self.getScheduleRange(holded);
      if (range.any(function(r) {return holdedRange.include(r)})) {
        tops.push(holded.topIndex);
      }
    });

    var index = $R(0, tops.length, true).detect(function(i) {return !tops.include(i)});
    if (isNaN(index)) index = tops.length;
    item.topIndex = index;
    Element.setStyle(item, {top: top + (height + 2) * index + 'px'});
  },

  getScheduleRange: function(item) {
    return $R(0, item.length, true).map(function(i) {return item.cellIndex + i});
  },

  setScheduleBaseStyle: function(item, rowIndex, cellIndex, length) {
    var oneDay     = this.column.height;
    var top        = oneDay * rowIndex + this.column.dateTextHeight;
    var adjustSize = this.getAdjustSize();
    Element.setStyle(item, {
      top:   top + 'px',
      width: this.column.width * length + adjustSize * (length - 1) + 'px',
      left:  this.column.width * cellIndex + cellIndex * adjustSize + 'px'
    });
  },

  afterBuild: function() {
    this.scheduleNodes = [];
    if (this.calendar.options.size != Calendar.size.small) {
      this.setContainerInfo();
      this.setColumnWidth();
      this.setCover();
      this.setSelector();
      var self         = this;
      var indexes      = this.calendar.options.displayIndexes;
      var distance     = this.getDragDistance();
      var holders      = $R(0, $(this.getCalendarTableId()).rows.length).map(function() {return []});
      var date         = this.calendar.date;
      var calStartDate = DateUtil.getFirstDate(date.getFullYear(), date.getMonth());
      var calStart     = calStartDate.days();
      var calFinish    = DateUtil.getLastDate(date.getFullYear(), date.getMonth()).days();
  
      self.calendar.options.schedules.each(function(schedule, index) {
        var startDate  = self.toDate(schedule.start);
        var start      = startDate.days();
        var finishDate = self.toDate(schedule.finish);
        var finish     = finishDate.days();
        var days       = self.getDayDiff(schedule);
  
        if ((start >= calStart && start <= calFinish) || (finish >= calStart && finish <= calFinish)) {
          if (!calStartDate.sameMonth(startDate)) startDate = calStartDate;
          self.setSchedule(schedule, holders, distance, days);
        }
      });
    }
  },

  setSchedule: function(schedule, holders, distance, days) {
    var items      = [];
    var rowMax     = 6;
    var startDate  = DateUtil.toDate(schedule.start);
    var date       = startDate;
    var indexes    = this.calendar.options.displayIndexes;
    var targetDate = this.calendar.options.initDate;

    while (days >= 0) {
      if (date.getMonth() != startDate.getMonth()) break;
      var lastWday = this.getLastWday(date);

      var length = days + 1;
      var firstDay   = date.getDay();
      var finishDate = date.advance({days: length - 1});

      if (finishDate.getTime() > lastWday.getTime()) {
        finishDate = lastWday; 
        length = finishDate.days() - date.days() + 1;
      }
      var finishDay  = finishDate.getDay();
      var wdays      = null;
      if (firstDay <= finishDay) {
        wdays = $R(firstDay, finishDay, false);
      } else {
        wdays = $R(0, finishDay, false).toArray().concat($R(firstDay, rowMax, false).toArray());
      }
      var itemLength = wdays.findAll(function(day) {
        return indexes.include(day);
      }).length;

      var cellDate = new Date(date.getTime());
      while (cellDate.days() <= finishDate.days()) {
        if (cellDate.getMonth() == targetDate.getMonth()) {
          var cellPosition = this.getCellPosition(cellDate.getDate());
          if (cellPosition) {
            var rowIndex = cellPosition.rowIndex;
            var cellIndex = cellPosition.cellIndex;
    
            // create a schedule node.
            var result = this.buildSchedule(schedule);
            var item = result.first();
            item.length = itemLength;
            item.cellIndex = cellIndex;
            this.container.appendChild(item);
      
            // set style(position and size) of a schedule item.
            this.setScheduleBaseStyle(item, rowIndex, cellIndex, itemLength);
            var left = this.adjustScheduleStyle(item, rowIndex, cellIndex, holders[rowIndex]);
      
            if (schedule.edit == undefined || schedule.edit) {
              this.setDraggable(item, result.last(), distance);
              this.setResize(item);
            }
      
            holders[rowIndex].push(item);
            this.scheduleNodes.push(item);
            break;
          } else if (indexes.include(cellDate.getDay())) {
            itemLength--;
          }
        } else if (indexes.include(cellDate.getDay())) {
          itemLength--;
        }
        cellDate = cellDate.advance({days: 1});
      }
  
      if (items.length == 0) {
        days -= length;
      } else {
        days =- 7;
      }

      var date = finishDate.advance({days: 1});
      if (item) items.push(item);
    }

    var self = this;
    items.each(function(item) {
      Event.observe(item, 'mouseover', self.mouseOverSubSchedule.bind(this, items));
      Event.observe(item, 'mouseout', self.mouseOutSubSchedule.bind(this, items));
    });
  },

  getLastWday: function(date) {
    var index = this.calendar.wdays.indexOf(date.getDay()) + 1;
    return date.advance({days: this.calendar.wdays.length - index});
  },

  setSelector: function() {
    var selector = $(this.getSelectorId());
    Element.setStyle(selector, {
      width:  this.column.width + 'px',
      height: this.column.height - 2 + 'px'
    });
  },

  // set draggalbe event
  setDraggable: function(item, handle, distance) {
    var self       = this;
    var offset     = Position.cumulativeOffset(this.container);
    var selector   = $(this.getSelectorId());
    var cWidth     = this.column.width;
    var cHeight    = this.column.height;
    var rowMax     = this.rowMax;
    var cellMax    = this.calendar.options.displayIndexes.length - 1;
    var adjustSize = this.getAdjustSize();

    new Draggable(item, 
      {
        handle:      handle,
        scroll:      window,
        starteffect: Prototype.emptyFunction,
        endeffect:   Prototype.emptyFunction,
        onStart: function(draggalbe) {
          Element.show(selector);
        },
        onDrag: function(draggable, event) {
          var element   = draggable.element;
          var top       = parseInt(Element.getStyle(element, 'top'), 10);
          var rowIndex  = Math.floor(top / cHeight);
          var left      = parseInt(Element.getStyle(element, 'left'), 10);
          var cellIndex = Math.floor(left / cWidth);

          if ((cellIndex >= 0 && rowIndex >= 0) &&
            (cellIndex <= cellMax && rowIndex <= rowMax)) {
            Element.setStyle(selector, {
              left: cWidth * cellIndex + adjustSize * cellIndex + 'px',
              top:  cHeight * rowIndex + 'px'
            });
          }
        },
        onEnd: function(draggable) {
          Element.hide(selector);
          self.changeSchedule(draggable);
        }
      }
    );
  },

  // set resize event
  setResize: function(item) {
    var self = this;
    new CalendarResizeableEx(item, {
      left:        0,
      top:         0,
      bottom:      0,
      distance:    this.column.width,
      restriction: true,
      resize: function(element) {
        self.updateTirm(element);
      }
    });
  },

  /********************************** public method **********************************/
  getDate: function(element) {
    if (!element) return;
    var date = this.calendar.date;
    if (element.constructor == String)
      return new Date(date.getFullYear(), date.getMonth(), element);
    else
      return new Date(date.getFullYear(), date.getMonth(), element.id.getSuffix());
  },

  abstractSelect: function(event, method) {
    var element = null;
    if (this.calendar.options.size == 'large') {
      element = this.findClickedElement(event);
    } else {
      element = Event.element(event);
      if (element.tagName != 'TD') {
        element = Element.getParentByTagName(['TD'], element);
      }
    }
    if (element && element.id) {
      var date = this.getDate(element);
      method(date, element);
    }
  },

  getSelectedTerm: function() {
    var self = this;
    var elements = this.calendar.getSelected();
    if (elements && elements.length > 0) {
      return [elements.first(), elements.last()].map(function(e) {
        return self.getDate(e);
      });
    }
    return null;
  },

  /********************************** private method **********************************/
  selectDay: function(event) {
    var calendar = this.calendar;
    var th = Event.element(event);
    if (th.tagName != 'TH')
      th = Element.getParentByTagName('TH', th);

    this.iterateTable({doCell: function(cell) {
      if ((cell.cellIndex == th.cellIndex) && cell.id)
        calendar.addSelectedClass(cell);
    }});
  },

  inspectArgument: function(object, time) {
    var self = this;
    var dates = this.calendar.getSelected();
    var result = [];

    self.calendar.recurrence(object, function(o) {
      if (!o.date) {
        dates.each(function(d) {
          var param = {};
          if (!o.date) {
            param = {date: self.getDate(d)};
            if (time) {
              param.start = {hour: 0, min: 0};
              param.finish = {hour: 0, min: 0};
            }
          }
          Object.extend(param, o);
          result.push(param);
        });
      } else if (o.date.constructor == Object) {
        o.date = new Date(o.date.year, o.date.month, o.date.day);
        result.push(o);
      } else {
        result.push(o);
      }
    });
    return result;
  },

  inspectDateArgument: function(date) {
    if (date) {
      map = [];
      this.calendar.recurrence(date, function(d) {
        if (d.constructor == Object) 
           map.push(new Date(d.year, d.month, d.day));
        else 
          map.push(d);
      });
      return map;
    } else {
      var calendar = this;
      var dates = this.calendar.getSelected();
      if (dates.length == 0) return null;

      return dates.collect(function(d) {
        return calendar.getDate(d);
      });
    }
  },

  findClickedElement: function(event) {
    var container = $(this.getScheduleContainerId());
    var position = Position.cumulativeOffset(container);
    var scrollTop = Position.realOffset(container).last();
    scrollTop -= document.documentElement.scrollTop || document.body.scrollTop;
    var x = Event.pointerX(event) - position[0];
    var y = Event.pointerY(event) - position[1] + scrollTop;
    var rowIndex = Math.floor(y / this.column.height);
    var cellIndex = Math.floor(x / this.column.width);
    return $(this.calendarTable.rows[rowIndex].cells[cellIndex]);
  },

  multipleSelection: function(event) {
    if (!this.calendar.selectedBase || !this.calendar.mouseDown) return;
    var self = this;
    var calendar = this.calendar;
    var selected = this.calendar.selectedBase;

    this.abstractSelect(event, function(date, element) {
      var selectedElement = $(selected.id);

      var range = calendar.createRange(
        parseInt(selectedElement.id.getSuffix()),
        parseInt(element.id.getSuffix())
      );

      self.iterateTable({doCell: function(cell) {
        if (cell.tagName != 'TD' || !cell.id) throw $continue;
        var id = parseInt(cell.id.getSuffix());
        
        if (range.include(id)) {
          calendar.addSelectedClass(cell);
        } else {
          calendar.removeSelectedClass(cell);
        }
      }});
    });
  },

  iterateTable: function() {
    var options = Object.extend({
      doTable: null,
      doRow: null,
      doCell: null
    }, arguments[0]);
    
    var calendar = $(this.getCalendarTableId());
    if (options.doTable) {
      options.doTable(calendar)
    };

    $A(calendar.rows).each(function(row) {
      if (options.doRow) {
        options.doRow(row);
      }
      $A(row.cells).each(function(cell) {
        if (options.doCell) {
          options.doCell(cell);
        }
      });
    });
  },

  findRow: function(rowIndex) {
    var table = $(this.getCalendarTableId());
    return $A(table.rows).detect(function(row) {
      return row.rowIndex == rowIndex;
    });
  },

  findCell: function(rowIndex, cellIndex) {
    return $A(this.findRow(rowIndex).cells).detect(function(cell) {
      return cell.cellIndex == cellIndex;
    });
  },

  getCalendarTableId: function() {
    return this.calendar.element.id.appendSuffix(CalendarMonth.id.calTable);
  },

  getDateId: function(date) {
    var day = null;
    if (date.constructor == Date) {
      day = date.getDate();
    } else {
      day = date;
    }
    return this.calendar.element.id.appendSuffix(day);
  },

  getCell: function(day) {
    return $(this.getDateId(day));
  },

  getCellPosition: function(day) {
    var cell = this.getCell(day);
    if (cell) {
      var row  = Element.getParentByTagName(['tr'], cell);
      return {cellIndex: cell.cellIndex, rowIndex: row.rowIndex};
    }
  },

  changeSchedule: function(draggable) {
    var element = draggable.element;
    var schedule = element.schedule;

    var top       = parseInt(Element.getStyle(element, 'top'), 10);
    var rowIndex  = Math.floor(top / this.column.height);
    var left      = parseInt(Element.getStyle(element, 'left'), 10);
    var cellIndex = Math.floor(left / this.column.width);
    var table     = $(this.getCalendarTableId());
    var rowMax    = table.rows.length - 1;
    var cellMax   = this.calendar.options.displayIndexes.length - 1;

    if ((cellIndex >= 0 && rowIndex >= 0) &&
        (cellIndex <= cellMax && rowIndex <= rowMax)) {
      var cell = this.findCell(rowIndex, cellIndex);
      var date = cell.date;
      var diff = this.getDayDiff(schedule);

      var finish = date.advance({days: diff});
      if (
        schedule.start.month  == date.getMonth() &&
        schedule.start.day    == date.getDate() &&
        schedule.finish.month == finish.getMonth() &&
        schedule.finish.day   == finish.getDate()
      ) {this.calendar.refreshSchedule(); return;}

      schedule.start.month  = date.getMonth();
      schedule.start.day    = date.getDate();
      schedule.finish.month = finish.getMonth();
      schedule.finish.day   = finish.getDate();

      this.calendar.refreshSchedule();
      this.calendar.options.changeSchedule(schedule);
    } else {
      this.calendar.refreshSchedule();
    }
  },

  updateTirm: function(element) {
    var schedule    = element.schedule;
    var width       = parseInt(Element.getStyle(element, 'width'));
    var top         = parseInt(Element.getStyle(element, 'top'));
    var left        = parseInt(Element.getStyle(element, 'left'));
    var cellIndex   = Math.round((left + width) / this.column.width) - 1;
    var rowIndex    = Math.round(top / this.column.height);
    var cell        = this.findCell(rowIndex, cellIndex);

    var oldFinish  = schedule.finish;
    var newFinish  = cell.date.toHash();
    newFinish.hour = oldFinish.hour;
    newFinish.min  = oldFinish.min;

    if (DateUtil.toDate(schedule.start).getTime() >= DateUtil.toDate(newFinish).getTime()) {
      var maxHour = 23;
      var maxMin = 55;
      if (schedule.start.hour == maxHour && schedule.start.min == maxMin) {
        this.calendar.refreshSchedule();
        this.calendar.options.updateTirm();
        return;
      } else {
        newFinish.hour = maxHour;
        newFinish.min  = maxMin;
      }
    }
    schedule.finish = newFinish;

    this.calendar.refreshSchedule();
    this.calendar.options.updateTirm(schedule);
  },

  getTimeText: function(start, finish) {
    var calendar = this.calendar;
    return calendar.formatTime(start);
  },

  getDayDiff: function(schedule) {
    return DateUtil.numberOfDays(this.toDate(schedule.start), this.toDate(schedule.finish));
  }
});


/**
 * CalendarWeek Class
 */
var CalendarWeek= Class.create();
CalendarWeek.id = {
  columnContainer: 'columnContainer',
  columnHeader:    'columnHeader',
  column:          'column',
  next:            'next',
  pre:             'pre'
}
Object.extend(CalendarWeek.prototype, AbstractCalendar.prototype);
Object.extend(CalendarWeek.prototype, {

  initialize: function(calendar) {
    this.calendar = calendar;
    this.week     = this.getWeek();
    this.setDisplayTime();
  },

  /*** Week ***/
  /********************************** build functions **********************************/
  buildHeaderLeft: function() {
    var container = Builder.node('TD');
    this.calendar.classNames.addClassNames(container, 'preYears');

    var id = this.calendar.element.id.appendSuffix(CalendarWeek.id.pre);
    var node = Builder.node('DIV', {id: id});
    this.calendar.classNames.addClassNames(node, 'preWeekMark');
    Event.observe(node, "click", this.calendar.changeCalendar.bindAsEventListener(this.calendar));
    container.appendChild(node);

    return container;
  },

  buildHeaderCenter: function() {
    var contents = [];
    var texts    = [];
    if (this.calendar.options.weekHeaderFormat) {
      texts = [this.formatHeaderDate(this.week.first()), '-', this.formatHeaderDate(this.week.last())];
    }(this.week[0], this.week.last()) || [];

    var node = Builder.node('SPAN', [texts[0] || this.week[0].toDateString()]);
    this.calendar.classNames.addClassNames(node, 'ym');
    contents.push(node);

    node = Builder.node('SPAN', [texts[1] || '-']);
    this.calendar.classNames.addClassNames(node, 'ym');
    contents.push(node);

    node = Builder.node('SPAN', [texts.last() || this.week.last().toDateString()]);
    this.calendar.classNames.addClassNames(node, 'ym');
    contents.push(node);

    var container = Builder.node('TD', contents);
    this.calendar.classNames.addClassNames(container, 'years');

    return container;
  },

  formatHeaderDate: function(date) {
    if (this.calendar.options.weekHeaderFormat) {
      return new Template(this.calendar.options.weekHeaderFormat).
        evaluate({year: date.getFullYear(), month: date.getMonth() + 1, day: date.getDate()});
    }
    return '';
  },

  buildHeaderRight: function() {
    var container = Builder.node('TD', {align: 'right'});
    this.calendar.classNames.addClassNames(container, 'nextYears');

    var id = this.calendar.element.id.appendSuffix(CalendarWeek.id.next);
    var node = Builder.node('DIV', {id: id});
    this.calendar.classNames.addClassNames(node, 'nextWeekMark');
    Event.observe(node, "click", this.calendar.changeCalendar.bindAsEventListener(this.calendar));
    container.appendChild(node);

    return container;
  },

  buildCalendar: function() {
    var table = Builder.node('TABLE', {id: CalendarWeek.id.columnContainer});
    var tbody = Builder.node('TBODY');

    this.calendar.classNames.addClassNames(table, 'weekTable');
    table.appendChild(tbody);
    var tr = Builder.node('TR');
    tbody.appendChild(tr);

    if (this.calendar.options.displayTimeLine) {
      tr.appendChild(this.buildTimeLine());
    }
    tr.appendChild(this.buildCalendarContainer());

    return table;
  },

  buildTimeLine: function() {
    var time = new Date();
    var hour = 0, hoursOfDay = 24;
    time.setHours(hour);
    time.setMinutes(0);
    var nodes = [];

    var node = Builder.node('DIV');
    this.calendar.classNames.addClassNames(node, 'timeLineTimeTop');
    nodes.push(node);
    while (hour < hoursOfDay) {
      if (this.includeDisplayTime(hour)) {
        node = Builder.node('DIV', [this.formatTime(time)]);
        this.calendar.classNames.addClassNames(node, 'timeLineTime');
        nodes.push(node);
      }
      hour++;
      time.setHours(hour);
    }

    var td = Builder.node('TD', nodes);
    this.calendar.classNames.addClassNames(td, 'timeLine');
    return td;
  },
  
  buildCalendarContainer: function() {
    var table = Builder.node('TABLE');
    var tbody = Builder.node('TBODY');
    table.appendChild(tbody);
    this.calendar.classNames.addClassNames(table, 'weekMainTable');

    tbody.appendChild(this.buildCalendarHeader());
    tbody.appendChild(this.buildCalendarMain());
    
    return Builder.node('TD', [table]);
  },

  buildCalendarHeader: function() {
    var indexes        = this.calendar.options.displayIndexes;
    var ths            = [];
    var self           = this;
    var today          = new Date().days();
    var width          = 100 / indexes.length + '%';
    var clickDateText  = this.calendar.options.clickDateText;
    var subHeaderTempl = (this.calendar.options.weekSubHeaderFormat) ? new Template(this.calendar.options.weekSubHeaderFormat) : null;

    this.week.each(function(w, index) {
      var text = null;
      if (subHeaderTempl) {
        text = subHeaderTempl.evaluate({month: w.getMonth() + 1, day: w.getDate(), wday: self.calendar.options.dayOfWeek[w.getDay()]});
      } else {
        text = w.toDateString().split(' ');
        text.pop();
        text = text.join(' ');
      }
      var link = Builder.node('A', {href: '#'}, [text]);
      if (w.days() == today) self.calendar.addHighlightClass(link);
      var node = Builder.node('DIV', [link]);
      self.calendar.classNames.addClassNames(node, 'headerColumn');

      if (clickDateText) {
        Event.observe(node, 'mousedown', clickDateText.bindAsEventListener(self, w));
      } else {
        Event.observe(node, 'mousedown', self.clickDateText.bindAsEventListener(self, w));
      }

      var id = self.calendar.element.id.appendSuffix(CalendarWeek.id.column);
      var th = Builder.node('TH', {id: id.appendSuffix(index)}, [node]);
      th.width = width;
      ths.push(th);
    });

    var table = Builder.node('TABLE');
    var tbody = Builder.node('TBODY');
    table.appendChild(tbody);
    tbody.appendChild(Builder.node('TR', ths));
    this.calendar.classNames.addClassNames(table, 'weekMainTable');
    return Builder.node('TR', [Builder.node('TD', [table])]);
  },

  buildCalendarMain: function() {
    var indexes = this.calendar.options.displayIndexes;
    var self = this;
    var tds = [];
    var width = 100.0 / indexes.length + '%';

    this.week.each(function(w, index) {
      var schedules = self.calendar.options.schedules[w.toDateString()];
      var nodes = [];
      var i = 0, j = 0;

      while (i < 24) {
        if (self.includeDisplayTime(i)) {
          var node = Builder.node('DIV', {id: self.getDateId(w, i)});
          var hour = i / 1;
          var min = i % 1 * 60;
          node.date = new Date(w.getFullYear(), w.getMonth(), w.getDate(), hour, min, 0);

          if (nodes.length == 0) {
            self.calendar.classNames.addClassNames(node, 'columnTopDate');
          } else if (i % 1 == 0) {
            self.calendar.classNames.addClassNames(node, 'columnDate');
          } else {
            self.calendar.classNames.addClassNames(node, 'columnDateOdd');
          }
          self.setColumnEvent(node);
          nodes.push(node);
        }
        i += 0.5;
      }

      var td = Builder.node('TD', nodes);
      td.width = width;
      tds.push(td);
    });

    this.calendarTable = Builder.node('TABLE', {style: 'position: relative'});
    var tbody = Builder.node('TBODY');
    this.calendarTable.appendChild(tbody);
    tbody.appendChild(Builder.node('TR', tds));
    this.calendar.classNames.addClassNames(this.calendarTable, 'weekMainTable');
    var container = this.buildScheduleContainer();
    container.appendChild(this.calendarTable);
    this.setScheduleContainerEvent(container);
    this.calendar.classNames.addClassNames(container, 'scheduleContainer');
    return Builder.node('TR', [Builder.node('TD', [container])]);
  },

  setColumnEvent: function(node) {
    // do nothing
  },

  beforeBuild: function() {
    this.column = {};
    var rule = CssUtil.getCssRuleBySelectorText('.' + Calendar.className.columnDate);
    this.column.height = parseInt(rule.style['height'], 10) + 1;
  },

  /**********************************
   ***** for make schedule item *****
   **********************************/
  buildSchedule: function(schedule) {
    var id      = 'scheduleItem_' + schedule.id;
    var canEdit = (schedule.edit == undefined || schedule.edit);
    var item    = Builder.node('DIV', {id: id});
    this.calendar.classNames.addClassNames(item, 'scheduleItemLarge');

    if (canEdit) {
      var deleteImg = Builder.node('DIV',
                        {
                          id: 'scheduleDeleteImg_' + schedule.id,
                          className: this.calendar.classNames.joinClassNames('deleteImg')
                        });
      Element.hide(deleteImg);
      item.appendChild(deleteImg);
  
      // set event on a image.
      Event.observe(deleteImg, 'click', this.clickDeleteImage.bind(this, schedule));
      Event.observe(item, 'mouseover', this.showDeleteImage.bind(this, deleteImg));
      Event.observe(item, 'mouseout', this.hideDeleteImage.bind(this, deleteImg));
    }

    // set dblclick event on a schedule item.
    if (this.calendar.options.dblclickSchedule) {
      Event.observe(
        item, 'dblclick', this.calendar.options.dblclickSchedule.bind(this, schedule));
    }

    // drag handler
    var handler = null;
    if (canEdit) {
      handler = Builder.node('DIV', {className: this.calendar.classNames.joinClassNames('scheduleHandler')});
      item.appendChild(handler);
    }

    var icon = null;
    if (schedule.icon) {
      icon = Builder.node('IMG', {src: schedule.icon, alt: 'icon', style: 'float: left;'});
      item.appendChild(icon);
    }

    // private mark
    if (!schedule.publicity) {
      icon = Builder.node('DIV', {id: 'private_img_' + schedule.id});
      this.calendar.classNames.addClassNames(icon, 'privateImg');
      item.appendChild(icon);
    }

    var text = this.getTimeText(schedule.start, schedule.finish);
    text = Builder.node('DIV', {id: id + '_text'}, [text]);
    this.calendar.classNames.addClassNames(text, 'scheduleTimeArea');

    item.appendChild(text);
    var description = schedule.description.unescapeHTML();
    item.appendChild(Builder.node('DIV', {id: id + '_description'}, [description]));
    item.title = description;
    item.schedule = schedule;

    return [item, handler];
  },

  adjustScheduleStyle: function(item, index, holder) {
    var schedule = item.schedule;
    var time     = this.convertHours(schedule);
    var start    = time[0];
    var finish   = time[1];
    var same     = [];
    var self     = this;

    holder.each(function(h) {
      var hTime = self.convertHours(h.schedule);
      var hStart = hTime[0];
      var hFinish = hTime[1];

      if (
           ((hStart <= start) && (hFinish > start)) || ((hStart < finish) && (hFinish >= finish)) ||
           ((start <= hStart) && (finish > hStart)) || ((start < hFinish) && (finish >= hFinish))
         ) {
        same.push(h);
      }
    });

    var adjustSize = index * this.getAdjustSize();
    var left = this.column.width * index + adjustSize;
    if (same.length == 0) {
      Element.setStyle(item, {left: left + 'px'});
    } else {
      same.push(item);
      var width = parseInt(Element.getStyle(item, 'width'), 10) / (same.length) - 2;
      same.each(function(s, i) {
        var adjustLeft = left + width * i + (2 * i);
//        if (i != 0) adjustLeft += 2;
        Element.setStyle(s, {
          width: width + 'px',
          left:  adjustLeft + 'px'
        });
      });
    }
    return left;
  },

  setScheduleBaseStyle: function(item) {
    var schedule   = item.schedule;
    if (!this.calendar.isSameDate(schedule.start, schedule.finish)) {
      schedule.finish.hour = 24;
      schedule.finish.min  = 0;
    }

    var time       = this.convertHours(schedule);
    var startTime  = time.first();
    var finishTime = time.last();
    var oneHour    = this.column.height * 2;
    var diff       = this.calendar.getTimeDiff(schedule.start, schedule.finish);
    var rate       = (diff.hour + (diff.min / 60)) || 1;

    var over   = 0;
    var top    = 0;
    var height = 0;

    var includeStart  = this.includeDisplayTime(startTime);
    var includeFinish = this.includeDisplayTime(finishTime);
    if (!includeStart && !includeFinish) {
      if ((this.startTime <= startTime && this.startTime <= finishTime) ||
          (startTime < this.finishTime && finishTime < this.finishTime)) {
        top = height = 0;
        Element.hide(item);
      } else {
        top = 0;
        height = oneHour * (this.finishTime - this.startTime) - 3;
      }
    } else {
      if (includeStart) {
        top    = oneHour * (startTime - this.startTime);
        height = oneHour * rate - 3;
      } else {
        top    = 0;
        over   = this.startTime - startTime;
        height = oneHour * (rate - over);
      }

      if (includeFinish) {
      } else {
        over = finishTime - this.finishTime;
        height -= oneHour * over;
      }
    }

    try {
      Element.setStyle(item, {
        top:    top + 'px',
        width:  this.column.width + 'px',
        height: height + 'px'
      });
    } catch (e) {}
  },

  afterBuild: function() {
    this.setContainerInfo();
    this.setColumnWidth();
    this.setCover();
    var self           = this;
    var container      = $(this.getScheduleContainerId());
    var distance       = this.getDragDistance();
    this.scheduleNodes = [];
    var holders        = this.week.map(function() {return []});
    var weekSize       = this.week.legth - 1;

    this.calendar.options.schedules.each(function(schedule) {
      var items = [];
      var sub, subItem = null;
      self.week.each(function(date, index) {
        if (self.calendar.betweenDate(schedule, date)) {
          if (self.isSameStartDate(schedule, date) && self.isSameFinishDate(schedule, date)) {
            items.push(self.setSchedule(schedule, index, holders, container, distance));
          } else {
            sub = self.copyOneDaySchedule(schedule, date);
            subItem = self.setSchedule(sub, index, holders, container, distance);
            subItem.originalSchedule = schedule;
            items.push(subItem);
          }
        } else if (sub) {
          throw $break;
        }
      });

      items.each(function(item) {
        Event.observe(item, 'mouseover', self.mouseOverSubSchedule.bind(this, items));
        Event.observe(item, 'mouseout', self.mouseOutSubSchedule.bind(this, items));
      });
    });
  },

  copyOneDaySchedule: function(schedule, date) {
    var sub = null;
    if (this.isSameStartDate(schedule, date)) {
      sub = this.copySchedule(schedule, date);
      sub.finish.hour = 24;
      sub.finish.min  = 0;
    } else if (this.isSameFinishDate(schedule, date)) {
      sub = this.copySchedule(schedule, date);
      sub.start.hour  = 0;
      sub.start.min   = 0;
    } else {
      sub = this.copySchedule(schedule, date);
      sub.start.hour  = 0;
      sub.start.min   = 0;
      sub.finish.hour = 24;
      sub.finish.min  = 0;
    }
    return sub;
  },

  copySchedule: function(schedule, date) {
    sub = Object.extend({}, schedule);
    sub.start = {
      year:  date.getFullYear(),
      month: date.getMonth(),
      day:   date.getDate(),
      hour:  schedule.start.hour,
      min:   schedule.start.min
    }
    sub.finish = {
      year:  date.getFullYear(),
      month: date.getMonth(),
      day:   date.getDate(),
      hour:  schedule.finish.hour,
      min:   schedule.finish.min
    }
    return sub;
  },

  setSchedule: function(schedule, index, holders, container, distance) {
    // create a schedule node.
    var result = this.buildSchedule(schedule);
    var item = result.first();
    container.appendChild(item);

    // set style(position and size) of a schedule item.
    this.setScheduleBaseStyle(item);
    var left       = this.adjustScheduleStyle(item, index, holders[index]);
    var adjustSize = index * this.getAdjustSize();
    var snapLeft   = this.column.width + adjustSize + 'px';

    if (schedule.edit == undefined || schedule.edit) {
      this.setDraggable(item, result.last(), container, distance);
      this.setResize(item);
    }

    holders[index].push(item);
    this.scheduleNodes.push(item);
    return item;
  },

  getDragDistance: function() {
    var adjustSize = this.getAdjustSize();
    return [this.column.width + adjustSize, this.column.height / 2];
  },

  // set draggalbe event
  setDraggable: function(item, handle, container, distance) {
    var self = this;
    new Draggable(item, 
      {
        handle:      handle,
        scroll:      window,
        starteffect: Prototype.emptyFunction,
        endeffect:   Prototype.emptyFunction,
        snap: function(x, y) {
          var eDimensions = Element.getDimensions(item);
          var pDimensions = Element.getDimensions(container);
          var xy = [x, y].map(function(v, i) { return Math.floor(v/distance[i]) * distance[i] });
          xy = [
            self._constrain(xy[0], 0, pDimensions.width - eDimensions.width),
            self._constrain(xy[1], 0, pDimensions.height - eDimensions.height)
          ];
          return xy;
        },
        onEnd: function(draggable, event) {
          self.changeSchedule(draggable, event);
        },
        change: function(draggable) {
          self.changeTimeDisplay(draggable.element);
        }
      }
    );
  },

  // set resize event
  setResize: function(item) {
    new CalendarResizeableEx(item, {
      left:        0,
      right:       0,
      distance:    this.column.height / 2,
      restriction: true,
      resize: function(element) {
        this.updateTirm(element);
      }.bind(this),
      change: function(element) {
        this.changeTimeDisplay(element);
      }.bind(this)
    });
  },

  /********************************** public method **********************************/
  getDate: function(element) {
    return element.date;
  },

  abstractSelect: function(event, method) {
    var element = this.findClickedElement(event);
    if (element) {
      if (Element.hasClassName(element, Calendar.className.columnDate) ||
          Element.hasClassName(element, Calendar.className.columnDateOdd) ||
          Element.hasClassName(element, Calendar.className.columnTopDate)) {

        var date = this.getDate(element);
        method(date, element);
      }
    }
  }, 

  getSelectedTerm: function() {
    var self = this;
    var elements = this.calendar.getSelected();
    if (elements && elements.length > 0) {
      var last = elements.last();
      if (last) {
        last = last.date;
      } else {
        last = elements.first().date;
      }
      last = new Date(last.getFullYear(), last.getMonth(),
              last.getDate(), last.getHours(), last.getMinutes(), 0);
      last.setMinutes(last.getMinutes() + 30);
      
      return [elements.first().date, last];
    }
  },

  /*** Week ***/
  /********************************** private method **********************************/
  setWidth: function(node) {
    Element.setStyle(node, {width: this.column.width + 'px'});
  },

  inspectArgument: function(object, time) {
    if (object.date) return object;

    var self = this;
    var dates = this.calendar.getSelected();
    var result = [];
    this.calendar.recurrence(object, function(o) {
      var param = {};
      if (!o.date) {
        param = {date: self.getDate(dates[0])};
        if (!o.start)
          param.start = dates[0].time;
        if (!o.finish)
          param.finish = dates[dates.length - 1].time;
      }
      Object.extend(param, o);
      result.push(param);
    });

    return result;
  },

  inspectDateArgument: function(date) {
    if (date) return date;

    var calendar = this;
    var dates = this.getSelected();
    if (dates.length == 0) return null;

    return dates.collect(function(d) {
      return calendar.getDate(d);
    });
  },

  addColumnClass: function(element) {
    if (document.all)
      this.calendar.classNames.addClassNames(element, 'columnWin');
    else
      this.calendar.classNames.addClassNames(element, 'column');
  },

  getHeaderId: function() {
    return this.calendar.element.id.appendSuffix(CalendarWeek.id.columnHeader);
  },

  getColumnId: function(i) {
    return this.calendar.element.id.appendSuffix(CalendarWeek.id.column + '_' + i);
  },

  changeSchedule: function(draggable, event) {
    var element = draggable.element;
    var schedule = element.schedule;
    var time = this.getTimeByElement(element);
    this.calendar.cacheSchedule(schedule);

    var container = $(this.getScheduleContainerId());
    var dimensions = Element.getDimensions(container);
    var offset = Position.cumulativeOffset(container);
    var scroll = Position.realOffset(container);
    var scrollLeft = scroll[0] - (document.documentElement.scrollLeft || document.body.scrollLeft || 0);
    var scrollTop = scroll[1] - (document.documentElement.scrollTop || document.body.scrollTop || 0);

    var x = Event.pointerX(event) + scrollLeft;
    var y = Event.pointerY(event) + scrollTop;

    if (
      offset[0] > x ||
      (offset[0] + dimensions.width) < x ||
      offset[1] > y ||
      (offset[1] + dimensions.height) < y
    ) {this.calendar.refreshSchedule(); return};

    var left = parseInt(Element.getStyle(element, 'left'));
    var weekIndex = Math.round(left / this.column.width);
    var date = this.week[weekIndex];

    if (
        schedule.start.year   == date.getFullYear() &&
        schedule.start.month  == date.getMonth() &&
        schedule.start.day    == date.getDate() &&
        schedule.start.hour   == time[0].hour &&
        schedule.start.min    == time[0].min &&
        schedule.finish.year  == date.getFullYear() &&
        schedule.finish.month == date.getMonth() &&
        schedule.finish.day   == date.getDate() &&
        schedule.finish.hour  == time[1].hour &&
        schedule.finish.min   == time[1].min
       ) {this.calendar.refreshSchedule(); return};

    if (element.originalSchedule) schedule = element.originalSchedule; 
    var newStart = {
      year:  date.getFullYear(),
      month: date.getMonth(),
      day:   date.getDate(),
      hour:  time[0].hour,
      min:   time[0].min
    }
    var diff = DateUtil.toDate(newStart).getTime() - DateUtil.toDate(schedule.start).getTime();
    schedule.start = newStart;
    schedule.finish = new Date(DateUtil.toDate(schedule.finish).getTime() + diff).toHash();

    this.calendar.refreshSchedule();
    this.calendar.options.changeSchedule(schedule);
  },

  updateTirm: function(element) {
    var schedule = element.schedule;
    var time = this.getTimeByElement(element);
    this.calendar.cacheSchedule(schedule);

    var left = parseInt(Element.getStyle(element, 'left'));
    var weekIndex = Math.round(left / this.column.width);
    var date = this.week[weekIndex];

    var isChange = this.isChengeSchedule(element, time);
    if (element.originalSchedule) schedule = element.originalSchedule;

    if (isChange.start) {
      schedule.start.year  = date.getFullYear();
      schedule.start.month = date.getMonth();
      schedule.start.day   = date.getDate();
      schedule.start.hour  = time[0].hour;
      schedule.start.min   = time[0].min;
    } else if (isChange.finish) {
      schedule.finish.year  = date.getFullYear();
      schedule.finish.month = date.getMonth();
      schedule.finish.day   = date.getDate();
      schedule.finish.hour  = time[1].hour;
      schedule.finish.min   = time[1].min;
    } else {
      return;
    }

    this.calendar.refreshSchedule();
    this.calendar.options.updateTirm(schedule);
  },

  changeTimeDisplay: function(element) {
    var schedule = element.schedule;
    var time = this.getTimeByElement(element);

    var textNode = Element.getElementsByClassName(element, Calendar.className.scheduleTimeArea)[0];
    var text = this.getTimeText(time[0], time[1]);
    textNode.innerHTML = text;
  },
  
  findClickedElement: function(event) {
    var container = $(this.getScheduleContainerId());
    var position = Position.cumulativeOffset(container);
    var scrollTop = Position.realOffset(container).last();
    scrollTop -= document.documentElement.scrollTop || document.body.scrollTop;
    var x = Event.pointerX(event) - position[0];
    var y = Event.pointerY(event) - position[1] + scrollTop;

    var cellIndex = Math.floor(y / this.column.height);
    var rowIndex = Math.floor(x / this.column.width);
    return $(this.calendarTable.rows[0].cells[rowIndex]).down(cellIndex);
  },

  multipleSelection: function(event) {
    if (!this.calendar.selectedBase || !this.calendar.mouseDown) return;
    var self = this;
    var calendar = this.calendar;
    var selected = this.calendar.selectedBase;

    this.abstractSelect(event, function(date, element) {
      var selectedElement = $(selected.id);
      if (selectedElement.date.getDate() != element.date.getDate()) return;

      var nodes = $A(selectedElement.parentNode.childNodes);
      var ids = [parseInt(selected.id.getSuffix()), parseInt(element.id.getSuffix())];
      ids.sort(function(a, b) {return a - b;});

      nodes.each(function(n) {
        if (!n.id) throw $continue;
        var id = parseInt(n.id.getSuffix());
        if ((id < ids[0]) || (ids[1] < id)) {
          calendar.removeSelectedClass(n);
        } else if (!Element.hasClassName(n, Calendar.className.selected)) {
          calendar.addSelectedClass(n);
        }
      });
    });
  },

  getTimeByElement: function(element) {
    var schedule = element.schedule;
    var top      = parseInt(Element.getStyle(element, 'top'), 10);
    var height   = parseInt(Element.getStyle(element, 'height'), 10);
    var oneHour  = this.column.height * 2;
    var distance = 0.25;

    var startTime  = top / oneHour + this.startTime;
    startTime = Math.round(startTime / distance) * distance;

    var finishTime = height / oneHour + startTime;
    finishTime = Math.round(finishTime / distance) * distance;

    var start = {};
    start.hour = Math.floor(startTime);
    start.min  = (startTime - start.hour) * 60;

    var finish = {};
    finish.hour = Math.floor(finishTime);
    finish.min  = (finishTime - finish.hour) * 60;

    if (finish.min == 60) {
      finish.hour += 1;
      finish.min = 0;
    }

    return [start, finish];
  },

  getDateId: function(date, i) {
    var id = this.calendar.element.id.appendSuffix(date.getDate());
    return id.appendSuffix(i * 10);
  },

  dateIdToTime: function(id) {
    id = id.getSuffix() / 10;
    var hour = Math.floor(id);
    return {hour: hour, min: (id - hour) * 60};
  },

  formatTime: function(date) {
    var time = date.toTimeString();
    time = time.split(' ');
    time = time[0].split(':');
    time.pop();
    return time.join(':');
  },

  /**
   * hours are 0, 0.5, 1, ..., 23.5, 24
   */
  includeDisplayTime: function(hours) {
    return (this.startTime <= hours) && (hours < this.finishTime);
  },

  /**
   * exsample
   *
   * {hour: 1, min: 30} => 1.5
   */
  convertHours: function(schedule) {
    return [
      schedule.start.hour + schedule.start.min / 60,
      schedule.finish.hour + schedule.finish.min / 60
    ];
  },

  setDisplayTime: function() {
    this.startTime = this.calendar.options.displayTime.first().hour;
    var finishTime = this.calendar.options.displayTime.last();
    this.finishTime = Math.ceil(finishTime.hour + finishTime.min / 60);
  },

  getTimeText: function(start, finish) {
    var calendar = this.calendar;
    return calendar.formatTime(start) + ' - ' + calendar.formatTime(finish);
  },

  isChengeSchedule: function(scheduleElement, newTime) {
    var schedule = scheduleElement.schedule;
    var changeStart = ((schedule.start.hour != newTime[0].hour) || (schedule.start.min != newTime[0].min));
    var changeFinish = ((schedule.finish.hour != newTime[1].hour) || (schedule.finish.min != newTime[1].min));

    if (scheduleElement.originalSchedule) {
      if (changeStart && changeFinish) {
        var currentDateStart = DateUtil.toDate(schedule.start).getTime();
        var OriginalDateStart = DateUtil.toDate(scheduleElement.originalSchedule.start).getTime();
        if (currentDateStart == OriginalDateStart) {
          changeFinish = false;
        } else {
          changeStart = false;
        }
      }
    }
    return {start: changeStart, finish: changeFinish};
  }
});


/**
 * CalendarDay Class
 */
var CalendarDay = Class.create();
CalendarDay.id = {
  header: 'dayHeader'  
}
Object.extend(CalendarDay.prototype, CalendarWeek.prototype);
Object.extend(CalendarDay.prototype, {

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

  destroy: function() {
    this.calendar.options.displayIndexes = this.calendar.options.displayIndexesOld;
    this.calendar.options.weekIndex      = this.calendar.options.weekIndexOld;
    delete this.calendar.options.displayIndexesOld;
    delete this.calendar.options.weekIndexOld;
  },

  /*** Day ***/
  /********************************** build functions **********************************/
  buildHeaderCenter: function() {
    var headerText = this.calendar.date.toDateString();
    if (this.calendar.options.dayHeaderFormat) {
      var date = this.calendar.date;
      headerText = new Template(this.calendar.options.dayHeaderFormat).evaluate(
        {year: date.getFullYear(), month: date.getMonth() + 1, day: date.getDate()});
    }
    var container  = Builder.node('TD');
    this.calendar.classNames.addClassNames(container, 'years');

    var id = this.calendar.element.id.appendSuffix(CalendarDay.id.header);
    var node = Builder.node('SPAN', {id: id}, [headerText]);
    this.calendar.classNames.addClassNames(node, 'ym');
    container.appendChild(node);

    return container;
  },

  /*** Day ***/
  /********************************** private method **********************************/
  changeCalendar: function(event) {
    var element = Event.element(event);
    var oldDate = new Date(this.calendar.date.toDateString());

    if (Element.hasClassName(element, Calendar.className.preWeekMark)) {
      this.calendar.date.setDate(this.calendar.date.getDate() - 1);
    } else if (Element.hasClassName(element, Calendar.className.nextWeekMark)) {
      this.calendar.date.setDate(this.calendar.date.getDate() + 1);
    }

    this.calendar.options.changeCalendar(this.calendar.date, oldDate);
    this.calendar.refresh();
  }
});


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

var CalendarResizeableEx = Class.create();
Object.extend(CalendarResizeableEx.prototype, Resizeable.prototype);
Object.extend(CalendarResizeableEx.prototype, {
  initialize: function(element) {
    var options = Object.extend({
      top:         6,
      bottom:      6,
      left:        6,
      right:       6,
      minHeight:   0,
      minWidth:    0,
      zindex:      1000,
      resize:      null,
      distance:    1,     // add by spinelz
      change:      Prototype.emptyFunction,
      restriction: true
    }, arguments[1] || {});

    this.element      = $(element);
    this.handle 	  = this.element;

    Element.makePositioned(this.element); // fix IE    

    this.options      = options;

    this.active       = false;
    this.resizing     = false;   
    this.currentDirection = '';

    this.eventMouseDown = this.startResize.bindAsEventListener(this);
    this.eventMouseUp   = this.endResize.bindAsEventListener(this);
    this.eventMouseMove = this.update.bindAsEventListener(this);
    this.eventCursorCheck = this.cursor.bindAsEventListener(this);
    this.eventKeypress  = this.keyPress.bindAsEventListener(this);
    
    this.registerEvents();
  },

  startResize: function(event) {
    Event.stop(event);
    if(Event.isLeftClick(event)) {
      
      // abort on form elements, fixes a Firefox issue
      var src = Event.element(event);
      if(src.tagName && (
        src.tagName=='INPUT' ||
        src.tagName=='SELECT' ||
        src.tagName=='BUTTON' ||
        src.tagName=='TEXTAREA')) return;

      var dir = this.directions(event);
      if (dir.length > 0) {      
        this.active = true;
//    	  var offsets = Position.cumulativeOffset(this.element);
        this.startTop    = parseInt(Element.getStyle(this.element, 'top'), 10);
        this.startLeft   = parseInt(Element.getStyle(this.element, 'left'), 10);
        this.startWidth  = parseInt(Element.getStyle(this.element, 'width'), 10);
        this.startHeight = parseInt(Element.getStyle(this.element, 'height'), 10);
        this.startX = event.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
        this.startY = event.clientY + document.body.scrollTop + document.documentElement.scrollTop;
        
        this.currentDirection = dir;

        if (this.options.restriction) {
          var container       = this.element.parentNode;
          this.restDimensions = Element.getDimensions(container);
          this.restOffset     = Position.cumulativeOffset(container);
        }
      }
    }
  },

  draw: function(event) {
    Event.stop(event);
    var pointer = [Event.pointerX(event), Event.pointerY(event)];
    var style = this.element.style;

    if (this.currentDirection.indexOf('n') != -1) {
      if (this.restOffset[1] >= pointer[1]) return;
    	var pointerMoved = this.startY - pointer[1];
//    	var margin = Element.getStyle(this.element, 'margin-top') || "0";
    	var newHeight = this.map(this.startHeight + pointerMoved);
    	if (newHeight > this.options.minHeight) {
    		style.height = newHeight + "px";
    		style.top = this.map(this.startTop - pointerMoved) + "px";
    	}
    }
    if (this.currentDirection.indexOf('w') != -1) {
    	var pointerMoved = this.map(this.startX - pointer[0]);
    	var margin = Element.getStyle(this.element, 'margin-left') || "0";
    	var newWidth = this.startWidth + pointerMoved;
    	if (newWidth > this.options.minWidth) {
    		style.left = (this.startLeft - pointerMoved - parseInt(margin))  + "px";
    		style.width = newWidth + "px";
    	}
    }
    if (this.currentDirection.indexOf('s') != -1) {
      var bottom = this.restDimensions.height + this.restOffset[1];
    	var pointerMoved = pointer[1] - this.startY;
      if (bottom <= pointer[1]) return;
    	var newHeight = this.map(this.startHeight + pointer[1] - this.startY);
    	if (newHeight > this.options.minHeight) {
    		style.height = newHeight + "px";
//    		style.top    = this.startTop + "px";
    	}
    }
    if (this.currentDirection.indexOf('e') != -1) {
    	var newWidth = this.map(this.startWidth + pointer[0] - this.startX);
    	if (newWidth > this.options.minWidth) {
    		style.width = newWidth + "px";
    	}
    }
    if(style.visibility=="hidden") style.visibility = ""; // fix gecko rendering
    this.options.change(this.element);
  },

  directions: function(event) {
    var pointer       = [Event.pointerX(event), Event.pointerY(event)];
    var offsets       = Position.cumulativeOffset(this.element);
    var bodyScrollTop = document.documentElement.scrollTop || document.body.scrollTop;
    var scroll        = Position.realOffset(this.element)[1] - bodyScrollTop;

    var cursor = '';
    if (this.between(pointer[1] - offsets[1] + scroll, 0, this.options.top)) cursor += 'n';
    if (this.between((offsets[1] + this.element.offsetHeight) - pointer[1] - scroll, 0, this.options.bottom)) cursor += 's';
    if (this.between(pointer[0] - offsets[0], 0, this.options.left)) cursor += 'w';
    if (this.between((offsets[0] + this.element.offsetWidth) - pointer[0], 0, this.options.right)) cursor += 'e';

    return cursor;
  },

  map: function(length) {
    return Math.round(length / this.options.distance) * this.options.distance;
  }
});
