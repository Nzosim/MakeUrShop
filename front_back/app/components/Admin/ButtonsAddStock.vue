<script setup>
    import { shallowRef, watch } from 'vue';

    const open = shallowRef(false);
    const fabPosition = shallowRef('absolute');
    const menuLocation = shallowRef('bottom center');
    const fabLocation = shallowRef('right bottom');
    const transition = shallowRef('slide-y-reverse-transition');

    function reopen() {
        open.value = false;
        setTimeout(() => (open.value = true), 400);
    }
</script>

<template>
    <div class="demo-panel-absolute">
        <v-fab :key="fabPosition" :absolute="fabPosition === 'absolute'" :app="fabPosition === 'fixed'" color="primary" :location="fabLocation" size="large" icon>
            <v-icon>{{ open ? 'mdi-close' : 'mdi-cog' }}</v-icon>
            <v-speed-dial v-model="open" :location="menuLocation" :transition="transition" activator="parent">
                <v-btn key="3" color="warning" icon>
                    <v-icon size="24">$warning</v-icon>
                </v-btn>

                <v-btn key="2" color="error" icon>
                    <v-icon size="24">mdi-minus</v-icon>
                </v-btn>

                <v-btn key="1" color="success" icon>
                    <v-icon size="24">mdi-plus</v-icon>
                </v-btn>

                <!-- 
          <v-btn key="4" color="info" icon>
            <v-icon size="24">$info</v-icon>
          </v-btn> -->
            </v-speed-dial>
        </v-fab>
    </div>
</template>

<style scoped>
    /* This is for documentation purposes and will not be needed in your application */
    ::v-deep(.v-application__wrap) {
        min-height: 0 !important;
    }

    .demo-panel-static,
    .demo-panel-relative {
        margin: 0 80px 50px;
        padding: 24px;
        min-height: 300px;
    }
    .demo-panel-static {
        position: static;
    }
    .demo-panel-absolute {
        position: fixed;
        bottom: 20px;
        right: 20px;
    }

    .v-selection-control--disabled,
    .v-input--disabled .v-selection-control {
        opacity: 0.1;
    }

    .v-radio {
        flex-grow: 0 !important;
    }

    h5 {
        margin-bottom: 12px;
    }

    code {
        display: block;
        font-size: 0.8rem;
        margin-top: 12px;
    }

    ::v-deep(.v-label) {
        margin-left: 8px;
    }
</style>
