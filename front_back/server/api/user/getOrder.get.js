import { getDB } from '../../utils/db.js';
import { getQuery } from 'h3';

export default defineEventHandler(async (event) => {
    const db = await getDB();

    const query = getQuery(event);
    const userId = query.id;
    if (!userId) return [];

    const request = `
        SELECT 
            o.id AS order_id,
            o.order_date,
            o.statut,
            o.total,
            o.shipping_address_id,
            o.billing_address_id,
            ol.id AS order_item_id,
            ol.product_id,
            ol.quantity,
            ol.unit_price,
            p.name AS product_name,
            i.url AS image
        FROM orders o
        LEFT JOIN order_list ol ON o.id = ol.order_id
        LEFT JOIN product p ON ol.product_id = p.id
        LEFT JOIN image i ON p.id = i.product_id
        WHERE o.user_id = ?
        ORDER BY o.id, ol.id
    `;

    const [rows] = await db.query(request, [userId]);

    // Regroupe les items par commande
    const ordersMap = {};
    for (const row of rows) {
        if (!ordersMap[row.order_id]) {
            ordersMap[row.order_id] = {
                id: row.order_id,
                order_date: row.order_date,
                statut: row.statut,
                total: row.total,
                shipping_address_id: row.shipping_address_id,
                billing_address_id: row.billing_address_id,
                items: [],
            };
        }

        if (row.order_item_id) {
            ordersMap[row.order_id].items.push({
                id: row.order_item_id,
                product_id: row.product_id,
                quantity: row.quantity,
                unit_price: row.unit_price,
                name: row.product_name,
                image: row.image,
            });
        }
    }

    const orders = Object.values(ordersMap);

    console.log(orders);
    return orders;
});
