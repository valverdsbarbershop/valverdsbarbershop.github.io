const CACHE_NAME = 'valverds-cache-v1';
const ASSETS = [
  './index.html',
  './manifest.json',
  './logo_valverds_clean.png',
  './luis_valverde.jpg',
  './yago_barber.png',
  './espaco_interior_1.png',
  './espaco_interior_2.png',
  './espaco_real_maps.png',
  './neon_folhagem.jpg'
];

self.addEventListener('install', (e) => {
  e.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(ASSETS)).then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (e) => {
  e.waitUntil(
    caches.keys().then((keys) => Promise.all(
      keys.map((k) => { if (k !== CACHE_NAME) return caches.delete(k); })
    )).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (e) => {
  e.respondWith(
    caches.match(e.request).then((res) => res || fetch(e.request).catch(() => caches.match('./index.html')))
  );
});