<script setup>
    import { ref, watch } from 'vue';

    const value = ref('');
    const selectedFile = ref('');
    const isLoading = ref(false);

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
                        label: 'Titre 1',
                    },
                    {
                        kind: 'heading',
                        level: 2,
                        icon: 'i-lucide-heading-2',
                        label: 'Titre 2',
                    },
                    {
                        kind: 'heading',
                        level: 3,
                        icon: 'i-lucide-heading-3',
                        label: 'Titre 3',
                    },
                    {
                        kind: 'heading',
                        level: 4,
                        icon: 'i-lucide-heading-4',
                        label: 'Titre 4',
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
                label: 'Texte',
            },
            {
                kind: 'paragraph',
                label: 'Paragraphe',
                icon: 'i-lucide-type',
            },
            {
                kind: 'heading',
                level: 1,
                label: 'Titre 1',
                icon: 'i-lucide-heading-1',
            },
            {
                kind: 'heading',
                level: 2,
                label: 'Titre 2',
                icon: 'i-lucide-heading-2',
            },
            {
                kind: 'heading',
                level: 3,
                label: 'Titre 3',
                icon: 'i-lucide-heading-3',
            },
        ],
        [
            {
                type: 'label',
                label: 'Liste',
            },
            {
                kind: 'bulletList',
                label: 'Liste à puces',
                icon: 'i-lucide-list',
            },
            {
                kind: 'orderedList',
                label: 'Liste numérotée',
                icon: 'i-lucide-list-ordered',
            },
        ],
        [
            {
                type: 'label',
                label: 'Insérer',
            },
            {
                kind: 'blockquote',
                label: 'Citation',
                icon: 'i-lucide-text-quote',
            },
            {
                kind: 'codeBlock',
                label: 'Code',
                icon: 'i-lucide-square-code',
            },
            {
                kind: 'horizontalRule',
                label: 'Séparateur',
                icon: 'i-lucide-separator-horizontal',
            },
        ],
    ];
    const appendToBody = import.meta.client ? () => document.body : undefined;

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
    <div class="pa-6">
        <v-sheet elevation="2" rounded="lg" class="mb-6 pa-4 d-flex align-center justify-space-between border-thin" color="surface">
            <div class="d-flex align-center flex-grow-1 ml-6">
                <div style="flex-basis: 300px">
                    <div class="text-caption font-weight-bold text-uppercase opacity-60 mb-1">Fichier à modifier</div>
                    <v-select v-model="selectedFile" :items="allowedFiles" density="compact" variant="outlined" hide-details placeholder="Sélectionnez un fichier"></v-select>
                </div>
            </div>

            <v-btn @click="saveFile" color="primary" elevation="2" class="rounded-lg categories mr-6">Sauvegarder</v-btn>
        </v-sheet>

        <v-card elevation="2" rounded="lg" border="thin" color="surface">
            <div class="pa-2">
                <UEditor
                    v-slot="{ editor }"
                    v-model="value"
                    content-type="markdown"
                    :placeholder="isLoading ? 'Chargement...' : 'Appuyer sur / pour voir les commandes...'"
                    class="ue-editor w-full min-h-[600px] pa-6"
                >
                    <UEditorToolbar :editor="editor" :items="toolbarItems" layout="bubble" class="bg-secondary text-white shadow-lg rounded-pill mb-4" />
                    <UEditorSuggestionMenu :editor="editor" :items="suggestionItems" :append-to="appendToBody" class="bg-secondary text-white rounded-lg" />
                </UEditor>
            </div>
        </v-card>
    </div>
</template>

<style scoped>
    :deep(.ue-editor) {
        color: inherit;
    }

    :deep(.ue-editor h1),
    :deep(.ue-editor h2),
    :deep(.ue-editor h3),
    :deep(.ue-editor h4),
    :deep(.ue-editor hr) {
        color: currentColor !important;
        border-color: currentColor;
        opacity: 0.9;
    }

    :deep(.ue-editor hr) {
        border: 0;
        border-top: 1px solid currentColor;
        margin: 2em 0;
        opacity: 0.2;
    }
</style>
