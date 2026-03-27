import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    const db = getDB();

    const query = getQuery(event);
    const userId = query.id;

    const request = `
    SELECT DISTINCT *
    FROM orders o
    WHERE o.user_id = ?
`;

    const [rows] = await db.query(request, [userId]);
    console.log(rows);
    return rows;
});
