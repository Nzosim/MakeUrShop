import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    const db = getDB();
    const { id } = await readBody(event);

    const checkRequest = `
        SELECT id, name FROM product WHERE brand_id = ?
    `;

    const [products] = await db.query(checkRequest, [id]);

    if (products.length > 0) {
        const productNames = products.map((p) => p.name).join(', ');
        throw createError({
            statusCode: 409,
            message: `Impossible de supprimer : ${products.length} produit(s) utilisent cette marque (${productNames}).`,
        });
    }

    const request = `
        DELETE FROM brand WHERE id = ?
    `;

    const [rows] = await db.query(request, [id]);

    console.log(rows);
    return rows;
});
