
# thanks to http://d.hatena.ne.jp/yukiwata/20070612/1181632682
module CriteriaQueryPlus
  class SQL < ::Criteria::NameExpression
    def self.[](*args)
      new(*args)
    end

    def conditions
      " ( #{ @name} ) "
    end
  end
end

