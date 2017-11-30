module MemoHelper
  include Amrita2View::Helper

  def memo_disp
    memo = self.memo.memo
    if memo
      memo.gsub("\n", "<br />")
    else
      ""
    end
  end
end
