class User
  include Mongoid::Document
  include Mongoid::Timestamps
  devise :database_authenticatable, :registerable, :rememberable

  field :email, type: String
  field :encrypted_password, type: String

  ## Database authenticatable
  validates_presence_of :email
  validates_presence_of :encrypted_password

  field :remember_created_at, type: Time

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :created_at, :updated_at
 end

