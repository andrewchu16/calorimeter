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
    import { getDownloadURL, getStorage, ref, uploadBytes } from "firebase/storage";

    let name: string;
    let category: string;
    let price: number;
    let calories: number;
    let fat: number;
    let protein: number;
    let sugar: number;
    let files: FileList;

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
        
        const itemsRef = collection(db, 'items');
        
        const storage = getStorage();
        
        const itemRef = await addDoc(itemsRef, {
            name: name,
            category: category,
            price: price,
            calories: calories,
            fat: fat,
            protein: protein,
            sugar: sugar,
            imgURL: ""
        });
        
        const storageRef = ref(storage, itemRef.id);
        for (const file of files) {
            await uploadBytes(storageRef, file);
            console.log(storageRef.bucket);
        }

        await updateDoc(itemRef, {
            imgURL: await getDownloadURL(storageRef)
        });

        const companyDocRef = doc(db, 'companies/' + companyId);
        const companySnap = await getDoc(companyDocRef);

        if (companySnap.exists()) {
            const companyData: DocumentData = companySnap.data();
            const items = companyData.items;

            updateDoc(companyDocRef, {
                items: [...items, itemRef.id]
            });
        }
        

        console.log('successfully added item');
        success = true;
        submitButtonText = 'Success!';
        setTimeout(() => {
            success = false;
            submitButtonText = 'Submit';
        }, 2500);
    };
</script>

<svelte:head>
    <title>Add Item</title>
</svelte:head>

<div class="flex flex-col items-center pt-6 overflow-y-auto h-full">
    <h1 class="text-3xl">Add Item</h1>
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
            <label for="imgURL" class="mr-4">Image</label>
            <input
                required
                type="file"
                id="imgURL"
                class="bg-white px-2 py-1 rounded-md mt-2 block w-full text-md"
                bind:files
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
