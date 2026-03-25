import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    const body = await readBody(event);
    const db = getDB();

    const { id, firstname, lastname, email, phone, address } = body;

    if (!id) {
        throw createError({ statusCode: 400, statusMessage: 'ID manquant' });
    }

    if (!firstname || !lastname || !email) {
        throw createError({ statusCode: 400, statusMessage: 'Champs obligatoires manquants' });
    }

    if (!email.includes('@')) {
        throw createError({ statusCode: 400, statusMessage: 'Email invalide' });
    }

    await db.execute(
        `UPDATE user 
         SET firstname = ?, lastname = ?, email = ?, phone = ?, address = ?
         WHERE id = ?`,
        [firstname, lastname, email, phone, address, id]
    );

    return { message: 'Informations mises à jour' };
});
