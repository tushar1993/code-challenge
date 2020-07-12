class AddStateStatusCompanies < ActiveRecord::Migration[6.0]
	def change
		add_column :companies, :status, :integer
		add_column :companies, :state, :string
		add_column :companies, :city, :string
	end
end
