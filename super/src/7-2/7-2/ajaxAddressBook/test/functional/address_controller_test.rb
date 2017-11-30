require File.dirname(__FILE__) + '/../test_helper'
require 'address_controller'

# Re-raise errors caught by the controller.
class AddressController; def rescue_action(e) raise e end; end

class AddressControllerTest < Test::Unit::TestCase
  fixtures :addresses

	NEW_ADDRESS = {}	# e.g. {:name => 'Test Address', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = AddressController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = addresses(:first)
		@first = Address.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'address/component'
    addresses = check_attrs(%w(addresses))
    assert_equal Address.find(:all).length, addresses.length, "Incorrect number of addresses shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'address/component'
    addresses = check_attrs(%w(addresses))
    assert_equal Address.find(:all).length, addresses.length, "Incorrect number of addresses shown"
  end

  def test_create
  	address_count = Address.find(:all).length
    post :create, {:address => NEW_ADDRESS}
    address, successful = check_attrs(%w(address successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal address_count + 1, Address.find(:all).length, "Expected an additional Address"
  end

  def test_create_xhr
  	address_count = Address.find(:all).length
    xhr :post, :create, {:address => NEW_ADDRESS}
    address, successful = check_attrs(%w(address successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal address_count + 1, Address.find(:all).length, "Expected an additional Address"
  end

  def test_update
  	address_count = Address.find(:all).length
    post :update, {:id => @first.id, :address => @first.attributes.merge(NEW_ADDRESS)}
    address, successful = check_attrs(%w(address successful))
    assert successful, "Should be successful"
    address.reload
   	NEW_ADDRESS.each do |attr_name|
      assert_equal NEW_ADDRESS[attr_name], address.attributes[attr_name], "@address.#{attr_name.to_s} incorrect"
    end
    assert_equal address_count, Address.find(:all).length, "Number of Addresss should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	address_count = Address.find(:all).length
    xhr :post, :update, {:id => @first.id, :address => @first.attributes.merge(NEW_ADDRESS)}
    address, successful = check_attrs(%w(address successful))
    assert successful, "Should be successful"
    address.reload
   	NEW_ADDRESS.each do |attr_name|
      assert_equal NEW_ADDRESS[attr_name], address.attributes[attr_name], "@address.#{attr_name.to_s} incorrect"
    end
    assert_equal address_count, Address.find(:all).length, "Number of Addresss should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	address_count = Address.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal address_count - 1, Address.find(:all).length, "Number of Addresss should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	address_count = Address.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal address_count - 1, Address.find(:all).length, "Number of Addresss should be one less"
    assert_template 'destroy.rjs'
  end

protected
	# Could be put in a Helper library and included at top of test class
  def check_attrs(attr_list)
    attrs = []
    attr_list.each do |attr_sym|
      attr = assigns(attr_sym.to_sym)
      assert_not_nil attr,       "Attribute @#{attr_sym} should not be nil"
      assert !attr.new_record?,  "Should have saved the @#{attr_sym} obj" if attr.class == ActiveRecord
      attrs << attr
    end
    attrs.length > 1 ? attrs : attrs[0]
  end
end
