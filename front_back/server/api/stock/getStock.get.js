import { getDB } from '../../utils/db.js';

export default defineEventHandler(async () => {
    const db = getDB();

    const request = `
    SELECT p.name AS product_name,
           s.stock_number
    FROM stock s
    JOIN product p ON s.product_id = p.id`;

    const [rows] = await db.query(request);

    console.log(rows);
    return rows;



});