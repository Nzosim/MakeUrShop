<template>
    <v-container>
        <v-img src="/contents/index/visual_index_1.png" width="1000" elevation="8" class="mx-auto mt-8 rounded-xl"></v-img>
    </v-container>
    <v-container>
        <h2 class="my-12">LES PLUS VENDUS ⤶</h2>
        <br />
    </v-container>
    <v-container>
        <h2 class="my-12">⤷ NOTRE MARQUE</h2>
        <v-row>
            <v-col cols="12" md="9">
                <div v-if="data" v-html="data.content" class="md-description"></div>
                <v-btn to="/about" class="mt-4 categories" color="primary">En savoir plus</v-btn>
            </v-col>
            <v-col cols="12" md="3">
                <v-img src="/assets/img/small_logo_makeurshop.png" width="150" elevation="8" class="mx-auto mt-8 rounded-xl icons"></v-img>
            </v-col>
        </v-row>
    </v-container>
</template>

<script setup>
    const { data, pending, error } = await useFetch('/api/index/brandDescription');
</script>

<style scoped>
    .md-description :deep(p) {
        margin-bottom: 1rem;
    }
</style>
