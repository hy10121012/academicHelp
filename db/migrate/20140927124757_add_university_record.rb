class AddUniversityRecord < ActiveRecord::Migration
  def change
    add_column :universities, :is_writer_university, :boolean

    University.create(:name=>'University of Cambridge',:country_id=>'1',:level=>'1',:is_writer_university=>true)
    University.create(:name=>'London School of Economics',:country_id=>'1',:level=>'1',:is_writer_university=>true)
    University.create(:name=>'Imperial College',:country_id=>'1',:level=>'1',:is_writer_university=>true)
    University.create(:name=>'University of Oxford',:country_id=>'1',:level=>'1',:is_writer_university=>true)
    University.create(:name=>'Warwick',:country_id=>'1',:level=>'1')
    University.create(:name=>'University College London',:country_id=>'1',:level=>'1',:is_writer_university=>true)
    University.create(:name=>'Plymouth University',:country_id=>'1',:level=>'5',:is_writer_university=>true)

    University.create(:name=>'Harvard University',:country_id=>'2',:level=>'1',:is_writer_university=>true)
    University.create(:name=>'Standford University',:country_id=>'2',:level=>'1',:is_writer_university=>true)
    University.create(:name=>'MIT',:country_id=>'2',:level=>'1',:is_writer_university=>true)
    University.create(:name=>'Yale University',:country_id=>'2',:level=>'1',:is_writer_university=>true)
    University.create(:name=>'New York University',:country_id=>'2',:level=>'2',:is_writer_university=>true)
    University.create(:name=>'Brown University',:country_id=>'2',:level=>'2',:is_writer_university=>true)
    University.create(:name=>'Boston University',:country_id=>'2',:level=>'3',:is_writer_university=>true)

    University.create(:name=>'Melbourne University',:country_id=>'3',:level=>'2',:is_writer_university=>true)
    University.create(:name=>'Sydney University',:country_id=>'3',:level=>'2',:is_writer_university=>true)
    University.create(:name=>'New South Wales University',:country_id=>'3',:level=>'2',:is_writer_university=>true)
  end
end
