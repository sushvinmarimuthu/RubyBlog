class UserMailer < ApplicationMailer
  default from: 'mug.sushvin@gmail.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to RubyBlog')
  end
end
