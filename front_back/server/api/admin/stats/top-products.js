import { getDB } from '../../../utils/db.js';

export default defineEventHandler(async (event) => {
    const connection = await getDB();
    try {
        const [rows] = await connection.execute(`
            SELECT 
                p.id,
                p.name,
                p.price,
                SUM(ol.quantity) as total_qty,
                SUM(ol.quantity * ol.unit_price) as total_revenue
            FROM order_list ol
            JOIN product p ON ol.product_id = p.id
            JOIN orders o ON ol.order_id = o.id
            WHERE o.statut != 'annulee'
            GROUP BY p.id, p.name, p.price
        `);

        return Array.isArray(rows)
            ? rows.map((r) => ({
                  id: r.id,
                  name: r.name,
                  quantity: Number(r.total_qty || 0),
                  revenue: Number(r.total_revenue || 0),
              }))
            : [];
    } catch (error) {
        console.error('Erreur API Top Products:', error);
        throw createError({ statusCode: 500, statusMessage: 'Erreur SQL Top Produits.' });
    }
});
