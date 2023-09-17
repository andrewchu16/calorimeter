<script lang="ts">
    import { db } from '$lib/firestore';
    import { session } from '$lib/session';
    import {
        addDoc,
        collection,
        doc,
        getDoc,
        updateDoc,
        type DocumentData
    } from 'firebase/firestore';
    import { getDownloadURL, getStorage, ref, uploadBytes } from 'firebase/storage';
    import type { PageServerData } from './$types';
    import { redirect } from '@sveltejs/kit';

    export let data: PageServerData;

    let name: string = data.name;
    let category: string = data.category;
    let price: number = data.price;
    let calories: number = data.calories;
    let fat: number = data.fatVal;
    let protein: number = data.proteinVal;
    let sugar: number = data.sugarVal;
    let imgURL: string = data.imgURL;

    let success = false;
    let failed = false;
    let submitButtonText = 'Submit';

    let companyId: string;
    session.subscribe((value) => {
        companyId = value.companyId;
    });

    const onSubmit = async () => {
        if (!companyId) {
            console.log('Company ID not set ' + companyId);
            return;
        }

        const itemRef = doc(db, 'items', data.itemId);

        await updateDoc(itemRef, {
            name: name,
            category: category,
            price: price,
            calories: calories,
            fat: fat,
            protein: protein,
            sugar: sugar,
            imgURL: imgURL
        });

        console.log('successfully updated item');
        success = true;
        submitButtonText = 'Success!';
        setTimeout(() => {
            success = false;
            submitButtonText = 'Submit';
        }, 2500);
    };
</script>

<svelte:head>
    <title>Edit {name}</title>
</svelte:head>

<div class="flex flex-col items-center pt-6 overflow-y-auto h-full">
    <h1 class="text-3xl">Edit {name}</h1>
    <form on:submit|preventDefault={onSubmit} class="flex flex-col gap-4 w-1/3">
        <section class="mt-3">
            <label for="name">Name</label>
            <input
                required
                type="text"
                id="name"
                bind:value={name}
                class="w-full bg-white px-2 py-1 rounded-md mt-2 outline-none active:bg-neutral-100 focus:bg-neutral-100"
            />
        </section>
        <section>
            <label for="category">Category</label>
            <input
                required
                type="text"
                id="category"
                bind:value={category}
                class="w-full bg-white px-2 py-1 rounded-md mt-2 outline-none active:bg-neutral-100 focus:bg-neutral-100"
            />
        </section>
        <section>
            <label for="price">Price</label>
            <input
                required
                type="number"
                id="price"
                step="0.01"
                bind:value={price}
                class="w-full bg-white px-2 py-1 rounded-md mt-2 outline-none active:bg-neutral-100 focus:bg-neutral-100"
            />
        </section>
        <section>
            <label for="calories">Calories</label>
            <input
                required
                type="number"
                id="calories"
                bind:value={calories}
                class="w-full bg-white px-2 py-1 rounded-md mt-2 outline-none active:bg-neutral-100 focus:bg-neutral-100"
            />
        </section>
        <section>
            <label for="fat">Fat (grams)</label>
            <input
                required
                type="number"
                id="fat"
                step="0.1"
                bind:value={fat}
                class="w-full bg-white px-2 py-1 rounded-md mt-2 outline-none active:bg-neutral-100 focus:bg-neutral-100"
            />
        </section>
        <section>
            <label for="protein">Protein (grams)</label>
            <input
                required
                type="number"
                id="protein"
                step="0.1"
                bind:value={protein}
                class="w-full bg-white px-2 py-1 rounded-md mt-2 outline-none active:bg-neutral-100 focus:bg-neutral-100"
            />
        </section>
        <section>
            <label for="sugar">Sugar (grams)</label>
            <input
                required
                type="number"
                id="sugar"
                step="0.1"
                bind:value={sugar}
                class="w-full bg-white px-2 py-1 rounded-md mt-2 outline-none active:bg-neutral-100 focus:bg-neutral-100"
            />
        </section>
        <section>
            <label for="imgURL">Image URL</label>
            <input
                required
                type="text"
                id="imgURL"
                bind:value={imgURL}
                class="w-full bg-white px-2 py-1 rounded-md mt-2 outline-none active:bg-neutral-100 focus:bg-neutral-100"
            />
        </section>

        <button
            type="submit"
            class:success
            class:failed
            class="bg-white rounded-md w-fit px-5 py-2 mt-2 mb-4 mx-auto">{submitButtonText}</button
        >
    </form>
</div>

<style>
    .success {
        @apply bg-green-400;
    }

    .failed {
        @apply bg-red-400;
    }
</style>
