import { getDB } from '../../utils/db.js';
import bcrypt from 'bcrypt';

export default defineEventHandler(async (event) => {
    const body = await readBody(event);
    const db = getDB();

    // 1. Fonction de nettoyage (Sanitization)
    const sanitize = (val) => {
        if (!val) return '';
        return val
            .toString()
            .replace(/[{}<>\[\]"']/g, '')
            .trim();
    };

    const lastName = sanitize(body.lastName);
    const firstName = sanitize(body.firstName);
    const email = sanitize(body.email).toLowerCase();
    const rawPassword = sanitize(body.password);
    const phone = sanitize(body.phoneNumber);

    // 2. Validations de base
    if (!email || !rawPassword || !firstName || !lastName) {
        return { success: false, message: 'Tous les champs obligatoires ne sont pas remplis.' };
    }

    try {
        // 3. Vérifier si l'email existe déjà
        const [existingUser] = await db.execute('SELECT id FROM user WHERE email = ?', [email]);

        if (existingUser.length > 0) {
            return { success: false, message: 'Cet e-mail est déjà utilisé.' };
        }

        // 4. Hachage du mot de passe (Sécurité)
        // On ne stocke JAMAIS le mot de passe tel quel
        const saltRounds = 10;
        const hashedPassword = await bcrypt.hash(rawPassword, saltRounds);

        // 5. Insertion dans la base de données
        // Note : Le rôle par défaut est 'client'
        const [result] = await db.execute(
            `INSERT INTO user (email, password, firstname, lastname, phone, role) 
             VALUES (?, ?, ?, ?, ?, 'client')`,
            [email, hashedPassword, firstName, lastName, phone]
        );

        // 6. Récupérer l'utilisateur créé (sans le mot de passe pour la session)
        const userId = result.insertId;
        const [newUser] = await db.execute('SELECT id, email, firstname, lastname, role FROM user WHERE id = ?', [userId]);

        return {
            success: true,
            user: newUser[0],
            message: 'Compte créé avec succès !',
        };
    } catch (error) {
        console.error('Erreur Register:', error);
        return {
            success: false,
            message: 'Une erreur technique est survenue sur le serveur.',
        };
    }
});
