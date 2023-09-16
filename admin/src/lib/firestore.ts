import type { FirebaseApp, FirebaseOptions } from 'firebase/app';
import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';

const firebaseConfig: FirebaseOptions = {
    apiKey: 'AIzaSyBynYnOmCAtDtluLaONM4FP4opJEgKnOxM',
    authDomain: 'calorimeter-a3a91.firebaseapp.com',
    projectId: 'calorimeter-a3a91',
    storageBucket: 'calorimeter-a3a91.appspot.com',
    messagingSenderId: '1018180009414',
    appId: '1:1018180009414:web:95b6deb7f0c387f74d46c7',
    measurementId: 'G-90WB57X2PE'
};

const app: FirebaseApp = initializeApp(firebaseConfig);
const db = getFirestore(app);

export { db };
