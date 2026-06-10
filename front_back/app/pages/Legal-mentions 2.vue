<template>
    <v-container>
        <div v-if="legalMentions" v-html="legalMentions.content" class="md-description"></div>
        <div v-if="legalMentionsPending" class="text-center my-12">
            <v-progress-circular indeterminate color="primary"></v-progress-circular>
        </div>
        <div v-if="legalMentionsError" class="text-center my-12 text-error">
            <v-icon icon="mdi-alert-circle" color="error" class="mr-1"></v-icon>
            Une erreur est survenue lors du chargement des mentions légales. Veuillez réessayer plus tard.
        </div>
    </v-container>
</template>

<script setup>
    const { data: legalMentions, pending: legalMentionsPending, error: legalMentionsError } = await useFetch('/api/legal-mentions/legalMentions');
</script>
