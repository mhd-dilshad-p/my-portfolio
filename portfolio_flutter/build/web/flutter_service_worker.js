'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "e36dc139554426f2364d98e680248521",
"version.json": "7804eb643eb875d188221832d4ff86c5",
"index.html": "c8cb76843f2baf9cc6e0789eefc52347",
"/": "c8cb76843f2baf9cc6e0789eefc52347",
"profile_photo.jpg": "ca6e7d3221d096b89a1fa9dfb1ac6052",
"main.dart.js": "f68b3605499e47506e170ba2e0d81112",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"favicon.png": "0d5ba96242ddba274ac8158c99503996",
"icons/Icon-192.png": "402269f0e87c520211e0689b682eb5a5",
"icons/Icon-maskable-192.png": "402269f0e87c520211e0689b682eb5a5",
"icons/Icon-maskable-512.png": "dbd0246b2c2788997c258032b77a25f5",
"icons/Icon-512.png": "dbd0246b2c2788997c258032b77a25f5",
"manifest.json": "f5ff11a140ff6b061c1efe897c3f2591",
"sitemap.xml": "58a9d044d18af4835437654f1bc60451",
"robots.txt": "9887106ebe6fafeca3cfc22b35fd1d4e",
"assets/NOTICES": "f7b8ee983454e930f951c18e767fdeb8",
"assets/FontManifest.json": "c75f7af11fb9919e042ad2ee704db319",
"assets/AssetManifest.bin.json": "74ab070537933ff9d1a927cc33226cbf",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Regular-400.otf": "f04ca8ea88447b42643b489f5d85807b",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Brands-Regular-400.otf": "e8eee15c6a8aca61277d329741c23829",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Solid-900.otf": "14198ae6516011921e6d778ed6920946",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/AssetManifest.bin": "589e7394e88cb5855f422f257708750f",
"assets/fonts/MaterialIcons-Regular.otf": "98edb167a7110884e8f2eca24ce56364",
"assets/assets/screenshots/Alizo/homeincustomer.jpeg": "c51223c91a43ea971951f6fd491ed20e",
"assets/assets/screenshots/Alizo/splash.jpeg": "4da2c5c7bc417d928e1ccfc7034e9d3a",
"assets/assets/screenshots/Nadodi/splashnadodi.jpeg": "bb42fd343dc3f822082cacdfad5cff4a",
"assets/assets/screenshots/Nadodi/nadodihome.jpeg": "aeae51e34f0d51e444f28356a87ad74a",
"assets/assets/screenshots/Nadodi/flightbooking.jpeg": "ddebe3d3d4a89123e489c2f50a81ec8e",
"assets/assets/screenshots/FuelDost/expenceandhistory.jpeg": "c5f20325f8b4a5adf7d134c3bae6bf09",
"assets/assets/screenshots/FuelDost/home1.jpeg": "809a40e43e888859cfec4e61948972ee",
"assets/assets/screenshots/FuelDost/insights.jpeg": "ea31522b4696095990ddfc9428b2c268",
"assets/assets/screenshots/FuelDost/home2.jpeg": "a457f3106caab6f986821160c8db16f4",
"assets/assets/images/nadodi_logo.jpg": "b6113131c7e843628ee7cba8d0f2c40e",
"assets/assets/images/humanities.jpeg": "4ff6efda1cdd0a9b7ab67ca45687a8f3",
"assets/assets/images/profile_photo.jpg": "ca6e7d3221d096b89a1fa9dfb1ac6052",
"assets/assets/images/ALIZO-removebg.png": "f26831df2de100b20e1265f4bd6adc7d",
"assets/assets/images/fuel_dost_logo.png": "f71ee211cec999b0597efa8997e10992",
"assets/assets/images/Social%2520work.jpeg": "c3a339dbf4a79cb5e4e55dbe6e31fba4",
"assets/assets/images/profile_logo.jpg": "c490bcd68e64323bb3375dbd8df4ed09",
"assets/assets/images/adam_logo.png": "ef8af274f99786ac7b2033e5852b09ec",
"assets/assets/images/long_logo.jpeg": "68ee513e8141b1fc063c51f5764af3cf",
"assets/assets/images/flutterdeveloper.jpeg": "a8484a40d09335ab0b0417d109dc2fec",
"assets/assets/images/alizo_logo.png": "7880aebe9c0a41ec6c84f6d2da7d20c5",
"assets/assets/images/screen2image.png": "ed6ef59561a64a3d7ae1f5689c6929f5",
"assets/assets/icons/flutter.png": "4262c71228b7aa391e995fe5f1d57795",
"assets/assets/icons/GitHub.png": "e94e583c9cf89d228743c2d715ca287c",
"assets/assets/icons/firebase.png": "0e8789d152ed2744d7f7265dc3f1457e",
"assets/assets/icons/supabase.png": "8e6477a71c0ec4ab5ee01de766296af7",
"assets/assets/icons/android.png": "8a1f4e0b598a703e133338f398187b44",
"assets/assets/icons/call.json": "029a229d535b09313215a789bdc9c58d",
"assets/assets/icons/apple.png": "03c3dfea35901d2c28fbc1c69c9e7e54",
"assets/assets/icons/html.png": "397ea3c735d3d1d711bc05089a24fa7f",
"assets/assets/icons/apple-logo.png": "4f658b9a7d067de5238644b78d8d09cc",
"assets/assets/icons/email.json": "2040ecdf17ff5ac461c421d2966da8bc",
"assets/assets/icons/firebse_logo_+_text.png": "4b71efae027ec8675907eac066aa793a",
"assets/assets/icons/dart.png": "b96cb5023a5dd284d44013bd5811e842",
"assets/assets/icons/linkedin.json": "2ef64aee0455f486c760b0678ee9562f",
"assets/assets/icons/dart_logo_+_text.png": "4f42ff5cc85ea5ae5c16b49758b2cdf3",
"assets/assets/cv/mohammed_dilshad_p.pdf": "79611b755146d958b5e67ee83e981aa6",
"favicon.svg": "12d4c26c65e2abbf0816457467d9b69f",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
