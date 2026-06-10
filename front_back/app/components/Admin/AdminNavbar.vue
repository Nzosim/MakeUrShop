<template>
    <v-navigation-drawer permanent>
        <v-list>
            <v-list-item class="d-flex justify-center">
                <div class="logo-text">Dashboard</div>
            </v-list-item>
        </v-list>

        <v-list density="compact" nav active-color="primary">
            <v-list-item prepend-icon="mdi-poll" title="Statistiques" value="stats" to="/dashboard/stats"></v-list-item>
            <v-list-item prepend-icon="mdi-cart" title="Commandes" value="orders" to="/dashboard/order"></v-list-item>

            <v-list-group value="gestion">
                <template #activator="{ props }">
                    <v-list-item v-bind="props" prepend-icon="mdi-tag" title="Gestion"></v-list-item>
                </template>

                <v-list-item prepend-icon="mdi-package-variant" title="Stockage" value="stockage" to="/dashboard/stockage"></v-list-item>
                <v-list-item prepend-icon="mdi-tag" title="Marques" value="marques" to="/dashboard/marque"></v-list-item>
                <v-list-item prepend-icon="mdi-shape" title="Catégories" value="categories" to="/dashboard/categories"></v-list-item>
            </v-list-group>

            <v-list-item prepend-icon="mdi-account-group" title="Clients" value="clients" to="/dashboard/accounts"></v-list-item>
            <v-list-item prepend-icon="mdi-text-shadow" title="Configuration" value="config" to="/dashboard/configuration"></v-list-item>
        </v-list>

        <v-list style="position: absolute; bottom: 0px; width: 100%">
            <v-divider class="mb-2"></v-divider>
            <v-list-item title="Administrateur">
                <template #append>
                    <v-btn icon="mdi-home" size="small" variant="text" to="/" />
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
