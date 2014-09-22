#coding: utf-8
class AddInitialCountryAndCurrency < ActiveRecord::Migration
  def change
    Country.create(:country_code=>'GB',:country_name=>'United Kingdom')
    Country.create(:country_code=>'US',:country_name=>'United States')
    Country.create(:country_code=>'AUS',:country_name=>'Australia')


    Currency.create(:currency_code=>'USD')
    Currency.create(:currency_code=>'GBP')
    Currency.create(:currency_code=>'AUD')

    Education.create(:name=>'高中')
    Education.create(:name=>'本科')
    Education.create(:name=>'研究生')
    Education.create(:name=>'博士')

    SubjectArea.create(:name=>'计算机')
    SubjectArea.create(:name=>'金融')

    RequestType.create(:name=>'代写')
    RequestType.create(:name=>'检查')

  end
end
