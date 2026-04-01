import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    const db = getDB();

    const request = `
        INSERT INTO brand (id, name) VALUES (DEFAULT, ?)
    `;

    const [rows] = await db.query(request, [brandName]);

    console.log(rows);
    return rows;
});
