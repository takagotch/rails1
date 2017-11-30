class CreateTranscripts < ActiveRecord::Migration
  def self.up
    create_table(:transcripts) do |table|
      #タイトル
      table.column  :title , :string , :limit => 100 , :null => false
      #ファイル名
      table.column  :filename , :string
      #ファイル
      table.column  :file , :binary , :null => false
      #ファイルタイプ
      table.column :content_type , :string , :null => false
      #説明
      table.column  :description , :text
      #タグ
      table.column  :tag , :string , :limit => 100
      #ユーザID
      table.column  :user_id , :string , :limit => 80 , :null => false
      #作成日時
      table.column  :created_on , :timestamp , :null => false
      #更新日時
      table.column  :updated_on , :timestamp , :null => false
    end
  end

  def self.down
    #transcriptsテーブルを削除する
    drop_table  :transcripts
  end

end
