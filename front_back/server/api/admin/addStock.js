import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    const db = getDB();
    const body = await readBody(event);

    for (const variant of body.variants) {
        await db.query(`INSERT INTO stock (product_id, size, stock_number) VALUES (?, ?, ?)`, [body.product_id, variant.size, variant.stock]);
    }

    return { success: true };
});
