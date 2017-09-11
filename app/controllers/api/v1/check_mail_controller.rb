class Api::V1::CheckMailController < ApplicationController
  before_action :validate_params, only: :index
  before_action :init_check_mail_services, only: :index

  def index
    render json: { status: :success, response: @available_mailboxes }
  end

  private

  def validate_params
    request = MailRequest.new(required_params)
    unless request.valid?
      render json: { status: :error, response: request.errors }
    end
  end

  def init_check_mail_services
    mail_generator = MailGeneratorService.new(required_params[:first_name],
                                              required_params[:last_name])
    mx_checker = MxCheckerService.new
    mx_records = mx_checker.collect_mx_by_company_title(required_params[:company_title])
    generated_emails = mail_generator.generate_mail_addresses(mx_records.keys)
    @available_mailboxes = CheckMailByMxService.new(generated_emails, mx_records).available
  end

  def required_params
    params.permit(:first_name, :last_name, :company_title)
  end
end
