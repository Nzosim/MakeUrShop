import { getDB } from '../../../utils/db.js';

export default defineEventHandler(async (event) => {
    const connection = await getDB();
    try {
        const [rows] = await connection.execute(`
            SELECT 
                LEFT(a.zip_code, 2) as department,
                COUNT(o.id) as total_orders,
                SUM(o.total) as total_revenue
            FROM orders o
            JOIN address a ON o.shipping_address_id = a.id
            WHERE o.statut != 'annulee'
            GROUP BY LEFT(a.zip_code, 2)
            ORDER BY total_revenue DESC
        `);

        return Array.isArray(rows)
            ? rows.map((r) => ({
                  department: r.department || 'Inconnu',
                  orders: Number(r.total_orders || 0),
                  revenue: Number(r.total_revenue || 0),
              }))
            : [];
    } catch (error) {
        console.error('Erreur API Geo:', error);
        throw createError({ statusCode: 500, statusMessage: 'Erreur SQL Géographique.' });
    }
});
