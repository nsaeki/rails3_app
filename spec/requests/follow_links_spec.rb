require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "FollowLinks" do
  before(:each) do
    @user = Factory(:user)
    integration_sign_in(@user)
    @another = Factory(:user, :email => Factory.next(:email))
  end

  describe "when non following user" do
    it "should appear follow link" do
      get user_path(@another)
      response.should have_selector("input", :value => "Follow")
    end
  end
  
  describe "when following user" do
    it "should appear unfollow link" do
      @user.follow!(@another)
      get user_path(@another)
      response.should have_selector("input", :value => "Unfollow")
    end
  end
  
  it "should not appear follow link for myself" do
    get user_path(@user)
    response.should_not have_selector("div#follow_form")
  end
end