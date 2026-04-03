<script setup>
    import { ref, watch } from 'vue';

    const value = ref('');
    const selectedFile = ref('');
    const isLoading = ref(false);

    // Mapping automatique fichier → sous-dossier
    const fileFolderMap = {
        'brand_history.md': 'about',
        'cgv.md': 'cgv',
        'brand_description.md': 'common',
        'legal-mentions.md': 'legal-mentions',
        'privacy-policy.md': 'privacy-policy',
    };

    const toolbarItems = [
        [
            {
                icon: 'i-lucide-heading',
                tooltip: { text: 'Headings' },
                content: {
                    align: 'start',
                },
                items: [
                    {
                        kind: 'heading',
                        level: 1,
                        icon: 'i-lucide-heading-1',
                        label: 'Heading 1',
                    },
                    {
                        kind: 'heading',
                        level: 2,
                        icon: 'i-lucide-heading-2',
                        label: 'Heading 2',
                    },
                    {
                        kind: 'heading',
                        level: 3,
                        icon: 'i-lucide-heading-3',
                        label: 'Heading 3',
                    },
                    {
                        kind: 'heading',
                        level: 4,
                        icon: 'i-lucide-heading-4',
                        label: 'Heading 4',
                    },
                ],
            },
        ],
        [
            {
                kind: 'mark',
                mark: 'bold',
                icon: 'i-lucide-bold',
                tooltip: { text: 'Bold' },
            },
            {
                kind: 'mark',
                mark: 'italic',
                icon: 'i-lucide-italic',
                tooltip: { text: 'Italic' },
            },
            {
                kind: 'mark',
                mark: 'underline',
                icon: 'i-lucide-underline',
                tooltip: { text: 'Underline' },
            },
            {
                kind: 'mark',
                mark: 'strike',
                icon: 'i-lucide-strikethrough',
                tooltip: { text: 'Strikethrough' },
            },
            {
                kind: 'mark',
                mark: 'code',
                icon: 'i-lucide-code',
                tooltip: { text: 'Code' },
            },
        ],
    ];

    const suggestionItems = [
        [
            {
                type: 'label',
                label: 'Text',
            },
            {
                kind: 'paragraph',
                label: 'Paragraph',
                icon: 'i-lucide-type',
            },
            {
                kind: 'heading',
                level: 1,
                label: 'Heading 1',
                icon: 'i-lucide-heading-1',
            },
            {
                kind: 'heading',
                level: 2,
                label: 'Heading 2',
                icon: 'i-lucide-heading-2',
            },
            {
                kind: 'heading',
                level: 3,
                label: 'Heading 3',
                icon: 'i-lucide-heading-3',
            },
        ],
        [
            {
                type: 'label',
                label: 'Lists',
            },
            {
                kind: 'bulletList',
                label: 'Bullet List',
                icon: 'i-lucide-list',
            },
            {
                kind: 'orderedList',
                label: 'Numbered List',
                icon: 'i-lucide-list-ordered',
            },
        ],
        [
            {
                type: 'label',
                label: 'Insert',
            },
            {
                kind: 'blockquote',
                label: 'Blockquote',
                icon: 'i-lucide-text-quote',
            },
            {
                kind: 'codeBlock',
                label: 'Code Block',
                icon: 'i-lucide-square-code',
            },
            {
                kind: 'horizontalRule',
                label: 'Divider',
                icon: 'i-lucide-separator-horizontal',
            },
        ],
    ];
    const appendToBody = import.meta.client ? () => document.body : undefined;

    // Charger le fichier quand le fichier sélectionné change
    watch(selectedFile, async () => {
        const folder = fileFolderMap[selectedFile.value];
        if (!selectedFile.value || !folder) return;
        isLoading.value = true;
        try {
            const res = await $fetch('/api/md-file', {
                method: 'POST',
                body: { filename: selectedFile.value, folder },
            });
            if (res.success) value.value = res.content;
        } catch (e) {
            alert('Erreur lors du chargement du fichier');
        } finally {
            isLoading.value = false;
        }
    });

    // Sauvegarder
    const saveFile = async () => {
        const folder = fileFolderMap[selectedFile.value];
        if (!folder) return alert('Sous-dossier automatique introuvable pour ce fichier');
        try {
            const res = await $fetch('/api/md-file', {
                method: 'POST',
                body: { filename: selectedFile.value, folder, content: value.value },
            });
            alert(res?.message || 'Action terminée');
        } catch (e) {
            alert('Erreur lors de la sauvegarde : ' + e.message);
        }
    };

    const allowedFiles = Object.keys(fileFolderMap);
</script>

<template>
    <div class="flex flex-col gap-6 p-6">
        <v-card class="p-6 shadow-lg rounded-xl bg-white/5 border border-gray-700">
            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-6">
                <div class="flex flex-col md:flex-row md:items-center gap-4">
                    <label class="font-medium ml-4 mt-4">Fichier à modifier :</label>
                    <select v-model="selectedFile" class="border rounded-lg p-2 bg-white text-gray-800 min-w-[200px] mt-4">
                        <option disabled value="">-- Sélectionnez un fichier --</option>
                        <option v-for="f in allowedFiles" :key="f" :value="f">{{ f }}</option>
                    </select>
                </div>

                <v-btn @click="saveFile" class="bg-primary text-white border border-gray-700 rounded-lg px-6 py-2 shadow-md hover:brightness-110 mt-4 mr-4">Sauvegarder</v-btn>
            </div>

            <div class="w-full">
                <UEditor
                    v-slot="{ editor }"
                    v-model="value"
                    content-type="markdown"
                    :placeholder="isLoading ? 'Chargement...' : 'Appuyer sur / pour voir les commandes...'"
                    class="ue-editor w-full min-h-[500px] bg-secondary text-white border border-gray-700 rounded-lg p-6"
                >
                    <UEditorToolbar :editor="editor" :items="toolbarItems" layout="bubble" class="bg-secondary text-white border border-gray-700 shadow-md rounded-md mb-4" />
                    <UEditorSuggestionMenu :editor="editor" :items="suggestionItems" :append-to="appendToBody" class="bg-secondary text-white border border-gray-700 rounded-md" />
                </UEditor>
            </div>
        </v-card>
    </div>
</template>
