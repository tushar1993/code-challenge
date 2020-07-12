class Company < ApplicationRecord
  has_rich_text :description

	module Status
		ACTIVE  = 1
		DELETED = 2
	end

	scope :active, -> { where(status: Status::ACTIVE) }

	def update_state_and_city(zip_code)
		zip_info = ZipCodes.identify(zip_code)
		if zip_info
			self.update_attributes!(:state => zip_info[:state_name], :city => zip_info[:city])
		end
	end
end
