class CompaniesController < ApplicationController
	before_action :set_company, except: [:index, :create, :new]
	before_action :validate_email, only: [:create, :update]

	def index
		@companies = Company.all.active
	end

	def new
		@company = Company.new
	end

	def show
	end

	def destroy
		@company.update_attributes!(:status => Company::Status::DELETED)
		redirect_to companies_path, notice: "Company Successfully Deleted"
	end

	def create
		_params = company_params.merge!(:status => Company::Status::ACTIVE)
		@company = Company.new(_params)
		if !@error.present? && @company.save!
			redirect_to companies_path, notice: "Saved"
		else
			render :new
		end
	end

	def edit
	end

	def update
		if !@error.present? && @company.update!(company_params)
			redirect_to companies_path, notice: "Changes Saved"
		else
			render :edit
		end
	end

	private

	def company_params
		_params = params.require(:company).permit(
			:name,
			:legal_name,
			:description,
			:zip_code,
			:phone,
			:email,
			:owner_id,
		)
		zip_info = ZipCodes.identify(_params[:zip_code])
		if zip_info
			_params.merge!(:state => zip_info[:state_name], :city => zip_info[:city])
		end
		_params
	end

	def set_company
		@company = Company.find(params[:id])
	end

	def validate_email
		email = params[:company][:email]
		if email.present? && !email.index(/@getmainstreet.com$/)
			@error = "Please enter a '@getmainstreet.com' domain email only."
		end
	end
end
