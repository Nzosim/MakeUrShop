import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    try {
        const body = await readBody(event);
        console.log('API updateStock reçu:', body);

        const { stock_id, stock_number } = body;

        if (!stock_id || stock_number === undefined || stock_number < 0) {
            throw createError({ statusCode: 400, statusMessage: 'Paramètres invalides' });
        }

        const db = getDB();
        const [result] = await db.query('UPDATE stock SET stock_number = ? WHERE id = ?', [stock_number, stock_id]);
        console.log('Résultat SQL:', result);

        return { success: true, affectedRows: result.affectedRows };
    } catch (error) {
        console.error(error);
        throw createError({ statusCode: 500, statusMessage: 'Erreur base de données : ' + error.message });
    }
});
