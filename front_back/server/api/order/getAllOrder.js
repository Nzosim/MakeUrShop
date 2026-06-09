import { getDB } from '../../utils/db.js';
import { getQuery } from 'h3';

export default defineEventHandler(async (event) => {
    const db = await getDB();

    const query = getQuery(event);

    const request = `
        SELECT 
            o.id AS order_id,
            o.order_date,
            o.statut,
            o.total,
            o.user_id,
            o.shipping_address_id,
            o.billing_address_id,
            u.firstname AS user_firstname,
            u.lastname AS user_lastname,
            u.email AS user_email,
            u.phone AS user_phone,
            sa.address AS shipping_address,
            sa.city AS shipping_city,
            sa.zip_code AS shipping_zip_code,
            sa.country AS shipping_country,
            ol.id AS order_item_id,
            ol.product_id,
            ol.quantity,
            ol.unit_price,
            p.name AS product_name,
            i.url AS image
        FROM orders o
        LEFT JOIN user u ON o.user_id = u.id
        LEFT JOIN address sa ON o.shipping_address_id = sa.id
        LEFT JOIN order_list ol ON o.id = ol.order_id
        LEFT JOIN product p ON ol.product_id = p.id
        LEFT JOIN image i ON p.id = i.product_id
        ORDER BY o.id, ol.id
    `;

    const [rows] = await db.query(request);

    // Regroupe les items par commande
    const ordersMap = {};
    for (const row of rows) {
        if (!ordersMap[row.order_id]) {
            ordersMap[row.order_id] = {
                id: row.order_id,
                order_date: row.order_date,
                statut: row.statut,
                total: row.total,
                user_id: row.user_id,
                shipping_address_id: row.shipping_address_id,
                billing_address_id: row.billing_address_id,
                customer: {
                    firstname: row.user_firstname,
                    lastname: row.user_lastname,
                    email: row.user_email,
                    phone: row.user_phone,
                },
                shipping_address: {
                    address: row.shipping_address,
                    city: row.shipping_city,
                    zip_code: row.shipping_zip_code,
                    country: row.shipping_country,
                },
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
