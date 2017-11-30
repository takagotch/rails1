require File.dirname(__FILE__) + '/../spec_helper'

describe User, "yaml save and load" do
  before(:each) do
    Time.with_mock_time("2007 1/2 3:4:5") do
      @user = User.create! :login=>'u1', :email => 'tnakajima@brain-tokyo.jp',
      :firstname => 'Taku', :lastname => 'Nakajima'
      Time.advance(1.hour)
      @user.initial_setup
      @user.save!
    end
  end

  after(:each) do
    @user.root_project.locked = false
    @user.root_project.save!
    @user.destroy
  end

  it "can be saved as yaml" do
    yaml_obj = @user.to_yaml_obj
    yaml_obj.should == {
      :login => 'u1',
      :email => 'tnakajima@brain-tokyo.jp',
      :firstname => 'Taku',
      :lastname => 'Nakajima',
      :created_at => Time.parse("2007-1-2 3:4:5"),
      :updated_at => Time.parse("2007-1-2 4:4:5"),
      :ver => "1.0",
      :tags => [],
      :projects => [
                    {
                      :parent=>nil,
                      :locked => true,
                      :name=>"root",
                      :created_at => Time.parse("2007-1-2 3:4:5"),
                      :updated_at => Time.parse("2007-1-2 4:4:5"),
                      :reviewed_at => nil,
                      :review_interval=>1,
                      :tasks => [],
                    },
                   ],
    }

    check_user @user, u2=User.load_yaml_obj(yaml_obj, 'u2')
    check_user @user, u3=User.load_yaml(@user.to_yaml, 'u3')

    u2.destroy
    u3.destroy
  end

  it "can be saved as yaml with projects" do
    user = nil
    begin
      Time.with_mock_time("2007-1-2 3:4:5") do
        user = User.create! :login=>'u2', :email => 'tnakajima@brain-tokyo.jp', :firstname => 'Taku', :lastname => 'Nakajima'
        user.initial_setup
        user.save!
        user.root_project.should_not be_nil
        user.root_project.user.should_not be_nil
        Project.create!(:name => 'sub1', :review_interval =>7, :user=>user, :parent=>user.root_project)
      end

      user.root_project.should have(1).sub_projects
      user.should have(2).projects
      yaml_obj = user.to_yaml_obj
      yaml_obj.should == {
        :login => 'u2',
        :email => 'tnakajima@brain-tokyo.jp',
        :firstname => 'Taku',
        :lastname => 'Nakajima',
        :created_at => Time.parse("2007-1-2 3:4:5"),
        :updated_at => Time.parse("2007-1-2 3:4:5"),
        :ver => "1.0",
        :tags => [],
        :projects => [
                      {
                        :parent=>nil,
                        :name=>"root",
                        :locked => true,
                        :created_at => Time.parse("2007-1-2 3:4:5"),
                        :updated_at => Time.parse("2007-1-2 3:4:5"),
                        :reviewed_at => nil,
                        :review_interval=>1,
                        :tasks => [],
                      },
                      {
                        :locked => nil,
                        :name=> 'sub1',
                        :review_interval => 7,
                        :created_at => Time.parse("2007-1-2 3:4:5"),
                        :updated_at => Time.parse("2007-1-2 3:4:5"),
                        :reviewed_at => nil,
                        :parent => 'root',
                        :tasks => [],
                      },
                     ]
      }

      u2=User.load_yaml_obj(yaml_obj, 'u22')
      check_user user, u2
      u3=User.load_yaml(user.to_yaml, 'u33')
      check_user user, u3

      u2.destroy
      u3.destroy
    ensure
      user.root_project.locked = false
      user.root_project.save!
      user.destroy
    end
  end

  it "can be saved as yaml with projects and tasks" do
    user = nil
    begin
      Time.with_mock_time("2007-1-2 3:4:5") do
        user = User.create :login=>'u3', :email => 'tnakajima@brain-tokyo.jp', :firstname => 'Taku', :lastname => 'Nakajima'
        user.initial_setup
        user.save!
        prj = user.root_project.sub_projects.create(:name => 'sub1', :review_interval =>7)
        prj.tasks.create(:text => 'task1')
      end
      user.root_project.should have(1).sub_projects
      user.should have(2).projects
      yaml_obj = user.to_yaml_obj
      yaml_obj.should == {
        :login => 'u3',
        :email => 'tnakajima@brain-tokyo.jp',
        :firstname => 'Taku',
        :lastname => 'Nakajima',
        :created_at => Time.parse("2007-1-2 3:4:5"),
        :updated_at => Time.parse("2007-1-2 3:4:5"),
        :ver => "1.0",
        :tags => [],
        :projects => [
                      {
                        :locked => true,
                        :parent=>nil,
                        :name=>"root",
                        :created_at => Time.parse("2007-1-2 3:4:5"),
                        :updated_at => Time.parse("2007-1-2 3:4:5"),
                        :reviewed_at => nil,
                        :review_interval=>1,
                        :tasks => [],
                      },
                      {
                        :locked => nil,
                        :name=> 'sub1',
                        :review_interval => 7,
                        :created_at => Time.parse("2007-1-2 3:4:5"),
                        :updated_at => Time.parse("2007-1-2 3:4:5"),
                        :reviewed_at => nil,
                        :parent => 'root',
                        :tasks => [
                                   { :text=>"task1",
                                     :created_at => Time.parse("2007-1-2 3:4:5"),
                                     :updated_at => Time.parse("2007-1-2 3:4:5"),
                                     :url=>nil,
                                     :done_at=>nil,
                                     :trashed_at=>nil,
                                     :tag => '',
                                     :tagging_value=> {},
                                   },
                                  ],
                      },
                     ]
      }

      u2=User.load_yaml_obj(yaml_obj, 'u22')
      check_user user, u2
      u3=User.load_yaml(user.to_yaml, 'u33')
      check_user user, u3

      u2.destroy
      u3.destroy
    ensure
      user.root_project.locked = false
      user.root_project.save!
      user.destroy
    end
  end

  it "can be saved as yaml with tasks with tags" do
    user = nil
    begin
      Time.with_mock_time("2007-1-2 3:4:5") do
        user = User.create :login=>'u3', :email => 'tnakajima@brain-tokyo.jp', :firstname => 'Taku', :lastname => 'Nakajima'
        user.initial_setup
        user.save!
        prj = user.root_project.sub_projects.create(:name => 'sub1', :review_interval =>7)
        task = prj.tasks.create(:text => 'task1')
        task.tag="aaa bbb"
        task.save!
      end
      user.root_project.should have(1).sub_projects
      user.should have(2).projects
      yaml_obj = user.to_yaml_obj
      yaml_obj.should == {
        :login => 'u3',
        :email => 'tnakajima@brain-tokyo.jp',
        :firstname => 'Taku',
        :lastname => 'Nakajima',
        :created_at => Time.parse("2007-1-2 3:4:5"),
        :updated_at => Time.parse("2007-1-2 3:4:5"),
        :ver => "1.0",
        :tags=>[
                {
                  :name=>"aaa",
                  :class=>"PlainTag"
                },
                {
                  :name=>"bbb",
                  :class=>"PlainTag"
                }
               ],
        :projects => [
                      {
                        :locked => true,
                        :parent=>nil,
                        :name=>"root",
                        :created_at => Time.parse("2007-1-2 3:4:5"),
                        :updated_at => Time.parse("2007-1-2 3:4:5"),
                        :reviewed_at => nil,
                        :review_interval=>1,
                        :tasks => [],
                      },
                      {
                        :locked => nil,
                        :name=> 'sub1',
                        :review_interval => 7,
                        :created_at => Time.parse("2007-1-2 3:4:5"),
                        :updated_at => Time.parse("2007-1-2 3:4:5"),
                        :reviewed_at => nil,
                        :parent => 'root',
                        :tasks => [
                                   { :text=>"task1",
                                     :created_at => Time.parse("2007-1-2 3:4:5"),
                                     :updated_at => Time.parse("2007-1-2 3:4:5"),
                                     :url=>nil,
                                     :done_at=>nil,
                                     :trashed_at=>nil,
                                     :tag => 'aaa bbb',
                                     :tagging_value=> {},
                                   }
                                  ],
                      },
                     ]
      }

      u2=User.load_yaml_obj(yaml_obj, 'u22')
      check_user user, u2
      u3=User.load_yaml(user.to_yaml, 'u33')
      check_user user, u3

      u2.destroy
      u3.destroy
    ensure
      user.root_project.locked = false
      user.root_project.save!
      user.destroy
    end
  end

  it "can be saved as yaml with tasks with various tags" do
    user = nil
    begin
      Time.with_mock_time("2007-1-2 3:4:5") do
        user = User.create :login=>'u3', :email => 'tnakajima@brain-tokyo.jp', :firstname => 'Taku', :lastname => 'Nakajima'
        user.initial_setup
        user.save!
        user.tags << MemoTag.create(:user=>user, :name => 'memo')
        prj = user.root_project.sub_projects.create(:name => 'sub1', :review_interval =>7)
        task = prj.tasks.create(:text => 'task1')
        task.tagging_value['memo'][:memo] =  "abc\nefg\nhij\zzzzzzzzzz"

        task.tag="aaa id:essa memo"
        task.save!

        dtag = user.find_tag("id:essa")
        dtag.address.should be_nil
        dtag.create_address(:email=>"tnaka@dc4.so-net.ne.jp")
      end
      user.reload
      user.root_project.should have(1).sub_projects
      user.should have(3).tags
      user.should have(2).projects
      yaml_obj = user.to_yaml_obj
      # pp yaml_obj
      yaml_obj.should == {
        :login => 'u3',
        :email => 'tnakajima@brain-tokyo.jp',
        :firstname => 'Taku',
        :lastname => 'Nakajima',
        :created_at => Time.parse("2007-1-2 3:4:5"),
        :updated_at => Time.parse("2007-1-2 3:4:5"),
        :ver => "1.0",
        :tags=>[
                {
                  :name=>"aaa",
                  :class=>"PlainTag"
                },
                {
                  :name=>"id:essa",
                  :class=> "DelegationTag",
                  :address => {
                    :mixi=>nil,
                    :twitter=>nil,
                    :tel1=>nil,
                    :memo=>nil,
                    :tel2=>nil,
                    :email=>"tnaka@dc4.so-net.ne.jp",
                    :skype=>nil
                  }
                },
                {
                  :name=>"memo",
                  :class=>"MemoTag"
                },
               ],
        :projects => [
                      {
                        :locked => true,
                        :parent=>nil,
                        :name=>"root",
                        :created_at => Time.parse("2007-1-2 3:4:5"),
                        :updated_at => Time.parse("2007-1-2 3:4:5"),
                        :reviewed_at => nil,
                        :review_interval=>1,
                        :tasks => [],
                      },
                      {
                        :locked => nil,
                        :name=> 'sub1',
                        :review_interval => 7,
                        :created_at => Time.parse("2007-1-2 3:4:5"),
                        :updated_at => Time.parse("2007-1-2 3:4:5"),
                        :reviewed_at => nil,
                        :parent => 'root',
                        :tasks => [
                                   { :text=>"task1",
                                     :created_at => Time.parse("2007-1-2 3:4:5"),
                                     :updated_at => Time.parse("2007-1-2 3:4:5"),
                                     :url=>nil,
                                     :done_at=>nil,
                                     :trashed_at=>nil,
                                     :tag => 'aaa id:essa memo',
                                     :tagging_value=>{
                                       'memo'=>{ :memo=> "abc\nefg\nhij\zzzzzzzzzz" },
                                     },
                                   }
                                  ],
                      },
                     ]
      }

      u2=User.load_yaml_obj(yaml_obj, 'u22')
      check_user user, u2
      u3=User.load_yaml(user.to_yaml, 'u33')
      check_user user, u3

      u2.destroy
      u3.destroy
    ensure
      user.root_project.locked = false
      user.root_project.save!
      user.destroy
    end
  end

  private

  def check_user(u1, u2)
    check(u1,u2)
    u1.tags.each do |tag|
      #p tag.name, u2.tags,u2.tags.find_by_name(tag.name)
      check(tag, u2.tags.find_by_name(tag.name))
    end
    check_project u1.root_project, u2.root_project
  end

  def check_project(p1, p2)
    check(p1, p2)
    p1.sub_projects.each_with_index do |p, n|
      check_project p, p2.sub_projects[n]
    end
    p1.tasks.each_with_index do |t, n|
      check_task t, p2.tasks[n]
    end
  end

  def check_task(t1, t2)
    check(t1, t2)
    t1.tag.should == t2.tag
    t1.load_tagging_value
    t2.load_tagging_value
    t1.tagging_value.should == t2.tagging_value
  end

  def check(r1, r2)
    r1.class.should == r2.class
    a1 = r1.attributes
    a2 = r2.attributes
    a1.keys.select do |key|
      key =~ /.*id$/ or key == 'login'
    end.each do |k|
      a1.delete(k)
      a2.delete(k)
    end
    a1.keys.should == a2.keys
    a1.should == a2
  end
end

