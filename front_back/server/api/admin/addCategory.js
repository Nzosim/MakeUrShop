import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    const db = getDB();

    const request = `
        INSERT INTO category (id, name, category_parent_id) VALUES (DEFAULT, ?, ?)
    `;

    const [rows] = await db.query(request, [name, category_parent_id ?? null]);

    console.log(rows);
    return rows;
});
