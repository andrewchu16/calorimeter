<script lang="ts">
    import { db } from '$lib/firestore';
    import type Item from '$lib/models/item.model';
    import { collection, getDocs } from 'firebase/firestore';

    const getItemsByCategory = async () => {
        let itemsByCategory: Map<string, Item[]> = new Map<string, Item[]>();
        const itemsRef = collection(db, 'items');
        const itemsSnap = await getDocs(itemsRef);
        itemsSnap.forEach((doc) => {
            const data = doc.data();
            const newItem: Item = {
                name: data.name,
                category: data.category,
                price: data.price,
                calories: data.calories,
                fat: data.fat,
                protein: data.protein,
                sugar: data.sugar
            };

            if (data.category in itemsByCategory) {
                const items: Item[] = itemsByCategory.get(data.category)!;
                items.push(newItem);
            } else {
                itemsByCategory.set(data.category, [newItem]);
            }
        });
        
        return itemsByCategory;
    }

    const itemsByCategory = getItemsByCategory();
</script>

<svelte:head>
    <title>View Items</title>
</svelte:head>

<div class="w-full h-full py-12 px-20 overflow-auto">
    {#await itemsByCategory}
    <p>Loading items...</p>
    {:then itemsByCategory}
        {#each itemsByCategory as pair}
            <h2 class="text-2xl">{pair[0]}</h2>
            <div class="flex flex-col ml-3">
                {#each pair[1] as item}
                <div class="bg-neutral-100 text-lg rounded-lg">{item.name}</div>
                {/each}
            </div>
        {/each}
    {/await}
</div>