<script>
    import SelectCompany from './SelectCompany.svelte';
</script>

<nav class="bg-neutral-300 w-1/6 min-w-[200px] h-full pt-6 flex flex-col">
    <div class="mx-6">
        <SelectCompany />
    </div>
    <div class="flex flex-col justify-end flex-auto">
        <a
            class="hover:brightness-75 transition-[filter] duration-150 bg-neutral-300 text-lg p-6"
            href="/add">Add Item</a
        >
        <a
            class="hover:brightness-75 transition-[filter] duration-150 bg-neutral-300 text-lg p-6"
            href="/view">View Items</a
        >
    </div>
    <div class="w-full h-6 bg-neutral-800" />
</nav>
