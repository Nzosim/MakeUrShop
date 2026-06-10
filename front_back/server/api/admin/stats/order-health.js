import { getDB } from '../../../utils/db.js';

export default defineEventHandler(async (event) => {
    const connection = await getDB();
    try {
        const [rows] = await connection.execute(`
            SELECT 
                statut,
                COUNT(id) as count
            FROM orders
            GROUP BY statut
        `);

        return Array.isArray(rows)
            ? rows.map((r) => ({
                  status: r.statut,
                  count: Number(r.count || 0),
              }))
            : [];
    } catch (error) {
        console.error('Erreur API Order Health:', error);
        throw createError({ statusCode: 500, statusMessage: 'Erreur SQL Santé Commandes.' });
    }
});
