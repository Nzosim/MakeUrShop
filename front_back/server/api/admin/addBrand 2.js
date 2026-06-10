import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    const db = getDB();
    const { name } = await readBody(event);

    const checkRequest = `
        SELECT id, name FROM brand WHERE name = ?
    `;

    const [existingBrand] = await db.query(checkRequest, [name]);

    if (existingBrand.length) {
        throw createError({
            statusCode: 409,
            message: `La marque "${existingBrand[0].name}" existe déjà.`,
        });
    }
    const request = `
        INSERT INTO brand (name) VALUES (?)
    `;

    const [rows] = await db.query(request, [name]);

    console.log(rows);
    return rows;
});
