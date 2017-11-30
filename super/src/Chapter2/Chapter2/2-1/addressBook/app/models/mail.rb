class Mail < ActiveRecord::Base
    belongs_to  :address
    validates_format_of :mailAddress, :with=> /([a-zA-Z0-9]+)@([a-zA-Z0-9]+)/  , :message => "No Input data(mail)."
end
