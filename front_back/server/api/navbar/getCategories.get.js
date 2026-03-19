import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    const db = getDB();

    const request = `
        SELECT 
            p.id AS parent_id,
            p.name AS parent_name,
            c.id AS child_id,
            c.name AS child_name
        FROM category p
        LEFT JOIN category c ON c.category_parent_id = p.id
        WHERE p.category_parent_id IS NULL
        ORDER BY p.id, c.id
    `;

    const [rows] = await db.query(request);

    const categories = [];
    const categoriesById = {};

    for (const row of rows) {
        if (!categoriesById[row.parent_id]) {
            const parent = {
                id: row.parent_id,
                name: row.parent_name,
                children: [],
            };
            categoriesById[row.parent_id] = parent;
            categories.push(parent);
        }

        if (row.child_id) {
            categoriesById[row.parent_id].children.push({
                id: row.child_id,
                name: row.child_name,
            });
        }
    }

    return categories;
});
