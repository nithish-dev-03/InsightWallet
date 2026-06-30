import nodemailer from 'nodemailer';
import env from '../config/env.js';

const transporter = nodemailer.createTransport({
  host: env.smtpHost,
  port: env.smtpPort,
  secure: env.smtpPort === 465,
  auth: {
    user: env.smtpUser,
    pass: env.smtpPass,
  },
});

const sendEmail = async ({ to, subject, html }) => {
  if (!env.smtpUser || !env.smtpPass) {
    console.warn('SMTP credentials not configured. Email not sent.');
    return;
  }

  const mailOptions = {
    from: `"InsightWallet" <${env.smtpUser}>`,
    to,
    subject,
    html,
  };

  await transporter.sendMail(mailOptions);
};

export default sendEmail;
