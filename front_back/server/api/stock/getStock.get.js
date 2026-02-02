import { getDB } from '../../utils/db.js';

export default defineEventHandler(async () => {
    const db = getDB();

    const request = 'SELECT * FROM stock';

    const [rows] = await db.query(request);

    console.log(rows);
    return rows;



});