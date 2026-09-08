db.json na raiz do repo, com detalhes sobre os posts do blog.

TODO: mais tarde um banco de dados para armazenar e poder filtrar os posts.
```json
[
    {
        "title": "Tabua Mare API Blog | TESTE",
        "data": "2026-09-07T00:00:00Z",
        "assets-path": "posts/2026-09-07-teste/assets",
        "content-path": "posts/2026-09-07-teste/content.md",
        "slug": "2026-09-07-teste",
        "headline": "Como funciona uma tábua de maré?",
        "image": "posts/2026-09-07-teste/assets/main.png",
        "authors": [
            {
                "type": ["creator", "revisor"],
                "name": "Tabua Mare",
                "email": "tabuamare@example.com",
                "created_at": "2026-09-07T00:00:00Z",
            }
        ]
    }
]
```

Servidor carrega uma vez, grava na memória esse json com expiração de 5 dias.
A cada 5 dias ele baixa o db.json e carrega o conteúdo na memória novamente.

Adicionar JSON-LD no html do blog post, com as informações do db.json, para SEO.

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BlogPosting",
  "headline": "Como funciona uma tábua de maré?",
  "datePublished": "2026-09-07T00:00:00Z",
  "dateModified": "2026-09-07T00:00:00Z",
  "author": {
    "@type": "Person",
    "name": "André Luiz"
  }
}
</script>

Adicionar ao HEAD:

<head>
  <title>Como funciona uma tábua de maré? | Tábua de Maré</title>

  <meta
    name="description"
    content="Entenda como ler a tábua de maré, horários de maré alta e baixa e como utilizar esses dados."
  >

  <link
    rel="canonical"
    href="https://tabuamare.api.br/blog/como-funciona-tabua-de-mare"
  >
</head>

