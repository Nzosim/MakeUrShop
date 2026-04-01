import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    const body = await readBody(event);
    const { orderId } = body;

    if (!orderId) {
        setResponseStatus(event, 400);
        return { error: 'orderId est requis' };
    }

    try {
        const db = await getDB();

        const requestGetStatus = 'SELECT statut FROM orders WHERE id = ?';
        const [orders] = await db.query(requestGetStatus, [orderId]);

        if (orders.length === 0) {
            setResponseStatus(event, 404);
            return { error: 'Commande non trouvée' };
        }

        const currentStatus = orders[0].statut;

        const statusProgression = {
            en_attente: 'payee',
            payee: 'expediee',
            expediee: 'livree',
            livree: 'livree',
            annulee: 'annulee',
        };

        const nextStatus = statusProgression[currentStatus];

        if (!nextStatus) {
            setResponseStatus(event, 400);
            return { error: 'Statut actuel invalide' };
        }

        if (nextStatus === currentStatus) {
            setResponseStatus(event, 400);
            return { error: 'Cette commande ne peut pas être mise à jour (statut final atteint)' };
        }

        // MAJ statut
        const requestUpdateStatus = 'UPDATE orders SET statut = ? WHERE id = ?';
        await db.query(requestUpdateStatus, [nextStatus, orderId]);

        return {
            success: true,
            message: `Commande passée de ${currentStatus} à ${nextStatus}`,
            orderId,
            newStatus: nextStatus,
        };
    } catch (error) {
        console.error('Erreur lors de la mise à jour du statut:', error);
        setResponseStatus(event, 500);
        return { error: 'Erreur lors de la mise à jour du statut' };
    }
});
