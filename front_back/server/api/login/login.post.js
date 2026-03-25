import { getDB } from '../../utils/db.js';
import bcrypt from 'bcrypt';

export default defineEventHandler(async (event) => {
    const body = await readBody(event);
    const db = getDB();
    const { email, password } = body;

    // 1. Chercher l'utilisateur par email uniquement
    const [rows] = await db.execute('SELECT * FROM user WHERE email = ?', [email]);

    if (rows.length === 0) {
        return { success: false, message: 'Utilisateur non trouvé' };
    }

    const user = rows[0];

    // 2. Comparer le mot de passe envoyé avec le hash en BDD
    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
        return { success: false, message: 'Mot de passe incorrect' };
    }

    // On retire le password avant de renvoyer l'objet user au front
    delete user.password;

    return {
        success: true,
        user: user,
    };
});
