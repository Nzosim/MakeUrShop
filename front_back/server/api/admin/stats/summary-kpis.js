import { getDB } from '../../../utils/db.js';

export default defineEventHandler(async (event) => {
    const connection = await getDB();
    try {
        const [rows] = await connection.execute(`
            SELECT 
                COUNT(DISTINCT user_id) as total_customers,
                COUNT(id) as total_orders,
                AVG(total) as avg_order_value
            FROM orders
            WHERE statut != 'annulee'
        `);

        const data = rows[0];
        const customers = Number(data?.total_customers || 0);
        const orders = Number(data?.total_orders || 0);
        const avgOrderValue = Number(data?.avg_order_value || 0);

        // Calcul du nombre de commandes moyennes par client
        const avgOrdersPerCustomer = customers > 0 ? orders / customers : 0;

        return {
            total_customers: customers,
            avg_order_value: avgOrderValue,
            avg_orders_per_customer: avgOrdersPerCustomer,
        };
    } catch (error) {
        console.error('Erreur API Summary KPIs:', error);
        throw createError({ statusCode: 500, statusMessage: 'Erreur SQL KPIs Globaux.' });
    }
});
