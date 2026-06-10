import { readFile } from 'fs/promises';
import { join } from 'path';
import { marked } from 'marked';

export default defineEventHandler(async () => {
    try {
        const filePath = join(process.cwd(), 'app', 'contents', 'TestTextEditor.md');
        const mdContent = await readFile(filePath, 'utf-8');

        const htmlContent = marked.parse(mdContent);

        return { content: htmlContent };
    } catch (e) {
        return { content: 'Erreur lors du chargement du contenu.' };
    }
});
