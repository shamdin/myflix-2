require 'spec_helper'

feature 'user invites friend' do
  scenario 'user succesfully invites friend and invitation is accepted' do
    alice = Fabricate(:user)
    sign_in(alice)
    visit new_invitation_path
    invite_a_friend
    friend_accepts_invitation
    friend_signs_in
    friend_should_follow(alice)
    inviter_should_follow_friend(alice)
    clear_email
  end

  def invite_a_friend
    fill_in "Friend's Name", with: "Joe Jo"
    fill_in "Friend's Email Address", with: "joe@example.com"
    fill_in "Message", with: "Hi, check out this site!"
    click_button "Send Invitation"
    sign_out
  end

  def friend_accepts_invitation
    open_email "joe@example.com"
    current_email.click_link "Accept invitation"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Joe Jo"
    click_button "Sign Up"
  end

  def friend_signs_in
    fill_in "Email", with: "joe@example.com"
    fill_in "Password", with: "password"
    click_button "Sign In"
  end

  def friend_should_follow(user)
    click_link "People"
    expect(page).to have_content(user.full_name)
    sign_out
  end

  def inviter_should_follow_friend(user)
    sign_in(user)
    click_link "People"
    expect(page).to have_content("Joe Jo")
  end
end
