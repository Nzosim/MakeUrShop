import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    console.log('API appelée');

    const body = await readBody(event);
    console.log(body);

    const db = getDB();

    const { email, password } = body;

    const [rows] = await db.execute('SELECT * FROM user WHERE email = ? AND password = ?', [email, password]);

    if (rows.length === 0) {
        return { success: false };
    }

    return {
        success: true,
        user: rows[0],
    };
});
