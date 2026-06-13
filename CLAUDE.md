# pit38 — Kalkulator PIT-38 (podatek giełdowy)

> Plan 30-min kroków: `../plan-dochodu/LANCUCH-30MIN-PIT38.html`. Spec budowy: `../plan-dochodu/SPEC-KALKULATOR-PIT38.html`.
> Kontekst nadrzędny: `../CLAUDE.md`.

## Co to jest
Kalkulator podatku PIT-38 (zyski kapitałowe) dla **polskich inwestorów z zagranicznymi brokerami** (Trading212, IBKR, Revolut — które NIE wystawiają PIT-8C). Pomysł z własnego portfela użytkownika (sam płaci za kalkulatorgieldowy.pl).
- **Faza 1 (teraz, pet project):** policzyć WŁASNY PIT-38 (Trading212 + XTB), przestać płacić. Pierwsza skończona+wydana rzecz.
- **Faza 2 (później, dochód):** produkt dla złożonego inwestora multi-broker. Klin = konsolidacja T212+IBKR+Revolut, opcje/crypto, auto-strata. NIE „taniej dla małych".

## Stack
- **Rails 8.1.3** + **inertia_rails 3.21.2** + **Vue 3** + **Vite** (vite_rails). SQLite. Ruby 3.4.4.
- Wybór: użytkownik chciał inertia_rails + Nuxt3, ale to się nie łączy (Inertia nie ma adaptera na Nuxt) → ustalono **Inertia + Vue** (jego umiejętności Nuxt/Vue wchodzą 1:1).
- **Ruby 4.0.5** zainstalowane i ustawione dla pit38 (`.ruby-version` = 4.0.5), `bundle install` czysty, zweryfikowane (`ruby -v` → 4.0.5, `rails -v` → 8.1.3). (ruby-build trzeba było zaktualizować: `git -C ~/.rbenv/plugins/ruby-build pull`.)
- Uruchamianie: `bin/dev` → web na **localhost:3000** (wymuszone w `Procfile.dev`: `bin/rails s -p 3000`; w env usera jest `PORT=3100`, ale `-p` nadpisuje to tylko dla pit38). Vite na :3036.

