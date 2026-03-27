<template>
    <v-container>
        <div v-if="cgv" v-html="cgv.content" class="md-description"></div>
        <div v-if="cgvPending" class="text-center my-12">
            <v-progress-circular indeterminate color="primary"></v-progress-circular>
        </div>
        <div v-if="cgvError" class="text-center my-12 text-error">
            <v-icon icon="mdi-alert-circle" color="error" class="mr-1"></v-icon>
            Une erreur est survenue lors du chargement des CGV. Veuillez réessayer plus tard.
        </div>
    </v-container>
</template>

<script setup>
    const { data: cgv, pending: cgvPending, error: cgvError } = await useFetch('/api/cgv/cgv');
</script>
