const CACHE_NAME = 'valverds-cache-v21';

self.addEventListener('install', (e) => {
  self.skipWaiting();
});

self.addEventListener('activate', (e) => {
  e.waitUntil(
    caches.keys().then((keys) => Promise.all(
      keys.map((k) => {
        if (k !== CACHE_NAME) return caches.delete(k);
      })
    )).then(() => self.clients.claim())
  );
});

// Estrategia Network-First: atualizacoes no GitHub aparecem ao abrir ou recarregar o site.
// O cache do service worker so e usado quando a rede falha (modo offline).
self.addEventListener('fetch', (e) => {
  const req = e.request;
  if (req.method !== 'GET') return;

  const url = new URL(req.url);
  if (url.origin !== self.location.origin) return; // so arquivos do proprio site

  // Paginas e o proprio HTML sempre revalidam com o servidor, ignorando o cache
  // HTTP do navegador (o GitHub Pages manda guardar por 10 minutos).
  const isPage = req.mode === 'navigate' || url.pathname.endsWith('.html') || url.pathname.endsWith('/');
  const network = isPage
    ? fetch(req.url, { cache: 'no-cache', credentials: 'same-origin' })
    : fetch(req);

  e.respondWith(
    network
      .then((res) => {
        if (res && res.status === 200) {
          const resClone = res.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put(req, resClone));
        }
        return res;
      })
      .catch(() => caches.match(req))
  );
});
