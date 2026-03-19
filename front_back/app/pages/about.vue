<template>
    <v-container>
        <h1 class="my-12">NOTRE MARQUE</h1>
        <v-row>
            <v-col cols="12" md="9">
                <div v-if="data" v-html="data.content" class="md-data"></div>
            </v-col>
            <v-col cols="12" md="3">
                <v-img src="/assets/img/small_logo_makeurshop.png" width="150" elevation="8" class="mx-auto mt-8 rounded-xl icons"></v-img>
            </v-col>
        </v-row>
        <v-row class="my-12">
            <v-col cols="12" md="5" class="align-self-center">
                <v-img src="/contents/about/timeline.png" elevation="8" class="mx-auto mt-8 rounded-xl"></v-img>
            </v-col>
            <v-col cols="12" md="7">
                <h1 class="my-12">NOTRE HISTOIRE</h1>

                <div v-if="history" v-html="history.content" class="md-description"></div>
            </v-col>
        </v-row>
    </v-container>
</template>

<script setup>
    const { data, pending, error } = await useFetch('/api/index/brandDescription');
    const { data: history, pending: historyPending, error: historyError } = await useFetch('/api/about/brandHistory');
</script>

<style scoped>
    .md-description :deep(p) {
        margin-bottom: 1rem;
    }
</style>
