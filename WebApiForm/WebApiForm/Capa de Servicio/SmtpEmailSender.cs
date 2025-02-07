using System.Net.Mail;
using System.Net;
using WebApiForm.Interfaces;

namespace WebApiForm.Capa_de_Servicio
{
    public class SmtpEmailSender : IEmailSender
    {
        private readonly IConfiguration _configuration;

        public SmtpEmailSender(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task SendPasswordResetEmailAsync(string email, string token)
        {
            // Asegúrate de que el valor del puerto no sea nulo antes de intentar analizarlo
            string portValue = _configuration["Smtp:Port"];
            if (string.IsNullOrEmpty(portValue))
            {
                throw new ArgumentNullException(nameof(portValue), "El valor del puerto SMTP no puede ser nulo");
            }

            var smtpClient = new SmtpClient(_configuration["Smtp:Host"])
            {
                Port = int.Parse(_configuration["Smtp:Host"]),
                Credentials = new NetworkCredential(_configuration["Smtp:Username"], _configuration["Smtp:Password"]),
                EnableSsl = bool.Parse(_configuration["Smtp:EnableSsl"])
            };

            var from = new MailAddress(_configuration["Smtp:From"], "Encuesta OPRET");
            var to = new MailAddress(email);
            var mailMessage = new MailMessage
            {
                From = from,
                Subject = "Recuperación de Contraseña",
                Body = $"Usa este token para resetear tu contraseña: {token}",
                IsBodyHtml = true,
            };

            mailMessage.To.Add(to);

            await smtpClient.SendMailAsync(mailMessage);
        }
    }
}