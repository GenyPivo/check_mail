class MailRequest
  include ActiveModel::Validations

  attr_accessor :first_name, :last_name, :company_title,
                :page, :per_page

  validates_presence_of :first_name, :last_name, :company_title
  validates :per_page, numericality: { only_integer: true }, if: 'per_page.present?'
  validates :page, numericality: { only_integer: true }, if: 'page.present?'

  def initialize(params)
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @company_title = params[:company_title]
    @page = params[:page]
    @per_page = params[:per_page]
  end
end
