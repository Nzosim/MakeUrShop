import { getDB } from '../../utils/db.js';

export default defineEventHandler(async (event) => {
    const db = getDB();

    const query = getQuery(event);
    const categoryId = query.id ? Number(query.id) : null;
    const productId = query.productId ? Number(query.productId) : null;

    let whereClause = '';

    if (productId) {
        whereClause = `WHERE p.id = ${productId}`;
    } else if (categoryId !== null) {
        whereClause = `WHERE c.category_parent_id = ${categoryId} OR c.id = ${categoryId}`;
    }

    const request = `
        SELECT
            p.id,
            p.name,
            p.description,
            p.price,
            p.sale_price,
            p.actif,
            b.name AS brand_name,
            MIN(i.url) AS url,
            SUM(CASE WHEN s.size = 'S'   THEN s.stock_number ELSE 0 END) AS taille_S,
            SUM(CASE WHEN s.size = 'M'   THEN s.stock_number ELSE 0 END) AS taille_M,
            SUM(CASE WHEN s.size = 'L'   THEN s.stock_number ELSE 0 END) AS taille_L,
            SUM(CASE WHEN s.size = 'XL'  THEN s.stock_number ELSE 0 END) AS taille_XL
        FROM product p
        JOIN category c ON p.category_id = c.id
        JOIN brand b ON p.brand_id = b.id
        LEFT JOIN image i ON i.product_id = p.id
        LEFT JOIN stock s ON s.product_id = p.id

        ${whereClause}

        GROUP BY p.id, p.name, p.description, p.price, p.actif, b.name
    `;

    const [rows] = await db.query(request);

    console.log(rows);
    return rows;
});
