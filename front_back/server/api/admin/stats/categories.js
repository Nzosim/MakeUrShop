import { getDB } from '../../../utils/db.js';

export default defineEventHandler(async (event) => {
    const connection = await getDB();
    try {
        const [rows] = await connection.execute(`
            SELECT 
                COALESCE(parent.name, c.name) as category_name,
                SUM(ol.quantity * ol.unit_price) as total_revenue
            FROM order_list ol
            JOIN product p ON ol.product_id = p.id
            JOIN category c ON p.category_id = c.id
            LEFT JOIN category parent ON c.category_parent_id = parent.id
            JOIN orders o ON ol.order_id = o.id
            WHERE o.statut != 'annulee'
            GROUP BY COALESCE(parent.name, c.name)
            ORDER BY total_revenue DESC
        `);

        return Array.isArray(rows)
            ? rows.map((r) => ({
                  name: r.category_name,
                  revenue: Number(r.total_revenue || 0),
              }))
            : [];
    } catch (error) {
        console.error('Erreur API Categories:', error);
        throw createError({ statusCode: 500, statusMessage: 'Erreur SQL Catégories.' });
    }
});
