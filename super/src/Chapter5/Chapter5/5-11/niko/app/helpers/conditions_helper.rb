module ConditionsHelper
  
  def sdate
    Date.today - 10
  end
  
  def edate
    Date.today + 2
  end
  
  def date_array
    a = Array.new
    sdate.upto(edate) do |d|
      a.push d
    end
    return a
  end
  
  def date_columns
    date_array.map {|d| d.strftime('%m/%d (%a)') }
  end
  
  # conditionオブジェクトの配列から日付をキーにしたhashを作ります
  def hash_by_date(conditions)
    h = Hash.new
    conditions.each{|c| h[c.date] = c }
    return h
  end

  def facemarks 
    { 'good'   => 'good.png', 
      'normal' => 'normal.png', 
      'bad'    => 'bad.png', 
      'blank'  => 'blank.png' }
  end

  def image_alt(condition)
    condition ? condition.name : 'blank'
  end

  def image_src(condition)
    facemarks[image_alt(condition)]
  end

  # アイコンパレットのフェイスマークのならび順
  def condition_strings
    ['good', 'normal', 'bad', 'blank']
  end 

end
