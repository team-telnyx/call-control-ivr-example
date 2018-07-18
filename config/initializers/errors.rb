require "net/http"
require "net/smtp"

HTTP_ERRORS = [
  EOFError,
  Errno::ECONNRESET,
  Errno::EINVAL,
  Net::HTTPBadResponse,
  Net::HTTPHeaderSyntaxError,
  Net::ProtocolError,
  Timeout::Error,
]

SMTP_SERVER_ERRORS = [
  IOError,
  Net::SMTPAuthenticationError,
  Net::SMTPServerBusy,
  Net::SMTPUnknownError,
  Timeout::Error,
]

SMTP_CLIENT_ERRORS = [
  Net::SMTPFatalError,
  Net::SMTPSyntaxError,
]

SMTP_ERRORS = SMTP_SERVER_ERRORS + SMTP_CLIENT_ERRORS
