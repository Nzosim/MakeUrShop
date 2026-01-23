<template>
    <v-btn @click="theme.toggle()" text="Toggle Light / Dark"></v-btn>

    Test
    <v-btn color="primary">Valider</v-btn>
</template>

<script setup>
    import { useTheme } from 'vuetify';
    const theme = useTheme();
</script>
