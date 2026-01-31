const CACHE_NAME = 'kelkaam-mdh-cache-v1';
const ASSETS_TO_CACHE = [
    './',
    'index.html',
    'manifest.json',
    'https://i.postimg.cc/ZKgJNNVz/download-(9).jpg'
];

self.addEventListener('install', (event) => {
    event.waitUntil(
        caches.open(CACHE_NAME).then((cache) => {
            return cache.addAll(ASSETS_TO_CACHE);
        })
    );
});

self.addEventListener('fetch', (event) => {
    event.respondWith(
        caches.match(event.request).then((cachedResponse) => {
            if (cachedResponse) {
                return cachedResponse;
            }
            return fetch(event.request).then((networkResponse) => {
                return caches.open(CACHE_NAME).then((cache) => {
                    // MP3 ഫയലുകൾ ഓട്ടോമാറ്റിക്കായി കാഷെ ചെയ്യുന്നു
                    if (event.request.url.includes('.mp3')) {
                        cache.put(event.request, networkResponse.clone());
                    }
                    return networkResponse;
                });
            });
        })
    );
});