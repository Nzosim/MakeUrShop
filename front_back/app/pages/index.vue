<template>
    <v-container>
        <v-img src="/assets/img/visual_1_index.png" width="1000" elevation="8" class="mx-auto mt-8 rounded-xl"></v-img>
    </v-container>
    <v-container>
        <h2 class="my-12">LES PLUS VENDUS</h2>
        <br />
    </v-container>
    <v-container>
        <h2 class="my-12">NOTRE MARQUE</h2>
        <p>{{ configData.config.info.bio }}</p>
    </v-container>
</template>

<script setup>
    import configData from '/assets/config.json';
</script>
