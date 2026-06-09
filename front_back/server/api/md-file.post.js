import { writeFile, readFile } from 'fs/promises';
import { join } from 'path';

const allowedFiles = ['brand_history.md', 'cgv.md', 'brand_description.md', 'legal-mentions.md', 'privacy-policy.md'];

export default defineEventHandler(async (event) => {
    const body = await readBody(event); // body = { filename, folder, content }
    const { filename, folder, content } = body;

    if (!allowedFiles.includes(filename)) {
        return { success: false, message: 'Fichier non autorisé' };
    }

    if (!folder) {
        return { success: false, message: 'Sous-dossier non précisé' };
    }

    const filePath = join(process.cwd(), 'app', 'contents', folder, filename);

    try {
        if (content !== undefined) {
            // Sauvegarde
            await writeFile(filePath, content, 'utf-8'); // <-- Écriture
            return { success: true, message: `${filename} sauvegardé avec succès.` };
        } else {
            // Lecture
            const mdContent = await readFile(filePath, 'utf-8');
            return { success: true, content: mdContent, message: 'Fichier chargé' };
        }
    } catch (e) {
        return { success: false, message: e.message };
    }
});
