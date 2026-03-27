import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    const db = getDB();
    const body = await readBody(event);

    const imageBuffer = body.image ? Buffer.from(body.image, 'base64') : null;

    const [rows] = await db.query(
        `INSERT INTO product (category_id, brand_id, name, description, price, sale_price, image, type, actif)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [body.category_id, body.brand_id, body.name, body.description, body.price, body.sale_price, imageBuffer || null, body.type, body.actif]
    );

    return { success: true, id: rows.insertId };
});
