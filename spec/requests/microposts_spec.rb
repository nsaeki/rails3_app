require 'spec_helper'

describe "Microposts" do
  before(:each) do
    user = Factory(:user)
    visit signin_path
    fill_in :email, :with => user.email
    fill_in :password, :with => user.password
    click_button
  end
  
  describe "creation" do
    describe "failure" do
      it "should not make a new micropost" do
        lambda do
          visit root_path
          fill_in :micropost_content, :with => ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Micropost, :count)
      end
    end
    
    describe "success" do
      it "should make a new micropost" do
        content = "Lorem ipsum dolor sit amet"
        lambda do
          visit root_path
          fill_in :micropost_content, :with => content
          click_button
          response.should have_selector("span.content", :content => content)
        end.should change(Micropost, :count).by(1)
      end
    end
  end
  
  describe "delete link" do
    before(:each) do
      another_user = Factory(:user, :email => Factory.next(:email))
      @mp = Factory(:micropost, :user => another_user)
    end
    
    it "should not appear created by another user" do
      visit root_path
      response.should_not have_selector("a", :href => micropost_path(@mp),
                                             :content => "delete")
    end
  end
end
