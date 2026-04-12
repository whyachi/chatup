# ChatUp Fork — Claude Notları

Bu depo Chatwoot'un bir fork'udur ve **ChatUp** adıyla SaaS olarak sunulmaktadır.
Genel Chatwoot geliştirme kuralları için [AGENTS.md](AGENTS.md) dosyasına bakın.
Bu dosya sadece fork'a özgü kuralları ve ChatUp modül mimarisini içerir.

## Fork Durumu

- **Repo:** `github.com/whyachi/chatup`, aktif branch: `rebrand`
- **Canlı:** `chatup.whyachikovacs.com` (Hetzner `157.90.117.106`, Docker Compose)
- **Sunucu repo yolu:** `/opt/chatup/chatwoot`
- **Geliştirme akışı:** Lokalde geliştir → `git push origin rebrand` → sunucuda `git pull && docker compose build && docker compose up -d && docker compose exec web bundle exec rails db:migrate`

## ChatUp Modül Mimarisi

ChatUp, Chatwoot üstüne **müşteri bazlı açılıp kapatılabilen** özel modüller (Portfolyö, Video Otomasyon vb.) ekler. Her modül sol sidebar'da ayrı bir sekmedir ve Super Admin'den feature flag ile kontrol edilir.

**Kurallar:**

1. **Namespace:** Backend kodu `enterprise/app/.../chatup/` altına, frontend kodu `app/javascript/dashboard/routes/dashboard/chatup-modules/<modul>/` altına yazılır. Upstream merge'lerde çakışmayı en aza indirir.
2. **Feature flag prefix'i:** Tüm ChatUp flag'leri `chatup_` ile başlar (`chatup_portfolio`, `chatup_video_automation` vb.). `config/features.yml`'ye `chatup: true` alanıyla işaretlenir.
3. **Sidebar entegrasyonu:** Yeni modül eklerken sadece [app/javascript/dashboard/components-next/sidebar/Sidebar.vue](app/javascript/dashboard/components-next/sidebar/Sidebar.vue) `menuItems` computed property'sine tek satır eklenir. Bu dosya upstream merge'de çakışma yaşanabilecek **tek ciddi** dosyadır — her zaman listenin sonuna eklenir ki merge kolay olsun.
4. **Super Admin UI:** `config/features.yml`'ye flag eklenince Super Admin → Accounts → Features bölümünde otomatik checkbox çıkar, ek UI kodu gerekmez. Her müşteride istenen modüller buradan açılır/kapanır.
5. **Route meta:** Vue route tanımlarında `meta.featureFlag: FEATURE_FLAGS.CHATUP_<NAME>` kullanılır. Feature kapalıysa sidebar sekmesi otomatik gizlenir — ek `v-if` gerekmez.

## Yeni ChatUp Modülü Ekleme — Dosya Şablonu

Referans: boilerplate modülü (`chatup_boilerplate`).

**Oluşturulacak:**
- `enterprise/app/models/enterprise/chatup/<model>.rb`
- `enterprise/app/controllers/api/v2/accounts/chatup/<name>_controller.rb`
- `enterprise/app/policies/chatup/<name>_policy.rb`
- `db/migrate/..._create_chatup_<name>.rb`
- `app/javascript/dashboard/routes/dashboard/chatup-modules/<name>/Index.vue`
- `app/javascript/dashboard/routes/dashboard/chatup-modules/<name>/<name>.routes.js`
- `app/javascript/dashboard/store/modules/chatup/<name>.js`
- `app/javascript/dashboard/api/chatup/<name>.js`

**Değiştirilecek (küçük eklemeler):**
- `config/features.yml` (yeni flag)
- `app/javascript/dashboard/featureFlags.js` (enum)
- `config/routes.rb` (API route)
- `app/javascript/dashboard/routes/dashboard/chatup-modules/index.js` (aggregator)
- `app/javascript/dashboard/components-next/sidebar/Sidebar.vue` (menuItems)
- `app/javascript/dashboard/i18n/locale/en/*.json` (i18n)

## Rebrand Notu

Marka dosyaları zaten ayarlanmıştır: `config/brand.yml`, `config/initializers/brand.rb`, `theme/colors.js`, `public/brand-assets/`. Yeni modül eklerken string'lerde "Chatwoot" yerine marka-agnostik metin kullanın veya `shared/composables/useBranding`'deki `replaceInstallationName`'i tercih edin.
