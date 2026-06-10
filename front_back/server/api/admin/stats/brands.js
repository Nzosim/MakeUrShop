import { getDB } from '../../../utils/db.js';

export default defineEventHandler(async (event) => {
    const connection = await getDB();
    try {
        const [rows] = await connection.execute(`
            SELECT 
                b.name as brand_name,
                SUM(ol.quantity) as total_units_sold,
                SUM(ol.quantity * ol.unit_price) as total_revenue
            FROM order_list ol
            JOIN product p ON ol.product_id = p.id
            JOIN brand b ON p.brand_id = b.id
            JOIN orders o ON ol.order_id = o.id
            WHERE o.statut != 'annulee'
            GROUP BY b.id, b.name
            ORDER BY total_revenue DESC
            LIMIT 5
        `);
        return Array.isArray(rows)
            ? rows.map((r) => ({
                  name: r.brand_name,
                  units: Number(r.total_units_sold || 0),
                  revenue: Number(r.total_revenue || 0),
              }))
            : [];
    } catch (error) {
        console.error('Erreur Top Marques:', error);
        throw createError({ statusCode: 500, statusMessage: 'Erreur SQL Top Marques.' });
    }
});
