import { getDB } from '../../utils/db.js';

export default defineEventHandler(async () => {
    const db = getDB();
    const [rows] = await db.query('SELECT url FROM `image` ');

    console.log(rows);
    return rows;



});