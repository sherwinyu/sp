class User
  include Mongoid::Document
  include Mongoid::Timestamps
  devise :database_authenticatable

  field :email, type: String
  field :encrypted_password, type: String

  ## Database authenticatable
  validates_presence_of :email
  validates_presence_of :encrypted_password

=begin
  field :remember_created_at, type: Time
=end


 end

