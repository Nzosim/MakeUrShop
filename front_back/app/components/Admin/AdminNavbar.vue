<template>
    <v-navigation-drawer permanent>
        <v-list>
            <v-list-item class="d-flex justify-center">
                <div class="logo-text">{{ storeName }}</div>
            </v-list-item>
        </v-list>
        <v-list density="compact" nav active-color="primary">
            <v-list-item prepend-icon="mdi-poll" title="Statistiques" value="starred" href="/dashboard/stats"></v-list-item>
            <v-list-item prepend-icon="mdi-cart" title="Commandes" value="prout2" href="/dashboard/order"></v-list-item>
            <v-list-group value="gestion">
                <template #activator="{ props }">
                    <v-list-item v-bind="props" prepend-icon="mdi-tag" title="Gestion"></v-list-item>
                </template>

                <v-list-item prepend-icon="mdi-package-variant" title="Stockage" value="articles" href="/dashboard/article"></v-list-item>
                <v-list-item prepend-icon="mdi-tag" title="Marques" value="marques" href="/dashboard/brands"></v-list-item>
                <v-list-item prepend-icon="mdi-shape" title="Catégories" value="categories" href="/dashboard/categories"></v-list-item>
            </v-list-group>

            <v-list-item prepend-icon="mdi-face-man-profile" title="Clients" value="shared" href="/dashboard/accounts"></v-list-item>
            <v-list-item prepend-icon="mdi-text-shadow" title="Configuration" value="starred" href="/dashboard/configuration"></v-list-item>
        </v-list>

        <v-list style="position: absolute; bottom: 10px; width: 100%">
            <v-divider class="mb-2"></v-divider>
            <v-list-item
                prepend-avatar="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQN0p9Jer0iBCVzxQGUsNyXAgk_osWJU8arSw&s"
                subtitle="Administrateur"
                title="Enzo Simonin"
            >
                <template #append>
                    <v-btn icon="mdi-home" size="small" variant="text" href="/" />
                </template>
            </v-list-item>
        </v-list>
    </v-navigation-drawer>
</template>

<style>
    @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@600&display=swap');

    .logo-text {
        font-family: 'Poppins', sans-serif;
        font-size: 24px;
        font-weight: 600;
        white-space: nowrap;
        overflow: hidden;
        letter-spacing: 1px;
    }
</style>

<script setup>
    import configData from '@/assets/config.json';
    const storeName = configData.config.info.storeName;
</script>
