import { readFile } from 'fs/promises';
import { join } from 'path';
import { marked } from 'marked';

export default defineEventHandler(async () => {
    try {
        const filePath = join(process.cwd(), 'app', 'contents', 'legal-mentions', 'legal-mentions.md');
        const mdContent = await readFile(filePath, 'utf8');

        const htmlContent = marked.parse(mdContent);
        return {
            content: htmlContent,
        };
    } catch (e) {
        return { content: 'Erreur lors du chargement du contenu.' };
    }
});
