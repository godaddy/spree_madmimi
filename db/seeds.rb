require 'highline/import'

def prompt_for_mad_mimi_user_password
  if ENV['MAD_MIMI_USER_PASSWORD']
    password = ENV['MAD_MIMI_USER_PASSWORD'].dup
    say "Mad Mimi User Password #{password}"
  else
    password = ask('Password [madmimi123]: ') do |q|
      q.echo = false
      q.validate = /^(|.{5,40})$/
      q.responses[:not_valid] = 'Invalid password. Must be at least 5 characters long.'
      q.whitespace = :strip
    end
    password = 'madmimi123' if password.blank?
  end

  password
end

def prompt_for_mad_mimi_user_email
  if ENV['MAD_MIMI_USER_EMAIL']
    email = ENV['MAD_MIMI_USER_EMAIL'].dup
    say "Mad Mimi User #{email}"
  else
    email = ask('Email [madmimi@example.com]: ') do |q|
      q.echo = true
      q.whitespace = :strip
    end
    email = 'madmimi@example.com' if email.blank?
  end

  email
end

def create_mad_mimi_user
  if ENV['AUTO_ACCEPT']
    password = 'madmimi123'
    email = 'madmimi@example.com'
  else
    puts 'Create the Mad Mimi user (press enter for defaults).'
    email = prompt_for_mad_mimi_user_email
    password = prompt_for_mad_mimi_user_password
  end
  attributes = {
    :password => password,
    :password_confirmation => password,
    :email => email,
    :login => email
  }

  load 'spree/user.rb'

  if existing_user = Spree::User.find_by_email(email)
    say "\nWARNING: There is already a user with the email: #{email}, so no account changes were made.  If you wish to create a new Mad Mimi user, please run rake spree_madmimi:user:create again with a different email.\n\n"
  else
    admin = Spree::User.new(attributes)
    if admin.save
      role = Spree::Role.find_or_create_by(name: 'admin')
      admin.spree_roles << role
      admin.save
      admin.generate_spree_api_key!
      MadMimi.api_user_id = admin.id
      say "Done!"
    else
      say "There was some problems with persisting new Mad Mimi user:"
      admin.errors.full_messages.each do |error|
        say error
      end
    end
  end
end

if !MadMimi.api_user_exists?
  create_mad_mimi_user
else
  puts 'Mad Mimi user has already been previously created.'
  if agree('Would you like to create a new Mad Mimi user? (yes/no)')
    create_mad_mimi_user
  else
    puts 'No Mad Mimi user created.'
  end
end
