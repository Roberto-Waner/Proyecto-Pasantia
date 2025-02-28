using System.Net.Mail;
using System.Net;
using WebApiForm.Interfaces;

namespace WebApiForm.Capa_de_Servicio
{
    public class SmtpEmailSender : IEmailSender
    {
        private readonly IConfiguration _config;

        public SmtpEmailSender(IConfiguration config)
        {
            _config = config;
        }

        public async Task SendEmail(string toEmail, string subject, string body)
        {
            var smtpSettings = _config.GetSection("Smtp"); //lee la configuración del SMTP desde appsettings.json
            //configura la dirección de correo del remitente (fromAddress) y del destinatario (toAddress).
            var fromAddress = new MailAddress(smtpSettings["FromEmail"], "No-Reply");
            var toAddress = new MailAddress(toEmail);
            string fromPassword = smtpSettings["Password"];

            //configura el cliente SMTP con los valores obtenidos de la configuración, como Host, Port, EnableSsl, etc.
            var smtp = new SmtpClient
            {
                Host = smtpSettings["Host"],
                Port = int.Parse(smtpSettings["Port"]),
                EnableSsl = bool.Parse(smtpSettings["EnableSsl"]),
                DeliveryMethod = SmtpDeliveryMethod.Network,
                UseDefaultCredentials = false,
                Credentials = new NetworkCredential(fromAddress.Address, fromPassword)
            };

            /*crea un mensaje de correo (MailMessage) con el asunto y cuerpo especificados,
                y se envía utilizando smtp.SendMailAsync(message).*/
            using (var message = new MailMessage(fromAddress, toAddress)
            {
                Subject = subject,
                Body = body,
            })
            {
                await smtp.SendMailAsync(message);
            }
        }
    }
}