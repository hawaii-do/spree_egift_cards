source 'https://rubygems.org'

#gem 'spree', github: 'spree/spree', branch: '3-1-stable'
gem 'spree', git: 'https://github.com/te-ti/spree', branch: 'beta'

group :development, :test do
	gem 'spree_gateway', git: 'https://github.com/te-ti/spree_gateway', branch: 'beta'
	gem 'spree_auth_devise', git: 'https://github.com/te-ti/spree_auth_devise', tag: 'beta'
	gem 'spree_multi_domain', git: 'https://github.com/te-ti/spree-multi-domain', branch: 'beta'
	gem 'spree_multi_currency', git: 'https://github.com/te-ti/spree_multi_currency', branch: 'beta'
	gem 'spree_mail_settings', git: 'https://github.com/te-ti/spree_mail_settings', branch: 'beta'

	# TODO: Switch to 3-0-stable as soon as available !!!
	# Running on master for now as its the only branch that supports Spree 3.0
	gem 'spree_tax_cloud', git: 'https://github.com/te-ti/spree_tax_cloud', branch: 'beta'
	gem 'spree_smart_free_shipping', git: 'https://github.com/te-ti/spree_smart_free_shipping', branch: 'beta'

	gem 'spree_i18n', git: 'https://github.com/te-ti/spree_i18n', branch: 'beta'

	# Provides basic authentication functionality for testing parts of your engine
	#gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '3-1-stable'
	gem 'spree_auth_devise', git: 'https://github.com/te-ti/spree_auth_devise', tag: 'beta'
	gem 'amoeba'
	gem 'pry'
	gem 'factory_girl_rails'
end

gem 'rails', '~>4.2.2'

gem 'rack-cors', require: 'rack/cors'

gemspec
