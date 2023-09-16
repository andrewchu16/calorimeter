<script lang="ts">
    import { db } from '$lib/firestore';
    import type Company from '$lib/models/company.model';
    import { session } from '$lib/session';
    import { collection, getDocs } from 'firebase/firestore';

    async function getCompanies() {
        const companies: Company[] = [];
        const querySnapshot = await getDocs(collection(db, 'companies'));
        querySnapshot.forEach((doc) => {
            companies.push({
                companyName: doc.data().name,
                companyId: doc.id
            });
        });
        console.log(companies);

        return companies;
    }

    let selectedId: string;

    const onChange = async () => {
        console.log(selectedId);
        const company = (await companies).filter((c) => c.companyId === selectedId)[0];
        session.setCompany(company);
    }

    const companies = getCompanies();
</script>

<nav class="bg-emerald-700 w-[15%] min-w-[200px] h-full py-4">
    <div class="mx-4">
        <select bind:value={selectedId} on:change={onChange} class="h-10 hover:cursor-pointer w-full rounded-md">
            {#await companies}
                <option selected disabled hidden>waiting...</option>
            {:then companies}
                <option selected disabled hidden>select a company</option>
                {#each companies as company}
                    <option value={company.companyId}>{company.companyName}</option>
                {/each}
            {:catch error}
                <option selected disabled hidden>error: {error}</option>
            {/await}
        </select>
    </div>
    <div class="flex flex-col justify-center h-full -mt-10">
        <a class="hover:brightness-125 bg-emerald-700 py-8 text-lg px-4" href="/add">Add Item</a>
        <a class="hover:brightness-125 bg-emerald-700 py-8 text-lg px-4" href="/view">View Items</a>
    </div>
</nav>
