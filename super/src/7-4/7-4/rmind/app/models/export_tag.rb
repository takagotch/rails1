class ExportTag < Tag
  has_one :private_key, :dependent => :destroy
  after_create :create_private_key

  def create_private_key
    h = {
      :user => self.user,
      :export_tag => self,
    }
    PrivateKey.create(h)
  end
end
