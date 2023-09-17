import { writable } from 'svelte/store';
import type Session from './models/session.model';
import type Company from './models/company.model';

function createSession() {
    const { subscribe, update, set } = writable<Session>({
        companyName: "",
        companyId: ""
    })

    return {
        subscribe,
        setCompanyName: (newName: string) => update((curSession: Session) => {
            curSession.companyName = newName;
            return curSession;
        }),
        setCompanyId: (newId: string) => update((curSession: Session) => {
            curSession.companyId = newId;
            return curSession;
        }),
        setCompany: (newCompany: Company) => update((curSession: Session) => {
            curSession.companyId = newCompany.companyId;
            curSession.companyName = newCompany.companyName;
            return curSession;
        }),
        set
    }
}

export const session = createSession();