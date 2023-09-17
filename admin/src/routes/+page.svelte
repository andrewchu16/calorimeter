<script lang="ts">
    import { db } from '$lib/firestore';
    import type Item from '$lib/models/item.model';
    import { collection, doc, getDoc, getDocs } from 'firebase/firestore';

    const getItemsByCategory = async () => {
        let itemsByCategory: Map<string, any[]> = new Map<string, Item[]>();
        const itemsRef = collection(db, 'items');
        const itemsSnap = await getDocs(itemsRef);
        itemsSnap.forEach((doc) => {
            const data = doc.data();
            const newItem = {
                id: doc.id,
                name: data.name,
                category: data.category,
                price: data.price,
                calories: data.calories,
                fat: data.fat,
                protein: data.protein,
                sugar: data.sugar,
                imgURL: data.imgURL
            };

            if (itemsByCategory.has(data.category)) {
                const items = itemsByCategory.get(data.category)!;
                items.push(newItem);
            } else {
                itemsByCategory.set(data.category, [newItem]);
            }
        });

        return itemsByCategory;
    };

    const itemsByCategory = getItemsByCategory();
</script>

<svelte:head>
    <title>View Items</title>
</svelte:head>

<div class="w-full h-full py-12 lg:px-32 overflow-auto flex flex-col gap-5">
    <h1 class="text-3xl text-center">Items</h1>
    {#await itemsByCategory}
        <p>Loading items...</p>
    {:then itemsByCategory}
        {#each itemsByCategory as pair (pair[0])}
            <div>
                <h2 class="text-2xl mb-2">{pair[0]}</h2>
                <div class="flex flex-col ml-3 bg-neutral-100 rounded-lg">
                    {#each pair[1] as item (item.id)}
                        <div class="pl-2">
                            <div class="grid grid-cols-5 items-center">
                                <img src={item.imgURL} alt={item.name} class="object-contain h-[80%] rounded-xl">
                                <div class="justify-self-center">
                                    {item.name}
                                </div>
                                <div class="justify-self-end">
                                    {Intl.NumberFormat('en-US').format(item.calories)} cal
                                </div>
                                <div class="justify-self-end">
                                    {Intl.NumberFormat('en-US', {
                                        style: 'currency',
                                        currency: 'USD'
                                    }).format(item.price)}
                                </div>
                                <a href="/edit/{item.id}" class="justify-self-end mr-2 hover:bg-red-300 hover:cursor-pointer bg-neutral-200 rounded-lg py-2 px-5 text-md">
                                    edit
                                </a>
                            </div>
                        </div>
                    {/each}
                </div>
            </div>
        {/each}
    {/await}
</div>
