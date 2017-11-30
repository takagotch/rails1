class WeightburndownController < ApplicationController
  def index
    weightburndownchart
    #calendarアクションを呼び出す
    calendar
    render :action => 'weightburndownchart'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :weightburndownchart ],
         :redirect_to => { :action => :index }

  def weightburndownchart
    @loadmap = Loadmap.find(:first)
    @dailyweight = Dailyweight.find(:first,:conditions=> ["submit_date=?",Date.today])
  end

  def draw
    #loadmapsデータ抽出
    loadmap = Loadmap.find(:first)
    
    #dailyweightsデータ抽出
    dailyweights = Dailyweight.find(:all,:select=>"todays_weight,submit_date",:order=>"submit_date")

    #グラフのテーマ（デザイン）を定義します。
    theme = {
     :colors => ["#FF0000", "#0000FF"],
     :marker_color => "#999999",
     :font_color => "#000000",
     :background_colors => ["#FFDDDD","#FFFFFF"]
    }
    
    #グラフそのものの各種定義を行います。
    @g = Gruff::Line.new 500
    @g.title = "ビクトリーまであと#{loadmap.target_date - Date.today}日！(#{Date.today.strftime("%Y/%m/%d")})" 
    @g.theme = theme
    #日本語のフォントを用いるため、フォントファイルまでのパスをセットします。
    @g.font = "C:/WINDOWS/Fonts/msgothic.ttc"

    #ロードマップ期間を計算します。
    loadmapspan = loadmap.target_date - loadmap.start_date
    
    #mapメソッドを用いて、日々の体重が格納された配列を作成します。
    weightrecords=dailyweights.map {|w|w.todays_weight}

    #Loadmap配列を作成する
    loadmaprecords=Array.new(loadmapspan.to_i)
    loadmaprecords.shift
    loadmaprecords.unshift(loadmap.current_weight)
    loadmaprecords.push(loadmap.target_weight)

    #グラフのラベルに用いるのハッシュを作成します。
    labels=Hash.new
    loadmaprecords.each_with_index {|l,idx|
      if idx==0 then
        labels.store(idx,loadmap.start_date.strftime("%m/%d"))
      elsif idx==loadmapspan then
        labels.store(idx,loadmap.target_date.strftime("%m/%d"))
      else
        labels.store(idx," ")
      end
    }
    
    #グラフのラベルに目標日付をセットします。
    labels.store(loadmapspan.to_i,loadmap.target_date.strftime("%m/%d")) 
   
    #グラフのデータをセットします。
    #ロードマップのデータをセットします。
    @g.data("ロードマップ",loadmaprecords)
    #日々の体重をセットします。
    @g.data("あなたの体重",weightrecords)

    #グラフにラベルをセットします。
    @g.labels=labels
    #生成されたグラフの画像を送信します。
    send_data @g.to_blob, :type => 'image/png'
  end

  private
  
  def calendar
    #パラメータがあればパラメータから、なければ現在の年号を格納します。
    @year = params[:year] ? params[:year].to_i : Time.now.year
    #パラメータがあればパラメータから、なければ現在の月を格納します。
    @month = params[:month] ? params[:month].to_i : Time.now.month
    #正しい暦日付かどうかを検証します。
    unless Date.valid_date?(@year, @month, 1)
      @year = Time.now.year
      @month = Time.now.month
    end
    
    #今月の日付を格納します。
    @this = Date.new(@year, @month, 1)
    #先月の日付を格納します。
    @prev = (@this << 1)
    #次月の日付を格納します。
    @next = (@this >> 1)
    
    #日付と対応させた体重を格納したハッシュを作成します。
    @weight_records = Hash.new{|hash, key| hash[key] = []}
    Dailyweight.find(:all,
                     :conditions => ['submit_date >= ? AND submit_date < ?', @this, @next]).each do |dailyweight|
      date = Date.new(dailyweight.submit_date.year,
                      dailyweight.submit_date.month,
                      dailyweight.submit_date.day)
      @weight_records[date] << dailyweight
    end
  end

end
