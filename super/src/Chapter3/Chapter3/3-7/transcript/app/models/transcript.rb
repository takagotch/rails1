class Transcript < ActiveRecord::Base

    def imagefile=(imagefile_field)
        @imagefile=imagefile_field
        unless @imagefile.blank?
            self.filename           =@imagefile.original_filename.gsub(/[^\w._-]/,'')
            self.content_type   =@imagefile.content_type.chomp
            self.file           =@imagefile.read
        end
    end

    def validate
        #ファイルが指定されなかった場合
        if @imagefile.blank?
            errors.add(:imagefile, "は必須入力です")
        else
            #ファイル形式が不正な場合
            if @imagefile.content_type !~/^image/
                errors.add(:imagefile , "ファイル形式が不正です")
            end
        end
    end

end
