class ExportController < ApplicationController
  dummy = Tagging
  before_filter :authorize, :except => :ical
  around_filter :with_users_scope_for_export_tag, :except => :ical

  def index
    @export_tags = ExportTag.find(:all)
  end

  def show
    @main_url = request.request_uri
    @export_tag = ExportTag.find(params[:id])

    @schedules = @user.schedules.select do |task|
      task.tags.include?(@export_tag)
    end.collect do |task|
      task_to_ical(task)
    end
  end

  def new
    if request.method == :post
      @export_tag = ExportTag.create(params[:tag])
      redirect_to :action=>:index
    else
      @export_tag = ExportTag.new
    end
  end

  IcalSchedule = Struct.new(:uid, :timestamp, :summary, :dtstart, :dtend, :location, :description)

  def ical
    private_key = PrivateKey.find_by_key(params[:id])
    @export_tag = private_key.export_tag
    user = @export_tag.user

    @schedules = user.schedules.select do |task|
      task.tags.include?(@export_tag)
    end.collect do |task|
      task_to_ical(task)
    end

    response.content_type = Mime::TEXT
    render :partial=>'ical'
  end

  private
  def with_users_scope_for_export_tag
    ExportTag.with_scope({
                           :find   => {
                           :conditions => ["tags.user_id = ?", @user.id]
                           },
                           :create => { :user_id  => @user.id},
                         }) do
      yield
    end
  end

  def task_to_ical(task)
    uid = "#{task.id}@rmind.brain-tokyo.net"
    timestamp = task.created_at.strftime("%Y%m%dT%H%M%S")
    summary = task.text
    sch_tagging = task.taggings.to_a.find do |tagging|
      next unless tagging.kind_of?(ScheduleTagging)
      tagging
    end
    return nil unless sch_tagging
    sch = sch_tagging.schedule

    dtstart = dtend = "%4d%02d%02d" % [sch.date.year, sch.date.month, sch.date.day]
    if sch.from
      if sch.to
        dtstart = sch.from.strftime("%Y%m%dT%H%M%S")
        dtend = sch.to.strftime("%Y%m%dT%H%M%S")
      else
        dtstart = dtend = sch.from.strftime("%Y%m%dT%H%M%S")
      end
    end
    memo = sch.memo
    memo.gsub!(/^/, " ") if memo
    IcalSchedule.new(uid, timestamp, summary, dtstart, dtend, sch.place, memo)
  end
end
