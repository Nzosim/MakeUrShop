<template>
    <v-overlay :model-value="loading" class="align-center justify-center" persist z-index="9999" background-color="surface">
        <div class="text-center">
            <v-img src="/assets/img/small_logo_makeurshop.png" width="100" class="mx-auto mb-4 animate-bounce icons"></v-img>
        </div>
    </v-overlay>
</template>

<script setup>
    const props = defineProps({
        loading: Boolean,
    });
</script>

<style scoped>
    .animate-bounce {
        animation: bounce 1.5s infinite;
    }
    @keyframes bounce {
        0%,
        100% {
            transform: translateY(0);
        }
        50% {
            transform: translateY(-10px);
        }
    }
</style>
