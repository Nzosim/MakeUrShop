import { transporter } from '../../utils/mailer';
import { randomBytes } from 'crypto';
import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    const { email } = await readBody(event);
    const db = getDB();

    if (!email) {
        throw createError({ statusCode: 400, statusMessage: 'Email requis' });
    }

    const [users] = await db.execute('SELECT id FROM user WHERE email = ?', [email]);

    if (users.length === 0) {
        return {
            message: 'Email envoyé (si existant)',
            debug: process.dev ? { userFound: false, mailSent: false } : undefined,
        };
    }

    const user = users[0];

    const token = randomBytes(32).toString('hex');
    const expiry = new Date(Date.now() + 1000 * 60 * 30);

    await db.execute('UPDATE user SET reset_token = ?, reset_token_expiry = ? WHERE id = ?', [token, expiry, user.id]);

    const requestUrl = getRequestURL(event);
    const resetLink = `${requestUrl.origin}/User/Reset-password?token=${token}`;

    try {
        await transporter.sendMail({
            from: `"MakeUrShop" <${process.env.MAIL_USER}>`,
            to: email,
            subject: 'Réinitialisation du mot de passe',
            html: `
  <!DOCTYPE html>
  <html lang="fr">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <style>
      body {
        font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
        background-color: #f4f6f8;
        margin: 0;
        padding: 0;
      }
      .container {
        max-width: 600px;
        margin: 40px auto;
        background-color: #ffffff;
        border-radius: 12px;
        box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        overflow: hidden;
      }
      .header {
        background: linear-gradient(90deg, #4e54c8, #8f94fb);
        color: #fff;
        padding: 30px;
        text-align: center;
        font-size: 24px;
        font-weight: bold;
      }
      .content {
        padding: 30px;
        color: #333;
        font-size: 16px;
        line-height: 1.5;
      }
      .content p {
        margin-bottom: 20px;
      }
      .btn {
        display: inline-block;
        background-color: #4e54c8;
        color: #fff;
        text-decoration: none;
        font-weight: 600;
        padding: 14px 25px;
        border-radius: 8px;
        transition: background 0.3s ease;
      }
      .btn:hover {
        background-color: #3b3fc1;
      }
      .footer {
        text-align: center;
        padding: 20px;
        font-size: 12px;
        color: #999;
      }
      .token-link {
        word-break: break-all;
        color: #4e54c8;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="header">
        MakeUrShop
      </div>
      <div class="content">
        <h2>Réinitialisation du mot de passe</h2>
        <p>Bonjour,</p>
        <p>Nous avons reçu une demande de réinitialisation de votre mot de passe. Cliquez sur le bouton ci-dessous pour créer un nouveau mot de passe :</p>
        <p style="text-align:center;">
          <a href="${resetLink}" class="btn">Réinitialiser mon mot de passe</a>
        </p>
        <p>Si le bouton ne fonctionne pas, copiez-collez ce lien dans votre navigateur :</p>
        <p class="token-link">${resetLink}</p>
        <p>Ce lien est valide pendant 30 minutes.</p>
        <p>Si vous n'avez pas demandé de réinitialisation, ignorez ce message.</p>
      </div>
      <div class="footer">
        &copy; ${new Date().getFullYear()} MakeUrShop. Tous droits réservés.
      </div>
    </div>
  </body>
  </html>
  `,
        });
    } catch (error) {
        console.error('Erreur envoi email reset password:', error);

        return {
            message: "Impossible d'envoyer l'email pour le moment.",
            resetLink: process.dev ? resetLink : undefined,
            debug: process.dev ? { userFound: true, mailSent: false } : undefined,
        };
    }
});
