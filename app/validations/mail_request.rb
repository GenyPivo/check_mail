class MailRequest
  include ActiveModel::Validations

  attr_accessor :first_name, :last_name, :company_title

  validates_presence_of :first_name, :last_name, :company_title

  def initialize(params)
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @company_title = params[:company_title]
  end
end
