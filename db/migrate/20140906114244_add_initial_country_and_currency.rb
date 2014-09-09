class AddInitialCountryAndCurrency < ActiveRecord::Migration
  def change
    Country.create(:country_code=>'GB',:country_name=>'United Kingdom')
    Country.create(:country_code=>'US',:country_name=>'United States')
    Country.create(:country_code=>'AUS',:country_name=>'Australia')


    Currency.create(:currency_code=>'USD')
    Currency.create(:currency_code=>'GBP')
    Currency.create(:currency_code=>'AUD')



  end
end
