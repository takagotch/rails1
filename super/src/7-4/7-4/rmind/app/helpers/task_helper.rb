module TaskHelper
  include Amrita2View::Helper

  def task_id
    %[task_#{self.id}]
  end

  def handle_id
    %[task_handle_#{self.id}]
  end

  def checkbox_id
    %[chkbox_#{self.id}]
  end

  def tag_edit_id
    %[tag_edit_#{self.id}]
  end

  def cycle_class
    eval_in_view_without_escape do
      cycle('list-line-even', 'list-line-odd')
    end
  end

  def done_check_ajax
    task = self
    eval_in_view_without_escape do
      target = url_for(:controller=>:main,:action=>:toggle_task_done,:id=>task.id)
      check_box_tag(task.checkbox_id, "1", task.done?) +
        javascript_tag(%[new CheckboxWatcher("#{task.checkbox_id}", "#{target}") ;])
    end
  end

  def done_check
    task = self
    eval_in_view_without_escape do
      check_box_tag task.checkbox_id, "1", task.done?, :onclick=>"location.href='#{url_for(:controller=>:tasks, :action=>:toggle_done, :id=>task.id)}'"
    end
  end


  def task_window_link
    task = self
    eval_in_view_without_escape do
      link_to_remote truncate(task.text, 50),
      {
        :url=> { :controller=>:main, :action=>:show_task_window, :id=>task.id },
        :update => 'task_work',
        :success=> %[ TaskWindow.show() ; ]
      },
      {
        :title=> task.text
      }
    end
  end

  def project_with_link
    project = self.project
    eval_in_view_without_escape do
      link_to truncate(project.name, 12),
        { :controller=>:project, :action=>:show, :id=>project.id },
        { :title => project.name }
    end
  end

  def taggings
    super.collect do |tagging|
      tagging.extend(TaggingHelper)
    end
  end

  def install_draggable
    task = self
    eval_in_view_without_escape do
      javascript_tag %[new Draggable('#{task.task_id}', {revert:true, ghosting:true, starteffect:null, handle:$('#{task.handle_id}') });]
    end
  end

  def install_tag_complete
    eval_in_view_without_escape do
      %[<div id='task_tag_auto_complete' class='autocomplete' />] +
        auto_complete_field('task_tag', :url=>{ :action=>:complete_tag, :controller=>:main }, :tokens=>' ')
    end
  end

  def tag_edit_link
    task = self
    eval_in_view_without_escape do
      remote_function(:url=>{ :action=>:show_task, :id=>task.id, :cmd=>'tag_edit'})
    end
  end

  def project_select_link
    task = self
    eval_in_view_without_escape do
      remote_function(:url=>{ :action=>:show_task, :id=>task.id, :cmd=>'prj_sel'})
    end
  end

  def sch_date
    taggings.each do |t|
      next unless t.kind_of?(ScheduleTagging)
      return t.schedule.date.asctime
    end
    nil
  end
end
