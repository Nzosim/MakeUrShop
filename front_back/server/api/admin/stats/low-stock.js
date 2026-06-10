import { getDB } from '../../../utils/db.js';

export default defineEventHandler(async (event) => {
    const connection = await getDB();
    try {
        const [rows] = await connection.execute(`
            SELECT 
                p.name as product_name,
                s.size,
                s.stock_number
            FROM stock s
            JOIN product p ON s.product_id = p.id
            WHERE s.stock_number <= 5
            ORDER BY s.stock_number ASC
            LIMIT 10
        `);
        return Array.isArray(rows)
            ? rows.map((r) => ({
                  product: r.product_name,
                  size: r.size,
                  stock: Number(r.stock_number),
              }))
            : [];
    } catch (error) {
        console.error('Erreur Alertes Stock:', error);
        throw createError({ statusCode: 500, statusMessage: 'Erreur SQL Alertes Stock.' });
    }
});
