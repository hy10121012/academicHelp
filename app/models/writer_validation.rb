class WriterValidation < ActiveRecord::Base
  has_attached_file :file,
                    default_url: "javascript:alert('no resource is available')",
                    :path => lambda {|a|
                      ":rails_root/public/request_doc/#{a.instance.request_id}/:id_:filename"},
                    :url  => lambda {|a|
                      "/request_doc/#{a.instance.request_id}/:id_:filename"}

  validates_attachment_content_type   :file, :content_type=> ['application/pdf','application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document','application/vnd.ms-excel','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet']
end
