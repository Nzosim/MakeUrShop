import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    const db = getDB();
    const { id } = await readBody(event);

    const [childrenCategories] = await db.query(`SELECT id, name FROM category WHERE category_parent_id = ?`, [id]);

    if (childrenCategories.length > 0) {
        const childNames = childrenCategories.map((c) => c.name).join(', ');
        throw createError({
            statusCode: 409,
            message: `Impossible de supprimer : ${childrenCategories.length} sous-catégorie(s) dépendent de cette catégorie (${childNames}).`,
        });
    }

    const [products] = await db.query(`SELECT id, name FROM product WHERE category_id = ?`, [id]);

    if (products.length > 0) {
        const productNames = products.map((p) => p.name).join(', ');
        throw createError({
            statusCode: 409,
            message: `Impossible de supprimer : ${products.length} produit(s) utilisent cette catégorie (${productNames}).`,
        });
    }

    const [rows] = await db.query(`DELETE FROM category WHERE id = ?`, [id]);

    console.log(rows);
    return rows;
});
