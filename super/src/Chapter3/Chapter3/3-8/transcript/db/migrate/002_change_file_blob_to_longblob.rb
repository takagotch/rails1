class ChangeFileBlobToLongblob < ActiveRecord::Migration
  def self.up
    #カラム型をLONGBLOB型に変更するSQL文字列
    execute "ALTER TABLE transcripts MODIFY file LONGBLOB;"
  end

  def self.down
    #カラム型をBLOB型に戻す
    change_column :transcripts , :file , :binary
  end
end
