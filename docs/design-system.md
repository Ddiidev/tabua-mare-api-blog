# Sistema visual — Blog Tábua de Maré API

## Propósito

Blog editorial sobre maré, código e litoral brasileiro. A interface combina leitura calma, sinais técnicos discretos e o vocabulário visual marítimo da API.

## Princípios

- Conteúdo é o elemento principal; controles e ornamentos ficam em segundo plano.
- A leitura alterna tipografia editorial com metadados técnicos compactos.
- Bordas, raios e sombras são suaves; amarelo é reservado para destaque e ação.
- Movimento apenas indica continuidade ou posição de rolagem e respeita `prefers-reduced-motion`.

## Tokens

| Uso | Token | Valor |
| --- | --- | --- |
| Oceano escuro | `--ocean-950` | `#082f49` |
| Oceano | `--ocean-800` | `#0c4a6e` |
| Ciano | `--ocean-600` | `#0891b2` |
| Sol | `--sun-400` | `#f9c74f` |
| Fundo | `--foam-50` | `#f7faf9` |
| Superfície | `--surface` | `#fff` |
| Linha | `--line` | `#cfe3e8` |
| Texto | `--text` | `#102a37` |
| Texto secundário | `--muted` | `#58717c` |

Espaçamentos-base: `--spacing-xs` `.25rem`, `--spacing-sm` `.5rem`, `--spacing-md` `1rem`, `--spacing-xl` `2rem` e `--spacing-2xl` `3rem`.

## Tipografia e conteúdo

- Interface e texto corrido: `IBM Plex Sans` com fallbacks de sistema.
- Títulos, marca e cards editoriais: `Georgia, Spectral, serif`, com tracking negativo moderado.
- Metadados, rotas e código: `Kode Mono` ou monoespaçada do sistema.
- Letras maiúsculas e espaçadas identificam categoria, data e rótulos técnicos; nunca substituem título ou texto corrido.

## Componentes

- Navbar: fundo `--ocean-950`, fixa, borda inferior clara e sombra discreta. Altura mínima de `72px` no desktop e `64px` até `640px`.
- Badge `Blog`: cápsula monoespaçada, borda translúcida e texto `--sun-400`; é o mesmo padrão usado no rodapé.
- Botões e links: ciano para ações regulares; amarelo para ação prioritária. Controles de compartilhamento usam quadrados arredondados com borda colorida.
- Cards e blocos de código: superfície clara, borda `--line` e raios moderados. Código mantém fundo oceano e tipografia monoespaçada.
- Rodapé: oceano escuro, links organizados em grupos de conteúdo e o mesmo badge da navbar.

## Rolagem e movimento

- `scroll-behavior: smooth` é o comportamento normal; movimento reduzido remove transições não essenciais.
- Seções com `data-scroll-fade` entram discretamente no viewport sem ocultar conteúdo quando JavaScript não existe.
- Blocos de código horizontais recebem máscara nas extremidades apenas quando há overflow.
- A vinheta vertical do conteúdo não tem fade lateral. Ela mede entre `2rem` e `3.5rem`, aparece no topo somente após `24px` de rolagem e some nas extremidades correspondentes.
- A vinheta superior começa exatamente depois da navbar: `72px` no desktop e `64px` no mobile.

## Responsividade e acessibilidade

- Até `640px`, a navegação reduz para `64px`, a marca diminui e o conteúdo ganha espaçamento vertical mais contido.
- Grades viram uma coluna; ações e compartilhamento podem ocupar a largura disponível sem overflow horizontal.
- Camadas de vinheta não recebem eventos de ponteiro e permanecem abaixo da navbar fixa.
- Links, botões e menu mantêm foco visível e áreas de toque adequadas.

## Registro de iteração

- 2026-09-11: documentadas as regras já implementadas de leitura editorial, compartilhamento, rolagem e vinheta responsiva.
