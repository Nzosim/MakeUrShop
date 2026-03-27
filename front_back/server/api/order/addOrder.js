import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    const db = getDB();
    const query = getQuery(event);
    const body = await readBody(event);

    const userId = Number(query.id);
    const statut = body?.statut || 'en_attente';
    const total = Number(body?.total);
    const items = Array.isArray(body?.items) ? body.items : [];
    const shippingAddress = body?.shippingAddress;
    const billingAddress = body?.billingAddress;

    if (!Number.isFinite(total) || total < 0) {
        throw createError({ statusCode: 400, statusMessage: 'Total de commande invalide' });
    } else if (!items.length) {
        throw createError({ statusCode: 400, statusMessage: 'Le panier est vide' });
    } else if (!shippingAddress || !billingAddress) {
        throw createError({ statusCode: 400, statusMessage: 'Adresses de livraison/facturation manquantes' });
    }

    for (const addr of [shippingAddress, billingAddress]) {
        if (!addr.address || !addr.city || !addr.zip_code || !addr.country) {
            throw createError({ statusCode: 400, statusMessage: 'Adresse incomplète' });
        }
    }

    const connection = await db.getConnection();

    try {
        await connection.beginTransaction();

        const [userRows] = await connection.execute('SELECT id FROM user WHERE id = ?', [userId]);
        if (!userRows.length) {
            throw createError({ statusCode: 404, statusMessage: 'Utilisateur introuvable' });
        }

        const [shippingResult] = await connection.execute(
            `INSERT INTO address (user_id, type, address, city, zip_code, country)
             VALUES (?, 'livraison', ?, ?, ?, ?)`,
            [userId, shippingAddress.address, shippingAddress.city, shippingAddress.zip_code, shippingAddress.country]
        );

        const [billingResult] = await connection.execute(
            `INSERT INTO address (user_id, type, address, city, zip_code, country)
             VALUES (?, 'facturation', ?, ?, ?, ?)`,
            [userId, billingAddress.address, billingAddress.city, billingAddress.zip_code, billingAddress.country]
        );

        const [orderResult] = await connection.execute(
            `INSERT INTO orders (user_id, shipping_address_id, billing_address_id, statut, total)
             VALUES (?, ?, ?, ?, ?)`,
            [userId, shippingResult.insertId, billingResult.insertId, statut, total]
        );

        const orderId = orderResult.insertId;

        for (const item of items) {
            await connection.execute(
                `INSERT INTO order_list (order_id, product_id, quantity, unit_price)
                 VALUES (?, ?, ?, ?)`,
                [orderId, item.productId, item.quantity, item.unitPrice]
            );
        }

        await connection.commit();

        return {
            success: true,
            orderId,
            message: 'Commande créée avec succès',
        };
    } catch (error) {
        await connection.rollback();
        console.error('Erreur addOrder:', error);

        throw createError({
            statusCode: 500,
            statusMessage: 'Erreur lors de la création de la commande',
        });
    } finally {
        connection.release();
    }
});
