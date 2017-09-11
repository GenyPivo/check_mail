class Api::V1::CheckMailController < ApplicationController
  before_action :init_check_mail_services, only: :index

  def index
    render json: @available_mailboxes
  end

  private

  def init_check_mail_services
    mail_generator = MailGeneratorService.new(params[:first_name], params[:last_name])
    mx_checker = MxCheckerService.new
    mx_records = mx_checker.collect_mx_by_company_title(params[:company_title])
    generated_emails = mail_generator.generate_mail_addresses(mx_records.keys)
    @available_mailboxes = CheckMailByMxService.new(generated_emails, mx_records).available
  end
end
