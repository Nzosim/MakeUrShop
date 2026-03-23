import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    const db = getDB();

    const request = `
        SELECT id, name, category_parent_id
        FROM category
        ORDER BY name ASC
    `;

    const [rows] = await db.query(request);

    console.log(rows);
    return rows;
});
