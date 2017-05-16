class Msresult < ActiveRecord::Base
	include ActiveModel::Model
	belongs_to :material
	belongs_to :protein

	attr_accessor :check
	
end
