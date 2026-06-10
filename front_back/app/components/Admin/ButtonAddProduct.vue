<script setup>
    import PopupProductStock from '~/components/Admin/PopupProductStock.vue';

    const open = ref(false);
    const popup = ref(false);
</script>

<template>
    <div class="demo-panel-absolute">
        <v-fab color="primary" size="large" icon>
            <v-icon>{{ open ? 'mdi-close' : 'mdi-cog' }}</v-icon>

            <v-speed-dial v-model="open" activator="parent">
                <v-btn
                    key="1"
                    color="success"
                    icon
                    @click="
                        popup = true;
                        open = false;
                    "
                >
                    <v-icon size="24">mdi-plus</v-icon>
                </v-btn>
            </v-speed-dial>
        </v-fab>

        <PopupProductStock v-model="popup" />
    </div>
</template>

<style scoped>
    .demo-panel-absolute {
        position: fixed;
        bottom: 20px;
        right: 20px;
        z-index: 1000;
    }
</style>
