import { transporter } from '../../utils/mailer';

export default defineEventHandler(async (event) => {
    const { email } = await readBody(event);

    if (!email) {
        throw createError({ statusCode: 400, statusMessage: 'Email requis' });
    }

    try {
        await transporter.sendMail({
            from: `"MakeUrShop" <${process.env.MAIL_USER}>`,
            to: email,
            subject: 'Confirmation commande - MakeUrShop',
            html: `
                <h2>Confirmation commande</h2>
                <p>Merci pour votre commande sur MakeUrShop.</p>
            `,
        });

        return {
            message: 'Email envoyé (si existant)',
            debug: process.dev ? { userFound: true, mailSent: true } : undefined,
        };
    } catch (error) {
        console.error('Erreur envoi email confirmation:', error);
        throw createError({
            statusCode: 500,
            statusMessage: `Erreur lors de l'envoi de l'email: ${error.message}`,
        });
    }
});
