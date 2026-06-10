import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    const db = getDB();

    const { category } = await readBody(event);

    const checkRequest = `
        SELECT id, name FROM category WHERE name = ?
    `;

    const [existingCategory] = await db.query(checkRequest, [category.name]);

    if (existingCategory.length) {
        throw createError({
            statusCode: 409,
            message: `La catégorie "${existingCategory[0].name}" existe déjà.`,
        });
    }

    const request = `
        INSERT INTO category (id, name, category_parent_id) VALUES (DEFAULT, ?, ?)
    `;

    const [rows] = await db.query(request, [category.name, category.category_parent_id ?? null]);

    console.log(rows);
    return rows;
});
