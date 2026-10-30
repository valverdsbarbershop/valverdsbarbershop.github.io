// v22: descarta o cache da v21, que guardou páginas no lugar de fotos durante o
// loop de redirecionamento do domínio (30/10/2026).
const CACHE_NAME = 'valverds-cache-v22';

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

  // Tudo revalida com o servidor (ETag), ignorando o cache HTTP do navegador:
  // páginas aparecem atualizadas na hora, e um redirecionamento antigo guardado
  // pelo navegador não continua trocando uma foto por outra coisa.
  const network = fetch(req.url, { cache: 'no-cache', credentials: 'same-origin' });

  e.respondWith(
    network
      .then((res) => {
        // Só guarda resposta direta: se veio de redirecionamento, pode ser outra página
        if (res && res.status === 200 && !res.redirected) {
          const resClone = res.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put(req, resClone));
        }
        return res;
      })
      .catch(() => caches.match(req))
  );
});
