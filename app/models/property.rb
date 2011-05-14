class Property
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Document::Base

  field :name
  field :uri
  field :created_from
  field :default
  field :values, type: Array, default: []

  attr_accessible :name, :default, :values

  validates :name, presence: true
  validates :uri, presence: true, url: true
  validates :created_from, presence: true, url: true
end
