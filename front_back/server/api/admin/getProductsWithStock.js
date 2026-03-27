import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    const db = getDB();

    const [rows] = await db.query(`
        SELECT 
            p.id AS product_id,
            p.name AS product_name,
            p.price,
            p.creation_date,
            p.image,
            s.id AS stock_id,
            s.size,
            s.stock_number
        FROM product p
        LEFT JOIN stock s ON s.product_id = p.id
        ORDER BY p.id DESC
    `);

    console.log('image exemple:', rows[0]?.image);
    console.log('type:', typeof rows[0]?.image);

    const serialized = rows.map((row) => ({
        ...row,
        image: row.image ? `data:image/jpeg;base64,${Buffer.from(row.image).toString('base64')}` : null,
    }));

    return serialized;
});
