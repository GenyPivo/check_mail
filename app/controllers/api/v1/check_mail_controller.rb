class Api::V1::CheckMailController < ApplicationController
  DEFAULT_PER_PAGE = 10.freeze

  before_action :validate_params, only: :index
  before_action :init_check_mail_services, only: :index

=begin
  @api {get} /check_mail Request available emails
  @apiName GetUser
  @apiGroup User
  @apiParam {String} first_name User first name.
  @apiParam {String} last_name User last name.
  @apiParam {String} company_title Company name.
  @apiParam {Integer} [page] Current page.
  @apiParam {Integer} [per_page] Data per page.


  @apiSuccess {String} status Request status.
  @apiSuccess {Array} response Mail list.

  @apiSuccessExample {json} Success-Response:
                   {
                     "status": "success"
                     "response": [
                        'mail1@mail.com', 'mail2@mail.com', 'mail3@mail.com'
                      ]
                   }
  @apiErrorExample {json} Error-Response:
       HTTP/1.1 422 Unprocessable entity
       {
         "status": "error",
         "response":{"company_title":["can't be blank"]}}
       }
=end

  def index
    @available_mailboxes = @available_mailboxes.paginate(per_page: params[:per_page] || DEFAULT_PER_PAGE,
                                                         page: params[:page])
    render json: { status: :success, response: @available_mailboxes }
  end

  private

  def validate_params
    @req = MailRequest.new(required_params)
    unless @req.valid?
      render json: { status: :error, response: @req.errors }, status: 422
    end
  end

  def init_check_mail_services
    mail_generator = MailGeneratorService.new(@req.first_name,
                                              @req.last_name)
    mx_checker = MxCheckerService.new
    mx_records = mx_checker.collect_mx_by_company_title(@req.company_title)
    generated_emails = mail_generator.generate_mail_addresses(mx_records.keys)
    @available_mailboxes = CheckMailByMxService.new(generated_emails, mx_records).available
  end

  def required_params
    params.permit(:first_name, :last_name, :company_title, :per_page, :page)
  end
end
