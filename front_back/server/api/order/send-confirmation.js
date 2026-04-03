import { buildOrderConfirmationMail, sendProjectMail } from '../../utils/mailer.js';

export default defineEventHandler(async (event) => {
    const { email } = await readBody(event);

    if (!email) {
        throw createError({ statusCode: 400, statusMessage: 'Email requis' });
    }

    try {
        await sendProjectMail({
            to: email,
            subject: 'Confirmation commande - MakeUrShop',
            html: buildOrderConfirmationMail(),
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
