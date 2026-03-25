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
      <h2>Mot de passe oublié</h2>
      <p>Cliquer sur le lien :</p>
      <a href="${resetLink}">${resetLink}</a>
    `,
        });

        return {
            message: 'Email envoyé (si existant)',
            debug: process.dev ? { userFound: true, mailSent: true } : undefined,
        };
    } catch (error) {
        console.error('Erreur envoi email reset password:', error);

        return {
            message: "Impossible d'envoyer l'email pour le moment.",
            resetLink: process.dev ? resetLink : undefined,
            debug: process.dev ? { userFound: true, mailSent: false } : undefined,
        };
    }
});
