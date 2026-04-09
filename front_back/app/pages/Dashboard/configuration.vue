<template>
    <v-container>
        <TextEditor />
    </v-container>
</template>

<script setup>
    import TextEditor from '@/components/Main/TextEditorGlobal.vue';
    definePageMeta({
        layout: 'admin',
    });
</script>
