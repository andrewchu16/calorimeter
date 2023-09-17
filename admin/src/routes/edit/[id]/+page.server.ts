import type { PageServerLoad } from './$types';
import { db } from '$lib/firestore';
import { doc, getDoc, type DocumentData } from 'firebase/firestore';
import { redirect } from '@sveltejs/kit';

export const load: PageServerLoad = async ({ params }) => {
    const itemId: string = params.id;

    const docRef = doc(db, 'items', itemId);
    const docSnap = await getDoc(docRef);

    if (!docSnap.exists()) {
        console.log("Document doesn't exist: " + itemId);
        throw redirect(303, "/");
    } else {
        const itemData: DocumentData = docSnap.data();
        const category: string = itemData.category;
        const price: number = itemData.price;
        const fatVal: number = itemData.fat;
        const name: string = itemData.name;
        const proteinVal: number = itemData.protein;
        const sugarVal: number = itemData.sugar;
        const calories: number = itemData.calories;
        const imgURL: string = itemData.imgURL;

        return {
            itemId: itemId,
            category: category,
            price: price,
            fatVal: fatVal,
            name: name,
            proteinVal: proteinVal,
            sugarVal: sugarVal,
            calories: calories,
            imgURL: imgURL
        };
    }
};
