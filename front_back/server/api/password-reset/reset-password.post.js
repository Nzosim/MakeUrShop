import bcrypt from 'bcrypt';
import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    const { token, password } = await readBody(event);
    const db = getDB();

    if (!token || !password) {
        throw createError({ statusCode: 400, statusMessage: 'Token ou mot de passe manquant' });
    }

    const [rows] = await db.execute('SELECT id FROM user WHERE reset_token = ? AND reset_token_expiry > NOW()', [token]);

    if (rows.length === 0) {
        throw createError({ statusCode: 400, message: 'Token invalide ou expiré' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    await db.execute('UPDATE user SET password = ?, reset_token = NULL, reset_token_expiry = NULL WHERE id = ?', [hashedPassword, rows[0].id]);

    return { message: 'Mot de passe mis à jour' };
});
