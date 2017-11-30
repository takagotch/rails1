module TaggingHelper
  include Amrita2View::Helper

  def tag_name
    tag.name
  end

  def tag_url
    tagging = self
    eval_in_view do
      url_for(:controller=>:tag, :action=>:show, :id=>tagging.tag.id)
    end
  end

  def show_only_tag_with_form
    tagging = self
    Amrita2::Core::Hook.new do
      render_me_with(tagging) unless tagging.form_name.nil?
    end
  end

  def show_tagging_value
    tagging = self
    eval_in_view do
      form_name = "tagging/#{tagging.form_name}/show"
      @tagging = tagging
      render :partial=>form_name, :object=>tagging
    end
  end

  def edit_tagging_value
    tagging = self
    eval_in_view do
      form_name = "tagging/#{tagging.form_name}/edit"
      @tagging = tagging
      render :partial=>form_name, :object=>tagging
    end
  end
end
