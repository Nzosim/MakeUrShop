import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    try {
        const [rows] = await getDB().query(`
    SELECT 
        u.id as userId, u.firstname, u.lastname, u.email,
        o.id as orderId, o.statut, o.total, o.order_date,
        ol.quantity, ol.unit_price,
        p.name as product_name,
        -- On récupère la date max de commande par utilisateur pour le tri global
        MAX(o.order_date) OVER(PARTITION BY u.id) as latest_user_order
    FROM user u
    LEFT JOIN orders o ON u.id = o.user_id
    LEFT JOIN order_list ol ON o.id = ol.order_id
    LEFT JOIN product p ON ol.product_id = p.id
    ORDER BY latest_user_order DESC, u.id DESC, o.order_date DESC
`);

        const usersMap = new Map();

        rows.forEach((row) => {
            if (!usersMap.has(row.userId)) {
                usersMap.set(row.userId, {
                    id: row.userId,
                    firstname: row.firstname,
                    lastname: row.lastname,
                    email: row.email,
                    orders: [],
                });
            }

            const user = usersMap.get(row.userId);

            if (row.orderId) {
                let order = user.orders.find((o) => o.id === row.orderId);
                if (!order) {
                    order = {
                        id: row.orderId,
                        statut: row.statut,
                        total: row.total,
                        order_date: row.order_date,
                        items: [],
                    };
                    user.orders.push(order);
                }

                if (row.product_name) {
                    order.items.push({
                        name: row.product_name,
                        quantity: row.quantity,
                        unit_price: row.unit_price,
                    });
                }
            }
        });

        return Array.from(usersMap.values());
    } catch (error) {
        throw createError({
            statusCode: 500,
            statusMessage: 'Erreur lors de la récupération des données.',
        });
    }
});
