describe "TestWithOneUser", :shared => true do
  before(:each) do
    @user = User.create :login=>'u1', :email => 'tnakajima@brain-tokyo.jp', :firstname => 'Taku', :lastname => 'Nakajima'
    @user.initial_setup
  end

  after(:each) do
    User.count.should == 0
    Project.count.should == 0
    Task.count.should == 0
    Tag.count.should == 0
    Tagging.count.should == 0
  end

  it "should be valid" do
    @user.should be_valid
  end

  def login
    session[:user_id] = @user.id
  end
end
