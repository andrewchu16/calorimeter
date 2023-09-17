<script lang="ts">
    import type { PageServerData } from "./$types";

    export let data: PageServerData;
</script>

<svelte:head>
    <title>Edit Item {data.name}</title>
</svelte:head>
