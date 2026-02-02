<template>
    User
    <div v-for="user in users" :key="user.id">
        <p>{{ user.firstname }}</p>
        <p>{{ user.lastname }}</p>
        <p>{{ user.email }}</p>
        <p>{{ user.phone }}</p>
        <p>{{ user.address }}</p>
    </div>
</template>

<script setup>
    const { data: users } = await useFetch('/api/user/getUser?id=2');
</script>
