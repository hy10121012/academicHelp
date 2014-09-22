require 'test_helper'
class WriterMailerTest < ActionMailer::TestCase
  tests WriterMailer

  def test_welcome_email
    user = User.where(:email=>'MyString')
    # Send the email, then test that it got queued
    email = WriterMailer.welcome_email(user).deliver
    assert !ActionMailer::Base.deliveries.empty?

    # Test the body of the sent email contains what we expect it to
    assert_equal [@user.email], email.to
    assert_equal "Welcome to My Awesome Site", email.subject
    assert_match /Welcome to example.com, #{user.first_name}/, email.body
  end
end
