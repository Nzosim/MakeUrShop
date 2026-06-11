import { getDB } from '../../utils/db.js';
import { buildOrderStatusMail, sendProjectMail } from '../../utils/mailer.js';

export default defineEventHandler(async (event) => {
    const body = await readBody(event);
    const { orderId, action } = body;

    if (!orderId || !action) {
        setResponseStatus(event, 400);
        return { error: 'orderId et action ("advance", "regress", "cancel") sont requis' };
    }

    try {
        const db = await getDB();

        const requestGetStatus = `
            SELECT o.statut, u.email, u.firstname
            FROM orders o
            LEFT JOIN user u ON u.id = o.user_id
            WHERE o.id = ?
        `;
        const [orders] = await db.query(requestGetStatus, [orderId]);

        if (orders.length === 0) {
            setResponseStatus(event, 404);
            return { error: 'Commande non trouvée' };
        }

        const currentStatus = orders[0].statut;
        const customerEmail = orders[0].email;
        const customerFirstName = orders[0].firstname;

        const statusTransitions = {
            advance: {
                en_attente: 'payee',
                payee: 'expediee',
                expediee: 'livree',
            },
            regress: {
                payee: 'en_attente',
                expediee: 'payee',
                livree: 'expediee',
            },
        };

        let nextStatus = null;

        if (action === 'cancel') {
            if (currentStatus === 'livree' || currentStatus === 'annulee') {
                setResponseStatus(event, 400);
                return { error: "Impossible d'annuler une commande livrée ou déjà annulée." };
            }
            nextStatus = 'annulee';
        } else if (action === 'advance') {
            nextStatus = statusTransitions.advance[currentStatus];
            if (!nextStatus) {
                setResponseStatus(event, 400);
                return { error: 'Cette commande a déjà atteint le statut final ou ne peut pas avancer.' };
            }
        } else if (action === 'regress') {
            nextStatus = statusTransitions.regress[currentStatus];
            if (!nextStatus) {
                setResponseStatus(event, 400);
                return { error: 'Cette commande est déjà au statut initial ou ne peut pas reculer.' };
            }
        } else {
            setResponseStatus(event, 400);
            return { error: 'Action invalide.' };
        }

        // MAJ statut
        const requestUpdateStatus = 'UPDATE orders SET statut = ? WHERE id = ?';
        await db.query(requestUpdateStatus, [nextStatus, orderId]);

        let mailSent = false;

        if (customerEmail) {
            try {
                await sendProjectMail({
                    to: customerEmail,
                    subject: `Mise a jour de votre commande #${orderId} - MakeUrShop`,
                    html: buildOrderStatusMail({
                        orderId,
                        previousStatus: currentStatus,
                        nextStatus,
                        firstName: customerFirstName,
                    }),
                });
                mailSent = true;
            } catch (mailError) {
                console.error('Erreur envoi email statut commande:', mailError);
            }
        }

        return {
            success: true,
            message: `Commande mise à jour avec succès vers : ${nextStatus}`,
            orderId,
            newStatus: nextStatus,
            mailSent,
        };
    } catch (error) {
        console.error('Erreur lors de la mise à jour du statut:', error);
        setResponseStatus(event, 500);
        return { error: 'Erreur lors de la mise à jour du statut' };
    }
});
