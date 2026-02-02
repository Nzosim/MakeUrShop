import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    const db = getDB();

    const query = getQuery(event);
    const userId = query.id;

    const request = `
        SELECT DISTINCT u.id, u.email, u.firstname, u.lastname, u.phone, u.role, u.address
        FROM user u
        WHERE u.id = ${userId}
    `;

    const [rows] = await db.query(request);

    console.log(rows);
    return rows;
});
