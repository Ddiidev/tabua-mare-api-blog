Se você pesca, navega, surfa, trabalha com turismo ou simplesmente mora perto da praia, a tábua de maré responde perguntas que aparecem todo dia: a que horas a água enche, até onde dá para ir, quando é melhor sair e voltar. O que falta, quase sempre, é uma explicação simples e um jeito fácil de consultar esses números.

A primeira parte explica o que é uma tábua de maré e como ler os dados dela usando um dia real como exemplo. Depois, apresento a Tábua de Marés API, um projeto brasileiro que reúne as tábuas do litoral inteiro e mantém a consulta aberta, sem cadastro. O projeto é mantido por uma pessoa, sem equipe, com um objetivo só: fazer o dado público de maré chegar de fato a quem precisa dele.

## O que é uma tábua de maré

Tábua de maré é uma tabela que informa a hora e a altura da maré em um porto ao longo dos dias. Em vez de dizer apenas que o mar enche de manhã, ela marca o momento exato de cada virada: às 08h06 a água baixou para 0,67 metro, às 14h17 subiu para 2,17 metros.

Na maioria dos dias aparecem quatro viradas, sendo duas marés altas (preia-mar) e duas marés baixas (baixa-mar). O que a tábua registra é o horário e a altura de cada uma delas.

As alturas são medidas em metros, a partir de uma referência local chamada zero da régua de maré. É por isso que existem registros negativos, como -0,61 m, e registros bem altos, como 6,75 m, dentro da mesma base. Cada porto tem o seu próprio referencial, e comparar números de portos diferentes sem levar isso em conta leva a conclusão errada.

Quem usa isso na rotina:

- Pescador, para planejar a saída, a volta e o ponto onde o peixe corre, porque maré vazando e maré enchendo mudam o comportamento do cardume.
- Quem sai de barco, para entrar e sair da barra com água sobrando embaixo da quilha.
- Surfista, para saber como a onda se comporta entre maré cheia e maré seca.
- Barraca, passeio, aula e aluguel na praia, para dimensionar equipe conforme o movimento da água.
- Coleta de marisco, limpeza de praia, retirada de barco da água e obra na orla, que dependem da maré baixa.
- Fotografia e drone, para escolher o horário em que o banco de areia aparece e a água fica rasa.

