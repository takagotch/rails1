require File.dirname(__FILE__) + '/../../spec_helper'
require 'spec/common'

describe "/main/_edit_task" do
  it_should_behave_like "TestWithOneUser"

  before do
    assigns[:user] = @user
    cmd = @user.commands.do_create_task('xyz')
    assigns[:current_task] = cmd.task
    render 'main/_edit_task'
  end

  it "view" do
    response.should have_tag('div#current_task_area') do
      with_tag('table.noborder') do
        with_tag('tr') do
          with_tag('th', 'Common:')
          with_tag('th', 'Task:')
          with_tag('td') do
            with_tag("input[value='xyz'][type='text'][id='task_text'][name='task[text]']")
          end
        end
        with_tag('tr') do
          with_tag('th', 'Url:')
          with_tag('td') do
            with_tag("input[type='text'][id='task_url'][name='task[url]']")
          end
        end
        with_tag('tr') do
          with_tag('th', 'Project:')
          with_tag('td') do
            with_tag("select") do
              with_tag("option")
            end
          end
        end
        with_tag('tr') do
          with_tag('th', 'Tag:')
          with_tag('td') do
            with_tag("input[type='text'][id='task_tag'][name='task[tag]']")
          end
        end
      end
    end
  end
end
__END__

<<END
<div id = "current_task_area">
  <table class = "noborder">
    <tr>
      <th rowspan = "4">Common:</th>
      <th>Task:</th>
      <td>
        <input name="task[text]" size="70" type="text" id="task_text" value="xyz"></input>
      </td>
    </tr>
    <tr>
      <th>Url:</th>
      <td> <input id="task_url" name="task[url]" size="70" type="text" /> </td>
    </tr>
    <tr>
       <th>Project:</th>
       <td> <select id="task_project_id" name="task[project_id]"><option value="644" selected="selected">root</option></select> </td>
    </tr>
    <tr>
       <th>Tag:</th>
       <td>
         <input id="task_tag" name="task[tag]" size="60" type="text" value="" />
         <div id="task_tag_auto_complete"></div>
         <script type="text/javascript">
//<![CDATA[
var task_tag_auto_completer = new Ajax.Autocompleter('task_tag', 'task_tag_auto_complete', '/main/complete_tag', {tokens:' '})
//]]>
         </script>
        </td>
     </tr>
  </table>
  <div class = "button_area">
     <a href="/tasks/edit/422">detail</a> &nbsp;
     <input onclick="new Ajax.Request('/main/edit_task/422', { asynchronous:true, evalScripts:true, parameters:Form.serialize('current_task_area')});" type="button" value="update" />
  </div>
</ar:form>
</div>
