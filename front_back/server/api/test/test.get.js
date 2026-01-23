import { getDB } from '../../utils/db.js';

export default defineEventHandler(async () => {
    const db = getDB();

    const [rows] = await db.query('SELECT id, nom FROM Test');

    console.log(rows);
    return rows;
});