![Praia com faixa de areia exposta na maré baixa e barco de pesca apoiado na areia](https://raw.githubusercontent.com/Ddiidev/tabua-mare-api-blog/refs/heads/main/posts/16-09-2026-oque-e-tabua-de-mare-api/assets/mare-baixa.jpg)

*Maré baixa descobrindo a faixa de areia. Imagem ilustrativa gerada com IA para este artigo.*

## Como ler uma tábua de maré

Uso como exemplo a tábua do Porto de Cabedelo, na Paraíba, no dia 15 de março de 2026, um domingo:

| Hora | Altura | O que aconteceu |
| --- | --- | --- |
| 02:10 | 1,99 m | preia-mar |
| 08:06 | 0,67 m | baixa-mar |
| 14:17 | 2,17 m | preia-mar |
| 20:34 | 0,45 m | baixa-mar |

Três leituras saem desse dia:

1. A diferença entre a maior e a menor altura é a amplitude. Ali, 2,17 menos 0,45 dá 1,72 metro de variação. Amplitude grande é dia de maré forte, com correnteza mais perceptível perto de canal, rio e barra.
2. As viradas acontecem em intervalos de pouco mais de seis horas. Da alta das 02:10 até a baixa das 08:06 passaram 5h56. Da baixa das 08:06 até a alta das 14:17, 6h11.
3. A maré atrasa a cada dia. Em 16 de março a primeira alta aconteceu às 02:49, quase quarenta minutos mais tarde. Em 17 de março, às 03:25. Quem pesca ou trabalha na praia sabe que o horário de ontem não serve para hoje.

![Mãos segurando uma tábua de maré impressa na beira da praia](https://raw.githubusercontent.com/Ddiidev/tabua-mare-api-blog/refs/heads/main/posts/16-09-2026-oque-e-tabua-de-mare-api/assets/tabua-impressa.jpg)

*Tábua impressa na mão, do jeito que muita gente ainda consulta. Imagem ilustrativa gerada com IA para este artigo.*

## Por que a maré sobe e desce

A maré é a resposta do oceano à atração gravitacional da Lua e do Sol, combinada com a rotação da Terra. A Lua é bem menor, mas está muito mais perto, então é ela que dá o ritmo.

Quando Sol, Terra e Lua se alinham, na lua nova e na lua cheia, as forças se somam e a maré cresce. É a maré de sizígia, a "maré grande" das conversas de praia. Quando a Lua está em quarto, as forças se compensam em parte e a variação diminui, na maré de quadratura.

A tábua é previsão, não medição. Ela considera a astronomia, e na prática a água responde também ao vento e à pressão. Vento forte empurrando água contra a costa adianta e aumenta a maré. Pressão baixa ajuda a água a subir. Molhe, obra e relevo da praia mudam o resultado naquele ponto. Em dia de vento encostado e chuva forte, a água chega onde a tábua não previu.

## A tábua oficial brasileira é pública

As tábuas de maré no Brasil são publicadas pela Marinha, pelo Centro de Hidrografia da Marinha (CHM), todos os anos, com portos ao longo de toda a costa. O dado é público e pode ser consultado por qualquer pessoa:

- [Tábuas de maré do CHM](https://www.marinha.mil.br/chm/tabuas-de-mare)
- [Mapa de dados de maré](https://www.marinha.mil.br/chm/dados-do-segnav/dados-de-mare-mapa)

O que a Tábua de Marés API faz é pegar esse material, que é publicado em formato voltado para leitura humana, e organizar por estado, porto, mês e dia, de um jeito que tanto uma pessoa quanto um programa conseguem consultar.

Hoje a base reúne 58 portos nos 17 estados costeiros, com 1.344 meses de tábua, 40.992 dias e 171.151 registros de hora e altura, referentes a 2025 e 2026.

O comportamento da maré muda muito de uma região para outra. A altura média das marés registradas no Rio Grande do Sul fica em torno de 0,22 m, enquanto no Maranhão passa de 2,97 m. As maiores variações diárias do país estão em portos maranhenses: no Porto de Itaqui, a maré chega a variar 6,83 m dentro do mesmo dia. Tratar o litoral brasileiro como se fosse uniforme não funciona.

![Navio cargueiro atracado em porto brasileiro no fim da tarde](https://raw.githubusercontent.com/Ddiidev/tabua-mare-api-blog/refs/heads/main/posts/16-09-2026-oque-e-tabua-de-mare-api/assets/porto.jpg)

*Porto, canal e barra têm régua própria e pedem mais precisão do que a areia da praia. Imagem ilustrativa gerada com IA para este artigo.*

## Como consultar

A documentação está em [tabuamare.api.br/docs](https://tabuamare.api.br/docs), com todos os endpoints, exemplos de resposta e um playground para testar direto no navegador, sem cadastro.

Um exemplo real, com a tábua do Porto de Cabedelo nos três primeiros dias de janeiro:

```bash
curl "https://tabuamare.api.br/api/v2/tabua-mare/pb01/1/[1,2,3]"
```

A resposta vem em JSON. Este é o recorte do dia 3 de janeiro:

```json
{
  "data": [
    {
      "harbor_name": "PORTO DE CABEDELO (ESTADO DA PARAÍBA)",
      "state": "pb",
      "timezone": "UTC -03.0",
      "mean_level": 1.34,
      "months": [
        {
          "month_name": "Janeiro",
          "month": 1,
          "days": [
            {
              "weekday_name": "sábado",
              "day": 3,
              "hours": [
                { "hour": "04:14:00", "level": 2.25 },
                { "hour": "10:10:00", "level": 0.18 },
                { "hour": "16:29:00", "level": 2.41 },
                { "hour": "22:46:00", "level": -0.05 }
              ]
            }
          ]
        }
      ]
    }
  ],
  "total": 1
}
```

O campo `mean_level` mostra o nível médio daquele porto, 1,34 m em Cabedelo. É em volta desse valor que a água sobe e desce. Repare também no último horário do dia, com altura negativa: é dado normal, porque a régua do porto é que define o zero.

Quem trabalha com código e prefere não montar a chamada na mão tem SDKs oficiais, mantidos no repositório [sdks-tabua-mare](https://github.com/Ddiidev/sdks-tabua-mare):

| Linguagem | Pacote | Instalação |
| --- | --- | --- |
| <img src="https://cdn.simpleicons.org/javascript/102a37" width="16" height="16" alt="" /> JavaScript e TypeScript | [tabua-mare-sdk](https://www.npmjs.com/package/tabua-mare-sdk) | `npm install tabua-mare-sdk` |
| <img src="https://cdn.simpleicons.org/go/102a37" width="16" height="16" alt="" /> Go | [tabua-mare-sdk-go](https://pkg.go.dev/github.com/Ddiidev/sdks-tabua-mare/tabua-mare-sdk-go) | `go get github.com/Ddiidev/sdks-tabua-mare/tabua-mare-sdk-go` |
| <img src="https://cdn.simpleicons.org/dotnet/102a37" width="16" height="16" alt="" /> C# e .NET | [TabuaMare.SDK](https://www.nuget.org/packages/TabuaMare.SDK/) | `dotnet add package TabuaMare.SDK` |

Sem cadastro, o limite é de 16 requisições por minuto, sem cota mensal. Criando uma conta gratuita, você recebe uma API key que eleva o limite para 24 requisições por minuto e 32 mil por mês.

## Código aberto e banco de dados disponível

O código da API está aberto no GitHub, sob licença MIT. Junto com o código, o projeto distribui o banco de dados com a tábua do ano: você baixa o arquivo, abre no seu programa e consulta os dados localmente, sem depender da API e sem pedir autorização para ninguém. Serve para pesquisa, aplicativo, planilha, sistema interno ou qualquer outra ideia que precise desses números.

**[Acesse o repositório e baixe o código e o banco de dados](https://github.com/Ddiidev/tabua_mare_api)**

<div class="inline-actions">
<a href="https://pt.wikipedia.org/wiki/C%C3%B3digo_aberto" target="_blank" rel="noreferrer" >O que é código aberto? ↝</a>
</div>

Isso aqui é feito por uma pessoa, do começo ao fim. Existe uma empresa por trás do projeto, mas é empresa de uma pessoa só: sem equipe, sem plantão para dividir. Quem escreve o código é quem responde a issue, atualiza o dado e cuida da máquina. O motivo é simples. Dado de maré é informação que muita gente precisa e quase ninguém consegue usar quando ela fica presa num PDF.

## Dificuldades e bastidores

A parte que ninguém vê, quando copia um JSON da API, é o trabalho de arrumar o dado antes dele virar resposta.

**Nome de porto é uma bagunça organizada.** As tábuas trazem o nome oficial completo, com o estado dentro do próprio nome: "PORTO DE NATAL CAPITANIA DOS PORTOS DO RN (ESTADO DO RIO GRANDE DO NORTE)", 73 caracteres para dizer Natal. Tem porto identificado por terminal privado, por ilha, por barra. Padronizar isso, porto por porto, tomou tempo.

**São 25 instituições diferentes medindo.** Aparecem dados do DHN, do CHM, do IBGE, da Petrobras, da CODESA, da SUAPE, da DNPVN e de outras. Cada uma escreve de um jeito, e algumas usam referência própria de nível.

**O fuso horário aparece escrito de formas diferentes.** Na mesma base existe "UTC -03.0", "UTC -02.0" e até "+03.0". Se isso passa batido, quem consulta Fernando de Noronha recebe horário errado. Boa parte do trabalho foi conferir referência de hora antes de publicar qualquer coisa.

**Nem todo dia tem quatro marés na tábua.** Alguns dias aparecem com três registros. Em Cabedelo, em março de 2026, os dias 6 e 12 estão assim. O dado é esse, e o sistema precisa lidar com o caso sem inventar a quarta maré.

**O porto mais próximo nem sempre é o mais óbvio.** Muita gente não sabe o nome do porto, sabe onde está. Descobrir o porto certo por coordenadas exige cuidado com distância e com divisa entre estados, porque o ponto mais próximo pode estar do outro lado da linha.

**A tábua é anual.** Todo ano sai publicação nova e o banco precisa ser atualizado. Hoje estão carregados 2025 e 2026. Não é um projeto que se entrega e deixa parado.

**O volume não é pequeno.** São 171.151 registros de hora e altura para organizar, com cache para não bater no banco a cada consulta. Foi a parte silenciosa do trabalho.

Sobrar para uma pessoa a parte de servidor, deploy, limite de requisições e atualização de dado é o mais pesado. Não tem escala para dividir: quando algo cai de madrugada, é a mesma mão que levanta. A recompensa vem quando alguém usa o dado para decidir se sai para pescar hoje.

## Para fechar

Se maré faz parte do seu dia, comece pelo que já está publicado: [site](https://tabuamare.api.br), [documentação](https://tabuamare.api.br/docs) e [playground](https://tabuamare.api.br/playground). Se o projeto te ajudar, a página de [apoio](https://tabuamare.api.br/apoiar) existe justamente para dividir o custo de manter a máquina no ar.

Encontrou um porto faltando, um horário estranho ou um nome errado? Abre uma issue no [GitHub](https://github.com/Ddiidev/tabua_mare_api). Ficou com dúvida sobre maré, manda nos comentários. Também publico vídeos no [YouTube](https://www.youtube.com/@mais.foco42).

Obrigado por ler até aqui.
