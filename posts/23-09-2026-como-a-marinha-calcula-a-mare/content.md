A tábua de maré que você recebe pela Tábua de Marés API não foi medida: foi calculada. O cálculo começa numa estação maregráfica que passou anos registrando o nível do mar num ponto da costa. No Brasil, quem faz isso é o Centro de Hidrografia da Marinha.

## Um dia de tábua

Esta é a tábua de hoje, 23 de setembro de 2026, no Porto de Cabedelo, na Paraíba:

| Hora | Altura | Virada |
| --- | --- | --- |
| 02:04 | 2,15 m | preia-mar |
| 08:21 | 0,52 m | baixa-mar |
| 14:34 | 2,14 m | preia-mar |
| 20:27 | 0,55 m | baixa-mar |

Nenhum desses quatro horários foi observado. Todos saíram de um cálculo.

## De onde vem o número

A publicação oficial do CHM diz que as previsões "são geradas a partir das componentes harmônicas obtidas das observações realizadas por diversas instituições". Componente harmônica é uma onda com período definido pela astronomia. O que muda de porto para porto é como cada onda chega, e isso cabe em duas constantes: amplitude e fase.

Tirar essas constantes de anos de medição é o trabalho da Análise Harmônica, na formulação do Vice-Almirante (Ref) Alberto dos Santos Franco. O nível médio do porto, que aparece no cabeçalho de cada tábua, sai daí: 1,34 m em Cabedelo.

As alturas partem do nível de redução, "um plano tão baixo que a maré, em condições normais, não fique abaixo dele". Em Itaqui, a água já variou 6,83 m dentro do mesmo dia.

![Entrada do Porto do Itaqui, no Maranhão, vista do mar](https://raw.githubusercontent.com/Ddiidev/tabua-mare-api-blog/refs/heads/main/posts/23-09-2026-como-a-marinha-calcula-a-mare/assets/porto-do-itaqui.jpg)

*Entrada do Porto do Itaqui, no Maranhão, onde a maré já variou 6,83 m dentro de um mesmo dia. Foto: [Luiz Felipe Sousa Oliveira / Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Porto_do_Itaqui.jpg), em domínio público.*

## O que a previsão não vê

A tábua é maré astronômica. Vento forte e pressão baixa também mexem no nível do mar e, como registra o próprio CHM, "não podem ser previstos harmonicamente". Em dia de frente fria, a água chega onde a tabela não previu.

## Como consultar

A Tábuas das Marés sai uma vez por ano, em PDF, pela Marinha. A Tábua de Marés API transforma esse material em dado consultável, sem cadastro, pelo [site](https://tabuamare.api.br) ou por uma chamada:

```bash
curl "https://tabuamare.api.br/api/v2/tabua-mare/pb01/9/[23]"
```

A resposta traz a carta náutica, a instituição que mediu e as horas e alturas do dia na mesma consulta. Documentação e playground em [tabuamare.api.br/docs](https://tabuamare.api.br/docs).

![Barcos atracados no Porto de Cabedelo, na Paraíba](https://raw.githubusercontent.com/Ddiidev/tabua-mare-api-blog/refs/heads/main/posts/23-09-2026-como-a-marinha-calcula-a-mare/assets/barra-de-porto.jpg)

*Barcos atracados no Porto de Cabedelo, na Paraíba, o porto usado como exemplo. Foto: [José Rafael Mendes Barbosa / Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Porto_de_Cabedelo_e_seus_barcos.jpg), CC BY-SA 3.0.*

Obrigado por ler.
