<script>
    import SelectCompany from './SelectCompany.svelte';
</script>

<nav class="bg-neutral-300 w-1/6 min-w-[200px] h-full py-8 flex flex-col justify-end gap-4">
    <div class="flex flex-col justify-end">
        <a
            class="hover:brightness-75 transition-[filter] duration-150 bg-neutral-300 text-lg p-6"
            href="/add">Add Item</a
        >
        <a
            class="hover:brightness-75 transition-[filter] duration-150 bg-neutral-300 text-lg p-6"
            href="/view">View Items</a
        >
    </div>
    <div class="mx-6">
        <SelectCompany />
    </div>
</nav>
