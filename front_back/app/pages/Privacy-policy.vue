<template>
    <v-container>
        <div v-if="privacyPolicy" v-html="privacyPolicy.content" class="md-description"></div>
        <div v-if="privacyPolicyPending" class="text-center my-12">
            <v-progress-circular indeterminate color="primary"></v-progress-circular>
        </div>
        <div v-if="privacyPolicyError" class="text-center my-12 text-error">
            <v-icon icon="mdi-alert-circle" color="error" class="mr-1"></v-icon>
            Une erreur est survenue lors du chargement de la politique de confidentialité. Veuillez réessayer plus tard.
        </div>
    </v-container>
</template>

<script setup>
    const { data: privacyPolicy, pending: privacyPolicyPending, error: privacyPolicyError } = await useFetch('/api/privacy-policy/privacyPolicy');
</script>
