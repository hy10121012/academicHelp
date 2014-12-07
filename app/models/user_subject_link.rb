class UserSubjectLink < ActiveRecord::Base
  has_one :user
  has_one :subject_area
end
