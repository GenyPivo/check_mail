class CheckMailByMxService
  EHLO_DOMAIN = 'mail.ru'.freeze
  MAIL_FROM = 'test121@mail.ru'.freeze
  SMTP_PORT = 25.freeze
  RCPT_ERROR_MESSAGES = [
      'The email account that you tried to reach does not exist',
      'Recipient address rejected',
      'No such recipient here'
  ].freeze

  def initialize(mails, mx_records)
    @mails = mails
    @mx_records = mx_records
  end

  def available
    @mails.map do |domain, mails|
      mx = @mx_records[domain]
      check_mail_batch(mails, mx)
    end.flatten
  end

  private

  def check_mail_batch(mails, mx)
    begin
      smtp = smtp_connect(mx)
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy,
        Net::SMTPSyntaxError,
        Net::SMTPUnknownError => e

      Rails.logger.info(e)
    end
    mails = mails.each_with_object(Array.new) do |mail, acc|
      begin
        smtp.rcptto(mail)
      rescue Net::SMTPFatalError => e
        case e.message
          when /#{RCPT_ERROR_MESSAGES.join('|')}/
            acc << mail
          when /REJECTED/
            acc << mail
            smtp = smtp_connect(mx)
          else
            Rails.logger.info(e)
        end
      end
    end
    smtp.finish
    mails
  end

  def smtp_connect(mx)
    smtp = Net::SMTP.start(mx, SMTP_PORT)
    smtp.ehlo(EHLO_DOMAIN)
    smtp.mailfrom(MAIL_FROM)
    smtp
  end
end