## Architektura SEO (kluczowe — to jest kanał dystrybucji)
Dystrybucja = **Google SEO na polskie frazy podatkowe** („kalkulator PIT-38", „PIT-38 IBKR/Trading212", „rozliczenie krypto PIT-38"), sezon luty–kwiecień.
- **Strony SEO/landingi/poradniki → zwykłe Rails ERB** (serwerowy HTML, idealny pod Google). NIE przez Inertia.
- **Kalkulator (interaktywny) → Inertia + Vue.** Tu SEO nie ma znaczenia.
- Inertia MA tryb SSR (osobny Node), ale do SEO NIEpotrzebny — nie komplikuj.

## Silnik podatkowy (MUSI być poprawny + OTESTOWANY — to jedyne miejsce, gdzie nie pomijamy testów)
- 19% liniowo. Dochód = Σ(sprzedaż PLN) − Σ(koszt+prowizje PLN).
- **FIFO** (art. 24 ust. 10): sprzedaż = najwcześniej nabyte; każda partia ma własny kurs.
- **Kurs NBP mid (Tabela A) z dnia roboczego POPRZEDZAJĄCEGO** każde zdarzenie (T-1, art. 11a) — kupno/sprzedaż/prowizja/dywidenda osobno. NIE kurs brokera.
- **Dywidendy:** sekcja G, 19% od brutto PLN − kredyt podatku u źródła = min(zapłacony, stawka traktatowa, 19%). USA W-8BEN: dopłata ~4%. Nie netuje się ze stratą.
- Strata: 5 lat, 50%/rok lub jednorazowo do 5 mln zł. Pola: PIT-38 C/D/G + PIT/ZG per kraj (numery pól z broszury MF na dany rok — nie hardkoduj).
- **NBP API:** `GET https://api.nbp.pl/api/exchangerates/rates/a/{code}/{date}/?format=json` → rates[0].mid. 404 w weekend/święto → cofaj się o dzień. Limit 93 dni/zapytanie. Cache lokalnie.

## Brokery (wejście danych)
- **Trading212:** eksport CSV (Menu>History>Export, max 12 mies/plik) LUB API (docs.trading212.com, beta, klucz+sekret, 6 req/min/konto, endpoint CSV export najodporniejszy). Tickery `AAPL_US_EQ` → mapuj.
- **XTB:** API MARTWE (wyłączone 2025-03-14). Ścieżka: ręcznie pobrać PIT-8C (Portal Inwestora, ~15-25 lutego; liczy zyski kapit. za Ciebie) + osobny „Raport dywidendy zagraniczne".
- **IBKR (Faza 2):** Flex Query CSV/XML (Trades + CashTransactions), max 365 dni/eksport. **Revolut:** tylko PDF (parsery PDF→CSV; FIFO odtwarzać).

## Open-source do FORKU (nie pisz FIFO/NBP/dywidend od zera)
- **Pitly** (github.com/volodymyr-kovtun/pitly, MIT, C#) — emituje pola PIT-38. **pbialon/pit-38** (MIT, Python) — wzorzec parserów + Revolut. **kloPIT** (AGPL — tylko STUDIUJ, copyleft).

## Autonomia złożenia (e-Deklaracje)
- Faza 1 (własne konto): PEŁNE auto-złożenie — XML PIT-38 + podpis **danymi autoryzującymi** (PESEL + przychód z zeszłego PIT-38) → bramka SOAP `bramka.e-deklaracje.mf.gov.pl`. XSD w crd.gov.pl.
- Faza 2 (dla innych): sufit = „wygeneruj gotowy XML, user wysyła sam" (UPL-1 wymaga imiennej osoby fiz.; RODO za cudze klucze).

## Marketing (Faza 2, lekcje z Filipa Kowalskiego)
Konkuruj w istniejącym rynku (konkurenci = dowód popytu), wygraj kanał intencyjny (Google SEO PL), free-then-monetize, mapuj setki fraz ZANIM rozbudujesz, cierpliwość 3-6 mies. na ranking (pasywność z TYŁU). Monetyzacja lekka (one-time/sezonowy unlock lub reklamy — nie ciężki abonament; to narzędzie raz w roku). Konkurent darmowy: NaGieldach.pl (robi e-Deklaracje XML) — bij go na złożonym inwestorze, nie ceną.

## Książki referencyjne (PDF) — `/Users/arkadiuszkarwasz/Documents/Książki/`
**ZASADA STAŁA (życzenie użytkownika) — wspólna nauka w obie strony:**
1. Pracując nad kodem, ZANIM zaproponujesz rozwiązanie, **przeczytaj odpowiednią sekcję** (głównie Sustainable Rails / Layered Design / Polished Ruby) i zastosuj jej konwencje. Nie improwizuj.
2. **Po przeczytaniu — POWIEDZ użytkownikowi, co przeczytałeś** (książka + rozdział/sekcja), żeby mógł przeczytać to samo i poszerzyć horyzonty.
3. Na każdym kroku **ZLECAJ użytkownikowi przeczytanie odpowiednich sekcji z https://guides.rubyonrails.org/** (z konkretnym URL), żeby aktywnie uczestniczył w developmencie i się uczył.
Nie wczytuj całych PDF-ów (duże). Mapowanie pod ten projekt:
- **Sustainable Web Development with Ruby on Rails** (Copeland) → domyślne źródło decyzji architektonicznych/konwencji pit38 (struktura, utrzymywalność).
- **layered_design_for_ruby_on_rails_applications** → gdzie umieścić logikę (silnik podatkowy jako warstwa/serwis, nie w modelu/kontrolerze).
- **polished-ruby-programming** (Jeremy Evans) → idiomatyczny, czytelny Ruby (silnik FIFO/NBP/dywidendy).
- **Metaprogramming Ruby** → tylko gdy realnie potrzebne (rzadko).
- **Bezpieczenstwo_aplikacji_webowych** → bezpieczeństwo danych finansowych (szczeg. Faza 2 + RODO za cudze klucze brokerów).
- **algorytmy (Sysło / Wróblewski)** → ogólne; ewentualnie przy FIFO/strukturach danych.

## Następny krok
Krok 2 łańcucha: `bin/dev` → zobacz stronę Vue (localhost:3100). Potem krok 3: model `Transaction` (broker, typ, data, ticker, ilość, cena, waluta, prowizja).
