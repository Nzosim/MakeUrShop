import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    const db = getDB();

    const query = getQuery(event);
    const categoryId = query.id;

    const request = `
        SELECT DISTINCT p.id, p.name, p.description, p.price, p.actif, i.url
        FROM product p
        JOIN category c ON p.category_id = c.id
        JOIN image i ON p.id = i.product_id
        WHERE c.category_parent_id = ${categoryId}
    `;

    const [rows] = await db.query(request);

    console.log(rows);
    return rows;
});
