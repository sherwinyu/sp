ActiveAdmin.register DataPoint do
  index do
    column :submitted_at
    column :created_at
    column :details
    default_actions
  end

  filter :email

  form partial:  "form"
=begin
  do |f|
    f.inputs "Admin Details" do
      f.input :submitted_at
      f.input :details
    end
    f.actions
  end
=end
end
