<template>
    <v-container>
        <v-row class="font-weight-bold border-b pb-2">
            <v-col cols="2">Nom du stock</v-col>
            <v-col cols="2">Nombre de stock</v-col>
        </v-row>
        <div v-for="n in 3" :key="n" class="py-2 border-b d-flex align-center ga-2">
            Stock de truc
            <v-spacer></v-spacer>
            <v-icon-btn icon="mdi-dots-vertical" size="small" variant="outlined" @click="show"></v-icon-btn>
        </div>

        <v-menu v-model="showMenu" :offset="[-8, -12]" :target="menuTarget" location="bottom end" scroll-strategy="close">
            <v-list :items="menuItems" class="py-0" density="compact" item-value="code" item-props slim>
                <template v-slot:prepend>
                    <v-icon class="mr-n2" size="small"></v-icon>
                </template>
            </v-list>
        </v-menu>
    </v-container>
</template>

<script setup>
    import { ref } from 'vue';

    const showMenu = ref(false);
    const menuTarget = ref(null);

    const menuItems = [
        { title: 'Modifier', prependIcon: 'mdi-pencil', code: 'edit' },
        { title: 'Supprimer', prependIcon: 'mdi-trash-can', code: 'delete' },
    ];

    async function show(evt) {
        if (showMenu.value) {
            showMenu.value = false;
            await new Promise((resolve) => setTimeout(resolve, 100));
        }
        menuTarget.value = evt.target.closest('.v-icon-btn');
        showMenu.value = true;
    }
</script>
