FactoryGirl.define do
  factory :foobar, class: Spree::Store do
    code 'foobar'
    name 'Foo Bar'
    url 'foobar.com'
    mail_from_address 'spec@foobar.com'
    default_currency 'FOO'

  end
end