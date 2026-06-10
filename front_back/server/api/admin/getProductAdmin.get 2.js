import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    try {
        const db = getDB();
        // On s'assure que les noms de colonnes correspondent bien au mapping JS
        const [rows] = await db.query(`
            SELECT 
                u.id as userId, u.firstname, u.lastname, u.email,
                o.id as orderId, o.statut, o.total, o.order_date,
                ol.quantity, ol.unit_price,
                p.name as product_name
            FROM user u
            INNER JOIN orders o ON u.id = o.user_id
            LEFT JOIN order_list ol ON o.id = ol.order_id
            LEFT JOIN product p ON ol.product_id = p.id
            ORDER BY o.order_date DESC
        `);

        const usersMap = new Map();

        rows.forEach((row) => {
            // Création de l'utilisateur s'il n'existe pas dans la Map
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

            // Si une commande existe pour cette ligne
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

                // Ajout du produit à la commande
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
        console.error(error); // Toujours loguer l'erreur pour débugger
        throw createError({
            statusCode: 500,
            statusMessage: 'Erreur base de données : ' + error.message,
        });
    }
});
