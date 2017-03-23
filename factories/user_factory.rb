FactoryGirl.define do
  factory :egift_user, class: Spree.user_class do
    email 'foo@bar.com'
    login { email }
    password 'secret'
    password_confirmation { password }
    authentication_token "authentication_token"
    remember_token "remember_token"
    user_current_currency = 'USD'

    # stub instance methods
    after(:build) do |user|
      class << user
        def send_admin_mail; true; end
      end
    end

    # associate store Jones to user
    after(:create) do |user|
      user.stores = [Spree::Store.first || create(:foobar)]
    end
  end
end