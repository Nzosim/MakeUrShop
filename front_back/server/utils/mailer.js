import nodemailer from 'nodemailer';

const mailUser = (process.env.MAIL_USER || '').trim();
const mailPass = (process.env.MAIL_PASS || '').replace(/\s+/g, '');
const mailFrom = `"MakeUrShop" <${mailUser}>`;

export const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: mailUser,
        pass: mailPass,
    },
});

export function getMailFrom() {
    return mailFrom;
}

export function buildMailLayout({ title, heading, introduction, content, buttonLabel, buttonUrl, footerText }) {
    const currentYear = new Date().getFullYear();
    const documentTitle = title || heading || 'MakeUrShop';

    return `
    <!DOCTYPE html>
    <html lang="fr">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>${documentTitle}</title>
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
            <div class="header">MakeUrShop</div>
            <div class="content">
                <h2>${heading}</h2>
                ${introduction ? `<p>${introduction}</p>` : ''}
                ${content || ''}
                ${buttonLabel && buttonUrl ? `<p style="text-align:center;"><a href="${buttonUrl}" class="btn">${buttonLabel}</a></p>` : ''}
            </div>
            <div class="footer">
                ${footerText || `&copy; ${currentYear} MakeUrShop. Tous droits réservés.`}
            </div>
        </div>
    </body>
    </html>
    `;
}

export async function sendProjectMail({ to, subject, html }) {
    return transporter.sendMail({
        from: getMailFrom(),
        to,
        subject,
        html,
    });
}

export function buildPasswordResetMail(resetLink) {
    return buildMailLayout({
        title: 'Réinitialisation du mot de passe - MakeUrShop',
        heading: 'Réinitialisation du mot de passe',
        introduction: 'Nous avons reçu une demande de réinitialisation de votre mot de passe.',
        content: `
            <p>Utilisez le bouton ci-dessous pour créer un nouveau mot de passe.</p>
            <p>Si le bouton ne fonctionne pas, copiez-collez ce lien dans votre navigateur :</p>
            <p class="token-link">${resetLink}</p>
            <p>Ce lien est valide pendant 30 minutes.</p>
            <p>Si vous n'avez pas demandé de réinitialisation, ignorez ce message.</p>
        `,
        buttonLabel: 'Réinitialiser mon mot de passe',
        buttonUrl: resetLink,
    });
}

export function buildOrderConfirmationMail() {
    return buildMailLayout({
        title: 'Confirmation de commande - MakeUrShop',
        heading: 'Confirmation de commande',
        introduction: 'Merci pour votre commande sur MakeUrShop.',
        content: '<p>Nous préparons votre commande et vous tiendrons informé de son avancement.</p>',
    });
}

export function buildOrderStatusMail({ orderId, previousStatus, nextStatus, firstName }) {
    const safeName = firstName || 'client';

    return buildMailLayout({
        title: `Mise à jour de commande #${orderId} - MakeUrShop`,
        heading: 'Mise à jour de votre commande',
        introduction: `Bonjour ${safeName},`,
        content: `
            <p>Le statut de votre commande <strong>#${orderId}</strong> a été mis à jour.</p>
            <p>Ancien statut : <strong>${previousStatus}</strong></p>
            <p>Nouveau statut : <strong>${nextStatus}</strong></p>
            <p>Merci de votre confiance.</p>
        `,
    });
}
