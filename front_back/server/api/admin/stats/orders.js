import { getDB } from '../../../utils/db.js';

export default defineEventHandler(async (event) => {
    const connection = await getDB();

    // Récupération de la granularité (day, week, month, year). Par défaut : day
    const query = getQuery(event);
    const groupType = query.group || 'day';

    let dateFormat = '%Y-%m-%d'; // Par défaut : Journalier
    if (groupType === 'week') dateFormat = '%Y-W%u'; // Année-Semaine (ex: 2026-W12)
    if (groupType === 'month') dateFormat = '%Y-%m'; // Année-Mois (ex: 2026-03)
    if (groupType === 'year') dateFormat = '%Y'; // Année (ex: 2026)

    try {
        const [rows] = await connection.execute(`
            SELECT 
                DATE_FORMAT(order_date, '${dateFormat}') as period,
                COUNT(id) as total_orders,
                SUM(total) as total_revenue
            FROM orders
            WHERE statut != 'annulee'
            GROUP BY DATE_FORMAT(order_date, '${dateFormat}')
            ORDER BY period ASC
        `);

        if (!Array.isArray(rows)) return [];

        return rows.map((row) => ({
            period: row.period,
            total_orders: Number(row.total_orders || 0),
            total_revenue: Number(row.total_revenue || 0),
        }));
    } catch (error) {
        console.error('Erreur SQL détaillée :', error);
        throw createError({
            statusCode: 500,
            statusMessage: 'Erreur lors de la récupération des statistiques.',
        });
    }
});
