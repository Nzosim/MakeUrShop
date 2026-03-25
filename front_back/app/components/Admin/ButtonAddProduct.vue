<script setup>
    import { ref } from 'vue';
    import PopupProductStock from '~/components/Admin/PopupProductStock.vue';

    const open = ref(false);
    const popup = ref(false);
</script>

<template>
    <div class="demo-panel-absolute">
        <v-fab color="primary" size="large" icon>
            <v-icon>{{ open ? 'mdi-close' : 'mdi-cog' }}</v-icon>

            <v-speed-dial v-model="open" activator="parent">
                <v-btn key="3" color="warning" icon>
                    <v-icon size="24">$warning</v-icon>
                </v-btn>

                <v-btn key="2" color="error" icon>
                    <v-icon size="24">mdi-minus</v-icon>
                </v-btn>

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
    }
</style>
