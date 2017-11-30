class Transcript < ActiveRecord::Base
    #TranscriptはUserに属する
    belongs_to :user
    def imagefile=(imagefile_field)
        #渡ってきたファイルをインスタンス変数に格納する
        @imagefile=imagefile_field
        #ファイルが指定されなかった場合をblank?で回避
        unless @imagefile.blank?
            self.filename       =@imagefile.original_filename.gsub(/[^\w._-]/,'')
            self.content_type   =@imagefile.content_type.chomp
            self.file           =@imagefile.read
        end
    end

    def validate
        #新規登録時にファイルが指定されなかった場合
        if @imagefile.blank? && self.file.blank?
            errors.add(:imagefile, "は必須入力です")
        else
            unless @imagefile.blank?
                #ファイル形式が不正な場合
                if @imagefile.content_type !~/^image/
                    errors.add(:imagefile , "ファイル形式が不正です")
                end
            end
        end
    end

end
