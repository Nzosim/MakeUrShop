<template>
    <div class="d-flex justify-end mb-4">
        <span class="text-caption text-medium-emphasis">Dernière mise à jour : {{ lastRefresh }}</span>
    </div>
</template>

<script setup>
    const lastRefresh = ref(
        new Date().toLocaleString('fr-FR', {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
        })
    );
</script>
