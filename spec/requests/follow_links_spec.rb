require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "FollowLinks" do
  before(:each) do
    @user = Factory(:user)
    integration_sign_in(@user)
    @another = Factory(:user, :email => Factory.next(:email))
  end

  it "should not appear follow link to myself" do
    get user_path(@user)
    response.should_not have_selector("div#follow_form")
  end

  describe "when non following user" do
    it "should appear follow link" do
      get user_path(@another)
      response.should have_selector("input", :value => "Follow")
    end
    
    describe "following" do
      it "should replace links and follower counts" do
        get user_path(@another)
        click_button "Follow"
        response.should have_selector("input", :value => "Unfollow")
        response.should have_selector("#followers", :content => "1 follower")
      end
    end
  end
  
  describe "when following user" do
    before(:each) do
      @user.follow!(@another)
    end

    it "should appear unfollow link" do
      get user_path(@another)
      response.should have_selector("input", :value => "Unfollow")
    end

    describe "unfollowing" do
      it "should replace links and follower counts" do
        get user_path(@another)
        click_button "Unfollow"
        response.should have_selector("input", :value => "Follow")
        response.should have_selector("#followers", :content => "0 follower")
      end
    end
  end
end