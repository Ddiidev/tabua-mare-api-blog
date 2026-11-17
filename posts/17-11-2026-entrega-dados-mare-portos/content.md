Os horários de uma tábua não são leituras ao vivo. O CHM calcula previsões a partir de observações feitas em estações maregráficas.

O nome do porto corresponde a uma estação específica. O cabeçalho da tábua informa suas coordenadas, o fuso e a instituição responsável. A previsão vale para esse ponto, não para cada praia próxima.

## Quem mede e calcula?

Marégrafos registram a variação do nível do mar. As estações podem ser operadas por instituições diferentes; o CHM cita IBGE, Vale, Praticagem de São Paulo e Epagri.

O CHM usa as observações na análise harmônica para calcular os horários e as alturas previstos. A previsão é astronômica; vento e pressão podem alterar o nível observado.

## Quando os dados são enviados?

Não encontrei um calendário único para todas as estações. Para dados de pesquisas autorizadas, o BNDO estabelece prazo de até 12 meses após a coleta, com documentação técnica e ficha de metadados. Esse prazo não define a frequência de envio de cada estação.

O CHM informa que as observações da Ponta da Armação e da Ilha Fiscal são coletadas duas vezes ao mês, com possíveis alterações. É um exemplo específico, não uma regra nacional.

As previsões saem em edições anuais. A edição de 2026 cobre 44 portos, além de ilhas, barras e outros locais. As fontes consultadas não informam uma data única para a entrega dos dados de todos os portos.

## Como esses dados chegam à API

Uso como fonte a [página do CHM com as tábuas de 2026 por porto](https://www.marinha.mil.br/chm/tabuas-de-mare-6). Organizo os dados desses PDFs no [repositório da API](https://github.com/Ddiidev/tabua_mare_api), onde também está disponível o [banco SQLite `taubinha.sqlite`](https://github.com/Ddiidev/tabua_mare_api/blob/main/taubinha.sqlite) para download.

Na API, os dados podem ser consultados por porto, mês e dia. Exemplo para os dias 1, 2 e 3 de janeiro no porto `pb01`:

```bash
curl -g -s "https://tabuamare.api.br/api/v2/tabua-mare/pb01/1/[1,2,3]"
```

A consulta sem cadastro é gratuita. No [playground](https://tabuamare.api.br/playground), você testa a chamada e vê o resultado.

*Fontes: [Tábuas das Marés do CHM](https://www.marinha.mil.br/chm/dados-do-segnav-publicacoes/tabuas-das-mares), [Informações sobre Marés](https://www.marinha.mil.br/chm/pagina-basica/informacoes-sobre-mares), [Dúvidas Frequentes do BNDO](https://www.marinha.mil.br/chm/bndo/duvidas-frequentes), [Envio de dados e metadados ao BNDO](https://www.marinha.mil.br/chm/bndo/envio) e [Estações Maregráficas na IDEM-DHN](https://idem.marinha.mil.br/geonetwork/geonetwork/search?keyword=maregrafia).*
