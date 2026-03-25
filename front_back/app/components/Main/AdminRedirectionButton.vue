<template>
    <v-fab @click="navigateTo('/Dashboard/main')" color="primary" class="adminRedirectionButton" icon="mdi-shield-crown"></v-fab>
</template>

<style scoped>
    .adminRedirectionButton {
        position: fixed;
        bottom: 20px;
        right: 20px;
        z-index: 999;
    }
</style>
