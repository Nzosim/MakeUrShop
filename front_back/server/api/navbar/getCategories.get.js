import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    const db = getDB();

    const request = `
        SELECT DISTINCT c.id, c.name
        FROM category c
        WHERE c.category_parent_id IS NULL
    `;

    const [rows] = await db.query(request);

    console.log(rows);
    return rows;
});
