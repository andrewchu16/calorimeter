<script>
    import '../app.css';
    import Navigation from '../components/Navigation.svelte';
</script>

<div class="flex w-screen h-screen">
    <Navigation />
    <main class="w-full h-full">
        <slot />
    </main>
</div>
