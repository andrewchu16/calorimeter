<script lang="ts">
    import { browser } from '$app/environment';
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
        const company = (await companies).filter((c) => c.companyId === selectedId)[0];
        session.setCompany(company);
    };

    const companies = getCompanies();
</script>

<select
    bind:value={selectedId}
    on:change={onChange}
    class="h-10 hover:cursor-pointer hover:brightness-90 active:brightness-90 w-full rounded-md"
>
    {#await companies}
        <option selected disabled hidden>Loading...</option>
    {:then companies}
        <option selected disabled hidden>Select Company</option>
        {#each companies as company}
            <option value={company.companyId}>{company.companyName}</option>
        {/each}
    {:catch error}
        <option selected disabled hidden>error: {error}</option>
    {/await}
</select>
