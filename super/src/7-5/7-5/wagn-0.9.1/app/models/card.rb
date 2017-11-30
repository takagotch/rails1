require_dependency 'acts_as_card_extension'

# FIXME: this is here because errors defined in permissions break without it? kinda dumb
module Card    
  class CardError < Wagn::Error   
    attr_reader :card
    def initialize(card)
      @card = card
      super build_message 
    end    
    
    def build_message
      "#{@card.name} has errors: #{@card.errors.full_messages.join(', ')}"
    end
  end
end
  

require 'json'
require_dependency 'card/base' 
require_dependency 'card/tracked_attributes'
require_dependency 'card/templating'
require_dependency 'card/defaults' 
require_dependency 'card/permissions'
require_dependency 'card/search'


Card::Base.class_eval do       
  include CardLib::TrackedAttributes
  include CardLib::Templating
  include CardLib::Defaults
  include CardLib::Permissions                               
  include CardLib::Search
end
 

Dir["#{RAILS_ROOT}/app/cardtypes/*.rb"].sort.each do |cardtype|
  cardtype.gsub!(/.*\/([^\/]*)$/, '\1')
  begin
    require_dependency "cardtypes/#{cardtype}"
  rescue Exception=>e
    raise "Error loading cardtypes/#{cardtype}: #{e.message}"
  end
end
   
    
# Hack to get ActiveRecord to load dynamic Cardtype-- otherwise it throws the
# "SubclassNotFound" error when loading the card object. 
#
# FIXME: should check if this is still necessary-- the relevant rails code
#  looks different now
module ActiveRecord
  class Base
    def compute_type(type_name)
      warn "LOOKING FOR #{type_name}"
      modularized_name = type_name_with_module(type_name)
      begin
        if match_data = modularized_name.match(/^Card::(\w+)$/)
          Card.const_get(match_data[1])
        end
        instance_eval(modularized_name)
      rescue NameError => e
        instance_eval(type_name)
      end
    end
  end
end     

class HardTemplate
  def self.find(*args)
  end
end

class SoftTemplate
  def self.find(*args)
  end
end

module Card    
  mattr_reader :default_cardtype_key
  @@default_cardtype_key = "Basic"

  class << self
    def new(args={})
      args=args.stringify_keys unless args.nil?
      get_class_from_args(args).new(args)
    end
    
    def method_missing( method_id, *args )
      Card::Base.send(method_id, *args)
    end
    
    # FIXME -- the current system of caching cardtypes is not "thread safe":
    # multiple running ruby servers could get out of sync re: available cardtypes  
    def cardtypes
      load_cardtypes! unless @cardtypes
      @cardtypes
    end
    
    def cardtype_create_parties
      load_cardtypes! unless @cardtype_create_parties
      @cardtype_create_parties
    end

    def load_cardtypes!    
      @role_cache = {}
      @cardtypes = {}
      @cardtype_create_parties = {}
      Card::Base.connection.select_all(%{
        select distinct ct.class_name, c.name, p.party_type, p.party_id 
        from cardtypes ct 
        join cards c on c.extension_id=ct.id and c.type='Cardtype'    
         join permissions p on p.card_id=c.id and p.task='create' 
      }).each do |rec|
        @cardtypes[rec['class_name']] = rec['name'];   
        unless rec['party_type'] == 'Role'
          raise "Bad Data: create permission for #{rec['class_name']} " +
            "should have party_type 'Role' not '#{rec['party_type']}'"
        end
        @cardtype_create_parties[rec['class_name']] = rec['party_id']
      end
    end
     
    def const_missing( class_id )
      super
    rescue NameError => e   
      if cardtypes.has_key?( class_id.to_s )
        newclass = Class.new( Card::Basic )
        const_set class_id, newclass
        # FIXME: is this necessary?
        if observers = Card::Base.instance_variable_get('@observer_peers')
          observers.each do |o|
            newclass.add_observer(o)
          end
        end
        return newclass
      else
        raise e
      end
    end
        
  end
end
