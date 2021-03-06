require 'spec_helper'

describe "Users" do
  describe "signup" do
    describe "failure" do
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Login Name", :with => ""
          fill_in "Name", :with => ""
          fill_in "Email", :with => ""
          fill_in "Password", :with => ""
          fill_in "Confirmation", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end
    
    describe "success" do
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Login Name", :with => "example"
          fill_in "Name", :with => "Example User"
          fill_in "Email", :with => "user@example.com"
          fill_in "Password", :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
  end
    
  describe "when signed in" do
    describe "as a normal user" do
      before(:each) do
        @user = Factory(:user)
        integration_sign_in(@user)
      end

      it "should not have a delete link"  do
        visit users_path
        response.should_not have_selector("a", :href => user_path(@user),
                                               :content => "delete")
      end
    end

    describe "as a admin user" do
      before(:each) do
        @user = Factory(:user)
        @admin = Factory(:user, :email => "admin@example.com",
                                :admin => true)
        integration_sign_in(@admin)
      end

      it "should have a delete link"  do
        visit users_path
        response.should have_selector("a", :href => user_path(@user),
                                           :content => "delete")
      end
    end
  end
end
