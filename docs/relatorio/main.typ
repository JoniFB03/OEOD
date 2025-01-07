#import "setup/template.typ": *
#include "setup/capa.typ"
#import "setup/sourcerer.typ": code
// #import "@preview/sourcerer:0.2.1": code

#show: project
#counter(page).update(1)
#import "@preview/algo:0.3.3": algo, i, d, comment //https://github.com/platformer/typst-algorithms
#import "@preview/tablex:0.0.8": gridx, tablex, rowspanx, colspanx, vlinex, hlinex, cellx
#set text(lang: "pt", region: "pt")
#show link: underline
#show link: set text(rgb("#004C99"))
#show ref: set text(rgb("#00994C"))
#set heading(numbering: "1.")
#show raw.where(block: false): box.with(
  fill: luma(240),
  inset: (x: 0pt, y: 0pt),
  outset: (y: 3pt),
  radius: 3pt,
)

#page(numbering:none)[
  #outline(indent: 2em, depth: 7)  
  // #outline(target: figure)
]
#pagebreak()
#counter(page).update(1)

#set list(marker: ([•], [‣], [–]))

= Introdução <1.Introdução>

No âmbito da Unidade Curricular de Otimização de Estratégias Orientada por Dados (OEOD), foi-nos proposto o desafio de desenvolver um estudo inovador que alinhasse estratégias estatísticas com algoritmos de #link("https://www.geeksforgeeks.org/what-is-reinforcement-learning/")[ _Reinforcement Learning_].  Este projeto tem como foco a análise do comportamento das ações da NVIDIA, uma empresa amplamente reconhecida pela sua liderança em tecnologias de ponta, como inteligência artificial, GPUs de alto desempenho e soluções para data centers.


Fundada em 1993, a #link("]https://www.nvidia.com/en-eu/ ")[ NVIDIA] é uma empresa reconhecida como líder global em tecnologia de computação gráfica, inteligência artificial e soluções de computação acelerada. Desde o lançamento da sua primeira unidade de processamento gráfico (GPU) em 1999, a empresa transformou setores como entretenimento digital, ciência, saúde e automobilismo, posicionando-se como um dos principais impulsionadores da inovação tecnológica no século XXI. Nos últimos anos, a NVIDIA tem se destacado não apenas pela inovação tecnológica, mas também pelo bom desempenho no mercado financeiro, com o valor das suas ações, registando aumentos significativos. Esse crescimento está diretamente relacionado à forte expansão das #link("https://www.pocket-lint.com/nvidia-gpu-history/")[GPUS] de alto desempenho, fundamentais para os domínios da Inteligência Artificial (AI), _Cloud Computing_ e _Machine Learning_ (ML), além do papel essencial da empresa no desenvolvimento de soluções para data centers e tecnologias de ponta.


O principal objetivo é compreender os fatores que impulsionaram o crescimento da empresa entre 2019 e 2024, desenvolvendo estratégias de negociação automatizada que possam otimizar retornos financeiros. Para isso, integrámos abordagens estatísticas clássicas, como o _crossover_ de médias móveis exponenciais, ou mais robustas, através de um modelo preditivo de ML. Isto tudo associado à complexidade de um agente de *_Reinforcement Learning_* capaz de tomar decisões adaptativas baseadas em dados históricos. Este estudo não só explora a viabilidade técnica dessas ferramentas no mercado financeiro, mas também contribui para a aplicação prática de metodologias avançadas no contexto de _Algorithmic Trading_ (AT). 

A NVIDIA, além da sua relevância tecnológica, reflete a sua alta volatilidade e potencial lucrativo, tornando-se um caso de estudo ideal para explorar a aplicação de técnicas analíticas e preditivas em mercados dinâmicos. Analistas do Citi projetam que as ações da Nvidia podem valorizar até 27% nos próximos 90 dias, impulsionadas por expectativas positivas em relação ao discurso do CEO, Jensen Huang, na #link("https://exame.com/invest/mercados/acao-da-nvidia-pode-se-valorizar-ate-27-nos-proximos-90-dias-preve-citi/")[ CES 2025]. 



  
= Problema do Projeto <2.ProblemasProjeto>

A proposta combina estratégias estatísticas e algoritmos de aprendizagem por _*Reinforcement*_ para identificar padrões no mercado e aproveitar oportunidades de investimento, com foco na otimização de retornos financeiros e análise dos fatores que influenciam o desempenho das ações da NVIDIA. A empresa, líder em inteligência artificial e GPUs, apresenta um aumento no mercado bastante significativo nestes últimos anos, tornando-se num caso ideal para técnicas avançadas de análise quantitativa e AT.

O projeto apresenta desafios específicos que precisam ser confrontados para garantir o seu sucesso. Um dos principais obstáculos é a previsibilidade limitada do mercado, uma vez que, o desempenho das ações da NVIDIA é influenciado por fatores externos como, por exemplo, anúncios de novos produtos, alterações nas regulamentações e avanços tecnológicos, que podem causar movimentos inesperados. Além disso, as flutuações macroeconómicas, como mudanças nas taxas de juros, inflação e políticas comerciais, desempenham um papel significativo na variação do valor das ações da empresa. Esses desafios ressaltam a complexidade do mercado financeiro e reforçam a importância de desenvolver abordagens robustas, adaptativas e com espírito crítico para lidar com essas incertezas e maximizar os resultados das estratégias de AT.
#pagebreak()

= Dados <3.Dados>

== Aquisição e preparação dos dados

Para a recolha dos dados históricos das ações da _NVIDIA_, foi utilizada a biblioteca #link("https://www.geeksforgeeks.org/what-is-yfinance-library/")[yfinance] no _Python_, uma biblioteca utilizada para obter dados financeiros de forma eficiente e acessível. Posteriormente, será realizado um _dashboard_ para a melhor compreensão e visualização dos dados (@AnexoAdash), com um gráfico #link("https://www.bussoladoinvestidor.com.br/grafico-ohlc/")[OHLC] interativo. 

Foram definidos os seguintes parâmetros para o _download_:  
- *`ticker`*: `NVDA`, representa as ações da _NVIDIA_.  
- *`start_date`*: `2019-01-01`, correspondente ao início do período de interesse.
- *`end_date`*: `2024-11-01`, para garantir que os dados incluam também o dia 31 de outubro de 2024.  

Após a execução da função de _download_, os dados foram obtidos num formato inicial não ideal, onde: a coluna *`Ticker`* era repetida para cada coluna e a data era o índice, dificultando certas operações. Este formato necessitou de pequenos ajustes para facilitar a manipulação e análise dos dados. Após o processamento, os dados foram reorganizados, resultando num _dataset_ mais limpo e estruturado. A @NVIDIA_Base_Dados mostra o resultado final, após o tratamento dos dados:

#figure(
  tablex(
    columns: 7,
    align: (col, row) => {
      if row == 0 {
        center
      } else if (0,6).contains(col) {
        center
      } else {center}
    },
    header-rows:1,
    auto-lines: false,
    [*Date*], [*Adj Close*], [*Close*], [*High*], [*Low*], [*Open*],
    [*Volume*],
    hlinex(stroke:0.2mm),
    [2019-01-02], [3.378089], [3.405500], [3.462000], [3.251250], [3.266000], [508752000],
    [2019-01-03], [3.173996], [3.199750], [3.379000], [3.192250], [3.344750], [705552000],
    [2019-01-04], [3.377346], [3.404750], [3.443250], [3.242500], [3.273500], [585620000],
    [2019-01-07], [3.556145], [3.585000], [3.622250	], [3.410750], [3.462500], [709160000],

    colspanx(7)[*`(...)`*],
    
    [2024-10-31], [132.750854], [132.759995], [137.610001], [132.110001], [137.600006], [270039600],
),
caption: [Exemplo de dados da _NVIDIA_],
kind:table
)<NVIDIA_Base_Dados>


== Descrição dos dados

Uma descrição mais detalhada dos dados pode ser visualizada na @NVIDIA_DataDescription:

#figure(
  tablex(
    columns: 3,
    align: (col, row) => {
      if row == 0 {
        center
      } else if (0,6).contains(col) {
        center
      } else {center}
    },
    header-rows:1,
    auto-lines: false,
    [*Variable*],
    vlinex(stroke:0.2mm),
    [*Type*], 
    vlinex(stroke:0.2mm),[*Description*],
    hlinex(stroke:0.2mm),
    [*`Date`*], [`datetime('%Y-%m-%d')`], [ Representa a data de negociação de cada registo],
    
    hlinex(stroke:0.2mm),
    [*`Adj Close`*], [`float`], [Refere-se ao preço de fecho ajustado para fatores como dividendos e desdobramentos de ações (_stock splits_).],
    hlinex(stroke:0.2mm),
    [*`Close`*], [`float`], [O preço de fecho da ação no dia de negociação, sem ajustes por eventos como dividendos ou _splits_.],
    hlinex(stroke:0.2mm),
    [*`High`*], [`float`], [O preço mais alto que a ação atingiu durante o dia de negociação.],
    hlinex(stroke:0.2mm),
    [*`Low`*], [`float`], [O preço mais baixo que a ação atingiu durante o dia de negociação.],
    hlinex(stroke:0.2mm),
    [*`Open`*], [`float`], [O preço inicial da ação no início do dia de negociação.],
    hlinex(stroke:0.2mm),
    [*`Volume`*], [`int`], [O número total de ações transacionadas no dia, representando a liquidez e o interesse do mercado. @volumedata[*Ver Dados*]],
),
caption: [Descrição das variáveis],
kind:table
)<NVIDIA_DataDescription>

É relevante destacar algumas características da variável *`Date`*, que corresponde ao índice das linhas do nosso _dataset_. A variável inicia no dia `2019-01-02` e termina no dia `2024-10-31`. O dia `2019-01-01` não está presente porque corresponde a um feriado, durante o qual o mercado de _stocks_ esteve fechado. De forma intuitiva, seria expectável que o número total de linhas do _dataset_ fosse 2130, representando todos os dias do intervalo entre `2019-01-02` e `2024-10-31`. Contudo, o _dataset_ contém apenas 1469 linhas. Isto deve-se ao facto de o mercado de _stocks_ não operar durante os fins de semana e feriados. Por exemplo, como ilustrado em @NVIDIA_Base_Dados, os dias `2019-01-05` e `2019-01-06` estão ausentes, pois corresponderam a um fim de semana.

== Estatísticas <3.3stats>
=== Estatísticas Anuais

#set text(7pt)

#figure(
  tablex(
    columns: 10,
    align: (col, row) => {
      if row == 0 {
        center
      } else if (0,7).contains(col) {
        center
      } else {center}
    },
    header-rows:1,
    auto-lines: false,
    [*Year*], [*Annual Return (%)*], [*Avg Price*], [*Max High*], [*Min Low*], [*Avg Volume*], [*Volatility (%)*], [*Trading Days*], [*Days Above Avg Volume*], [*Trend Slope*],
    hlinex(stroke:0.2mm),
    [2019], [73.41%], [$dollar$#calc.round(4.338581, digits: 3)], [$dollar$#calc.round(6.045250, digits: 3)], [$dollar$#calc.round(3.192250, digits: 3)], [#calc.round(456399666.67,digits: 0)], [41,29%], [260], [94], [0.004417],
    [2020], [118.02%], [$dollar$#calc.round(9.859559, digits: 3)], [$dollar$#calc.round(14.726750, digits: 3)], [$dollar$#calc.round(4.517000, digits: 3)], [#calc.round(480855256.92, digits: 0)], [58,84%], [261], [106], [0.026562],
    [2021], [124.48%], [$dollar$#calc.round(19.483434, digits: 3)], [$dollar$#calc.round(34.646999, digits: 3)], [$dollar$#calc.round(11.566500, digits: 3)], [#calc.round(359558817.46, digits: 0)], [45,70%], [260], [92], [0.051868],
    [2022], cellx(fill: rgb("#ffc9bb"))[-51.44%], [$dollar$#calc.round(18.544185, digits: 3)], [$dollar$#calc.round(30.711000, digits: 3)], [$dollar$#calc.round(10.813000, digits: 3)], [#calc.round(543163223.11, digits: 0)], [64.21%], [260], [111], cellx(fill: rgb("#ffc9bb"))[-0.036685],
    [2023], [246.10%], [$dollar$#calc.round(36.552498, digits: 3)], [$dollar$#calc.round(50.548000, digits: 3)], [$dollar$#calc.round(14.034000, digits: 3)], [#calc.round(473557460.00, digits: 0)], [49.10%], [259], [97], [0.095347],
    [2024], cellx(fill: rgb("cefad0"))[175.68%], [$dollar$#calc.round(101.594215, digits: 3)], [$dollar$#calc.round(144.419998, digits: 3)], [$dollar$#calc.round(47.320000, digits: 3)], [#calc.round(409995164.45, digits: 0)], [51.30%], [218], [98], cellx(fill: rgb("cefad0"))[0.254817],),
    
    caption: [Tabela de métricas anuais do stock],
    kind:table
)<Stock_Annual_Metrics>

#set text(11pt)

A tabela abaixo apresenta as métricas anuais de 2019 a 2024 para o preço de uma ação, com foco nas variáveis mais relevantes. 

1. *`Retorno Anual(%)`*: é calculado como a diferença percentual (Tx. Variação) entre o preço de encerramento do último dia do ano e o primeiro dia do ano. Abaixo, podemos visualizar a fórmula utilizada:

$
#text(`annual_return_pct`) = 

(italic("annual_stats")_italic("last_close") - italic("annual_stats"_"first_close"))/italic("annual_stats"_italic("first_close")) times 100
$ <VolatilidadeAnual>

  - O maior *retorno anual* ocorreu em 2023, com 246,10%, indicando um grande crescimento no valor da ação entre o início do ano e o final deste.
  - O *retorno anual* mais baixo foi em 2022, com -51,44%, representando uma queda significativa no valor da ação.

2. *`Preço Médio Anual (Preço Ajustado)`*: reflete o valor médio da ação ao longo do ano, levando em consideração os ajustes de dividendos e desdobramentos.
  - Em 2024, o preço médio foi de $dollar$101.59, o mais alto da tabela, o que pode indicar um forte desempenho da _NVIDIA_ ao longo dos anos, que contribui oara um aumentos das suas ação nos últimos anos.

+ *`Máximo Anual (High) e Mínimo Anual (Low)`*: Esses valores representam o preço mais alto e mais baixo alcançado pela ação ao longo do ano.
  - Em 2023, o *máximo anual* foi de $dollar$50.55, que é o valor mais alto entre todos os anos da tabela.
  - O *mínimo anual* mais baixo foi em 2020, com $dollar$4.52.

+ *`Volume Médio Anual`*: mostra a média do número de ações negociadas por dia no ano. 
  - O maior volume foi em 2020, com 480.855.257 ações negociadas diariamente.

+ *`Volatilidade Anual`* #footnote[Cálculo da Volatilidade Anual: https://www.linkedin.com/pulse/volatilidade-bpiga-nma7f/ | https://opcoespro.com.br/blog/como-calcular-a-volatilidade-historica ]: é uma medida que indica o quanto os retornos diários de um ativo podem variar ao longo de um ano, expressa como uma percentagem, e é calculada multiplicando o desvio padrão dos retornos diários pela raiz quadrada do número de dias úteis no ano. Abaixo podemos visualizar a respetiva fórmula:

$
sigma_a = sigma_d times sqrt(N) times 100;
$

Onde,

  - _N_: é o número de dias úteis no ano (Normalmente, é utilizado o valor de 252 dias úteis).
  - $sigma_d  = sqrt((Sigma^N_(k=1)(R_k - macron(R))^2)/(N - 1))$
    - *Retorno diário*: $R_k = P_k/P_(k-1) - 1$. O grupo já possui o preço ajustado de "fecho" para cada dia. Assim, basta calcular a taxa de variação entre esses valores, ou seja, `data['Adj Close'].pct_change()`.f
    - *Média dos Retornos*: $macron(R) = 1/N Sigma^N_(k=1) R_k$. Esta fórmula consiste em fazer uma média dos *$R_k$*

A volatilidade foi mais alta em 2022 (64,21%), indicando que a ação teve uma maior variação nos preços durante esse ano.

6. *`Dias de Negociação`*: Este valor indica o número total de dias úteis de negociação para cada ano.
  - A média de dias de negociação foi aproximadamente 260, com exceção de 2024, que registou 218 dias devido à disponibilidade dos dados até 31 de outubro, e de 2020, que teve 261 dias por ser um ano bissexto.

+ *`Dias com Volume Acima da Média`*: Indica o número de dias em que o volume de transações foi superior à média anual.
  - O ano de 2020 teve 106 dias de volume acima da média, o maior valor da tabela.

+ *`Tendência Linear (Slope)`*: reflete a inclinação da linha de tendência do preço de fecho ao longo do ano, usando uma regressão linear.
  - Em 2024, a tendência foi a mais acentuada com um valor de 0.369580, indicando um crescimento acentuado da ação no último ano.
  - Os dados de 2022 indicam uma tendência decrescente, com um único ponto atingindo o valor de *-0.036685*. É interessante notar que outras variáveis dessa linha também apresentam variações significativas. O *retorno anual percentual* é negativo, o que indica que o preço da ação da _NVIDIA_ no início do ano era superior ao seu valor no final do ano. Além disso, o *volume de transações* (*`Avg Volume`*) foi maior nesse ano, possivelmente devido ao aumento no número de vendas, o que, por sua vez, pode ter contribuído para um maior número de ações físicas tomadas pelos investidores.
  - Após esta análise, podemos visualizar na *@PriceCloseTendencia* a evolução do *`Close`* ao longo dos anos, com a respetiva linha de tendência. É notório um aumento, quase exponencial, dos valores da variável *`Close`*, mas com uma diminuição dos valores do ano de 2022 para 2023. Não é possível identificar com certeza o motivo, mas pode estar relacionado com a escassez de chips #footnote[Noticia sobre a escassez de Chips: https://tecnoblog.net/noticias/nvidia-escassez-chips-ate-2022-atraso-compra-arm/] que ocorreu em 2022, ou com o fim de linha da GPU #footnote[Noticia sobre o fim de linha da RTX 2060: https://www.tecmundo.com.br/voxel/254189-fim-linha-nvidia-encerra-producao-placas-rtx-2060.htm] mais utilizada na época, a #link("https://www.techpowerup.com/gpu-specs/geforce-rtx-2060.c3310")[*RTX 2060*].



#align(center)[
  #figure(
image("images/PriceCloseTendency.png", width: 100%),
  caption: [Preços da variável `Close` e a sua linha de tendência (por ano)]
) <PriceCloseTendencia>
] 

#pagebreak()

=== Estatísticas Gerais<statsgerais>

#set text(10.2pt)

#figure(
  tablex(
    columns: 6,
    align: (col, row) => {
      if row == 0 {
        center
      } else if (0,6).contains(col) {
        center
      } else {center}
    },
    header-rows:1,
    auto-lines: false,
    [*Soma dos retornos diários*], [*Retorno Esperado*],[*Asset Expected Return*],  [*Volatilidade*], [*Sharpe Ratio*], [*CAGR*],
    hlinex(stroke:0.2mm),
    [#calc.round(4.457202894137319, digits: 3) @Somadosretornosdiários], [#calc.round(0.0030362417534995365, digits: 3) @RetornoEsperado],[#calc.round(0.0000020668766191283433391256366823407475, digits: 6) @AssetExpectedReturn],[#calc.round(0.0329278427427735, digits: 3) @Volatilidade], [#calc.round(0.09053836189070488, digits: 3) @SharpeRatio],
    [#calc.round(0.0024984505386265177, digits: 3) @CAGR],
),
caption: [Análise de Retornos: Médias Esperadas e Risco],
kind:table
)<NVIDIA_Metrics>

1. *`Soma dos retornos diários`*: acumulação simples das variações percentuais do preço de uma ação ao longo de um período. Podemos visualizar a fórmula abaixo @Somadosretornosdiários:
$
Sigma_(k=1)^n R_k = Sigma_(k=1)^n (P_k/P_(k-1) - 1) or Sigma_(k=1)^n R_k = Sigma_(k=1)^n (log(P_k/P_(k-1)))
$ <Somadosretornosdiários>
- Onde:
  - $R_k$ é o retorno diário do dia $k$;
  - $P_(k)$ é o preço do dia $k$;  $P_(k-1)$ é o preço do dia $k - 1$;
  - $n$ é o número total de períodos (dias) analisados.
A `soma dos retornos diários` da _NVIDIA_ foi de 4.457 durante o período analisado. Este valor indica uma variação líquida acumulada de aproximadamente 4.46% nos retornos percentuais diários do preço da ação ao longo do tempo. Embora este valor seja positivo, indicando um desempenho global favorável no período, ele não reflete diretamente o crescimento composto do ativo, mas apenas a soma simples das variações diárias.



2. *`Retorno Esperado`*: uma métrica financeira que estima o retorno médio de um ativo ao longo de um período, com base no desempenho histórico. @RetornoEsperado

$
mu = italic("Soma dos Retornos Diários")/n
$<RetornoEsperado>
- Onde:
  - $n$ é o número total de períodos (dias) analisados.

  - O `retorno esperado` de 0.003 (ou 0.3%) indica uma previsão de crescimento moderado no preço da ação da _NVIDIA_, sugerindo um ganho diário contínuo, o que, ao ser acumulado, pode resultar em um aumento substancial ao longo do tempo.

3. *`Asset Expected Return`*: representa o retorno médio esperado de um ativo por unidade de tempo, geralmente com base em dados históricos. Este valor é calculado como a média dos retornos diários (ou de outro intervalo temporal) ao longo do período analisado. Podemos visualizar a fórmula abaixo @AssetExpectedReturn:

$
italic("Retorno Esperado")/n
$ <AssetExpectedReturn>

- Onde:
  - $n$ é o número total de períodos (dias) analisados.

O `retorno médio diário` esperado de 0.000002 sugere um crescimento marginal no preço da ação da _NVIDIA_, que, embora pequeno, pode acumular-se de forma significativa ao longo do tempo.

4. *`Volatilidade`*: uma medida da variabilidade dos retornos de um ativo, indicando o quão "errático" ou incerto é o seu comportamento ao longo do tempo. Podemos visualizar a fórmula abaixo @Volatilidade:

$
sigma = sqrt((Sigma(R_k - italic("Retorno Esperado"))^2)/(n))
$<Volatilidade>

- Onde:
  - $n$ é o número total de períodos (dias) analisados.
  - $R_k$ é o retorno diário do dia $k$;

Um valor de 0.033 (ou 3.3%) significa que os retornos diários da ação da _NVIDIA_ têm uma variação média de 3.3% em torno da média. Quanto maior a volatilidade, maior o risco associado ao ativo, pois os preços podem oscilar significativamente, o que pode representar oportunidades ou desafios para os investidores.

5. *`Sharpe Ratio`*: uma medida de desempenho ajustada pelo risco, utilizada para avaliar o retorno de um ativo ou portfólio em relação ao risco que ele apresenta. Ele é calculado subtraindo a taxa livre de risco do retorno do ativo e dividindo o resultado pela volatilidade (desvio padrão) do retorno do ativo. Podemos visualizar a fórmula abaixo @SharpeRatio:

$
italic("SR") = (italic("Retorno Esperado") - italic("Taxa Livre de Risco"))/italic("Volatilidade")
$<SharpeRatio>

  - *`Taxa Livre de Risco`* *$: (1 + 0.02)^(1/360)-1$*
    - A #link("https://www.investopedia.com/articles/financial-theory/08/risk-free-rate-return.asp")[`Taxa Livre de Risco`] é o retorno que um investidor pode esperar de um investimento considerado sem risco de crédito, como os títulos do governo de curto prazo. Esses investimentos são vistos como seguros, pois o risco de inadimplência é mínimo. A taxa livre de risco serve como base para comparar outros investimentos, pois oferece um retorno sem risco, e qualquer ativo mais arriscado deve gerar um retorno maior para compensar o risco adicional.


Um valor de 0.091 é consideravelmente baixo, o que sugere que o retorno extra do investimento não é suficiente para compensar o nível de risco envolvido. Em termos práticos, esse valor implica que o risco assumido não é adequadamente recompensado com o retorno gerado. O `Sharpe Ratio` idealmente deveria ser superior a 1, sendo que um valor abaixo de 1 pode ser visto como um sinal de que o investimento não é suficientemente atraente para justificar o risco.

6. *`CAGR`*: uma métrica utilizada para calcular a taxa de crescimento média de um investimento ao longo de um período de tempo específico, assumindo que o crescimento ocorre de forma constante a cada ano. Em outras palavras, o `CAGR` descreve a taxa de retorno de um investimento, considerando que ele cresceu a uma taxa constante ao longo do período. Podemos visualizar a fórmula abaixo @CAGR:

$
italic("CAGR") = (P_text("Final")/P_text("Inicial"))^(1/n)-1
$<CAGR>

- Onde:
  - $P_text("Final")$ é o valor final do investimento;
  - $P_text("Inicial")$ é o valor inicial do investimento;
  - _n_ é o número de anos.


O `CAGR` de 0.002, ou 0.2%, indica que, ao longo do período considerado, o valor do investimento cresceu a uma taxa média anual de 0.2%. Em outras palavras, se o investimento tivesse crescido a uma taxa constante de 0.2% ao ano, o valor final seria o mesmo que o observado no final do período.
  
#line(length: 100%)

7. *Conclusão*: 
- Embora a _NVIDIA_ apresente uma soma positiva de retornos diários (4.457), o retorno esperado é relativamente baixo, com um valor de 0.003, indicando que o ativo não tem um desempenho excepcional em termos de rentabilidade anual. O `Sharpe Ratio` de 0.091 sugere que o risco associado ao ativo não está suficientemente compensado pelo retorno, o que indica que, apesar do crescimento potencial, o ativo apresenta um retorno inadequado em relação ao risco que envolve. O `Asset Expected Return`, por sua vez, é quase irrelevante, com um valor muito baixo, indicando que o retorno do ativo em relação ao seu valor esperado é praticamente insignificante. A `volatilidade` moderada (0.033) deve ser considerada pelos investidores, pois ela implica que o preço do ativo tem oscilações que podem impactar o desempenho no curto prazo, sendo importante para os investidores avaliarem o risco de flutuações nos preços.

- Em suma, apesar de um retorno diário positivo, a _NVIDIA_ apresenta uma relação risco-retorno que pode ser considerada subótima, com a `volatilidade` e a expectativa de retorno relativamente baixas, o que pode torná-la uma opção de investimento menos atrativa para perfis que buscam um desempenho ajustado ao risco mais favorável.


#pagebreak()

= Metodologia <4.Metodologia>

== Estratégias de _trading_<4.1strats>

Para começar a nossa análise, foi necessário escolher a nossa estratégia de _trading_ para ser dado como entrada no modelo de _Reinforcement Learning_ (RL). Para isso, decidimos utilizar duas estratégias distintas na sua robustez para posteriormente compará-las e fazer um _trade-off_ entre complexidade e explicabilidade das estratégias. Talvez valha mais a pena ter um algoritmo menos complexo, mais fácil de explicar, e que tenha uma _performance_ inferior a algo mais robusto e que não produza resultados muito mais interessantes que uma estratégia simples.

A discussão do _trade-off_ entre complexidade e explicabilidade com a performance será incorporado na função `get_state()` que será explicado mais à frente na @4.2RLmodels.

=== Crossover de Média Móvel Exponencial <CMME>

Como primeira estratégia decidimos utilizar uma estratégia clássica e bastante simples; a média móvel exponencial (EMA)#footnote[EMA em stock trading: https://www.investopedia.com/terms/e/ema.asp]. É uma variação da média móvel simples (SMA)#footnote[SMA em stock trading: https://www.investopedia.com/terms/s/sma.asp], mas que dá destaque a preços mais recentes, pois utiliza a função exponencial no seu cálculo. Essa característica torna a EMA particularmente útil para mercados dinâmicos e em constante mudança.

No nosso caso, esta estratégia mostra-se interessante por diversos motivos, já enunciados na @3.Dados:


- Como os _stocks_ da _NVIDIA_, no período considerado, têm um crescimento bastante alto, é importante dar maior destaque aos preços mais recentes, mais próximos do fim da série a 31 de outubro de 2024. Isso permite que esta estratégia se adapte melhor às tendências mais recentes.
- O método de EMA reage a grandes variações de preço mais rápido em comparação ao método de SMA. Algo bastante positivo para mercados voláteis, em que bruscas ou eventos inesperados (como lançamentos de GPUs ou mudanças legislativas) podem indiciar instantes de _buy_ ou _sell_;

- Embora seja mais "sofisticada" que a SMA, a EMA continua a ser uma estratégia relativamente simples de explicar e de implementar.
\



O cálculo da EMA é realizado pela função `ewn()`#footnote[Função _pandas_ para EMA: https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.ewm.html], através da seguinte fórmula:

$ "EMA"_t = "Close Price"_"today" times (("Smoothing"=2)/(1+ "Days")) + "EMA"_"yesterday" times (1-("Smoothing"=2)/(1+ "Days")) $ <CMMEFormula>

O quociente $("Smoothing"=2)/(1+ "Days")$ corresponde ao fator de suavização $alpha$, onde o valor de _Smoothing_ é fixado em 2 por convenção, mas que poderia ser aumentado se quiséssemos dar ainda mais importância aos instantes mais recentes no EMA. Já o _Days_ é o valor do `span`, que corresponde ao número de dias que estão no período para a média móvel exponencial. 

Como estamos a adotar uma estratégia de _crossover_, é necessário ter duas linhas para identificar pontos de interseção entre as duas, chamados de _crosses_. Assim, teremos de ter dois valores de *_Days_*, com valores de dias distintos para a média móvel, um para captar movimentos mais rápidos e ser mais sensível a variações (*_fast_*) e outro para ter uma visão mais a longo prazo, suavizando as oscilações de preços a curto prazo (*_slow_*). Por indução, devem-se utilizar intervalos de dias pequenos se quisermos investimentos a curto prazo (8/20-_days_), ou intervalos maiores se quisermos investimentos a longo prazo, numa série maior (50/200-_days_). No nosso caso, optámos começar pelos valores de 50 e 200 em EMA, tendo mudado estes mais para a frente.

Nesta estratégia, como já foi referido, queremos identificar pontos de interseção entre as duas retas de *_fast_* e *_slow_*. Quando a reta *_slow_* (`span`=200) cruza e ultrapassa a reta *_fast_* (`span`=50), esse ponto é designado de _death cross_ e o mercado entra em _danger zone_; quando o inverso acontece, a interseção é designada de _golden cross_ e o mercado entra numa _opportunity zone_#footnote[Explicação de _crosses_: https://www.investopedia.com/terms/g/goldencross.asp]. Na @EMA50200 podemos observar estes pontos e zonas.

#align(center)[
  #figure(
image("images/ema50_200.png", width: 100%),
  caption: [Estratégia de _Crossover_ EMA(_fast_:50, _slow_:200)]
) <EMA50200>
] 

Para o cálculo dos retornos da estratégia é utilizada a fórmula já calculada anteriormente na @3.3stats, o $R_k$, bem como o valor do _Signal_; que é 1, caso o EMA _fast_ seja maior que o EMA _slow_, ou seja, um _golden cross_; ou 0 se o EMA _slow_ for superior ao EMA _fast_ (_death cross_)
Assim, o retorno da estratégia é apresentado pela seguinte fórmula:

$ "StratReturns"_t = R_t times "Signal"_(t-1) $ <formulaSignal>

Pela fórmula @formulaSignal é possível observar que o _Signal_ funciona como um "interruptor" que liga ou desliga para os retornos, em movimentos de subida ou descida. Se o _Signal_=0 num instante $t$, o retorno da estratégia será nulo para o dia seguinte $t+1$ e, por conseguinte, não será contabilizado nos retornos acumulados da estratégia, descritos pela seguinte fórmula:

$ "CumReturns"_t = product_(i=1)^(t) (1+"StratReturns"_i) $ <CumReturnFormula>

Para os parâmetros de EMA(_fast_=50, _slow_=200) obtivemos um valor de retornos acumulados de 33.38. Para termos de comparação, serão testados vários valores de `span` (@tabcrossoverEMA), principalmente na curva _slow_, para percebermos o impacto que terá nos retornos acumulados. A razão para isto está no facto de que, quanto maior for o intervalo de datas considerado para o cálculo da média móvel, mais suavizada a curva resultante se torna. Como resultado, a EMA _slow_ tende a distanciar-se da linha de `Close` ao longo da série temporal, especialmente depois de 2023 (@EMA50200).

#figure(
  tablex(
    columns: 3,
    align: (col, row) => {
      if row == 0 {
        center
      } else if (1,2,3,4,5).contains(col) {
        center
      } else {center}
    },
    map-rows: (row, cells) => cells.map(c =>
    if c == none {
      c
    } else {
      (..c, fill: if row == 3 { rgb("cefad0") } else { none })
    },
  ),
    header-rows:1,
    auto-lines: false,
    [*EMA _fast_*], [*EMA _slow_*], [*CumReturns*],
    hlinex(stroke:0.2mm),
    [50], [200], [33.38], 
    [50], [150], [36.39], 
    [50], [140], [*39.19*],
    [50], [130], [34.91], 
    [40], [140], [32.65],
    [20], [140], [23.09]
),
caption: [Vários valores de `span` para a estratégia de _Crossover_ de EMA],
kind:table
)<tabcrossoverEMA>

Pelos valores da @tabcrossoverEMA, é possível verificar que os valores sugeridos inicialmente não refletiam tão bem os retornos acumulados, sendo necessário reduzir o número de dias da média móvel _slow_, a fim de obter-se um valor de retorno acumulado maior e de ter a área da _danger zone_ mais adequada, ou até mais _danger zones_ e _crosses_ (@graficosCrossover). Na @EMA50140 temos a estratégia com os parâmetros de (_fast_:50, _slow_:140).

#align(center)[
  #figure(
image("images/ema50_140.png", width: 100%),
  caption: [Estratégia de _Crossover_ "otimizada" -> EMA(_fast_:50, _slow_:140)]
) <EMA50140>
] 






== Modelos de _Machine Learning_ (Supervisionada) <MachineLearning>

Antes de avançarmos para os modelos de *reinforcement learning* ( @4.2RLmodels ), será realizado um teste utilizando modelos de *machine learning* tradicionais. Esta abordagem será dividida em duas partes:

1. *ML Regressão* ( @MLregressão ): Será aplicado um modelo de regressão com o objetivo de prever o valor da variável `Close` do mercado de ações.
   
2. *ML Classificação* ( @MLclassificação ): Desenvolveremos um modelo de classificação com três classes — *Buy*, *Sell*, e *Hold* — para tentar identificar os momentos ideais de compra e venda de ações, visando maximizar os lucros.


=== Regressão <MLregressão>

Na escolha do modelo de _machine learning_, o grupo decidiu implementar um modelo de *rede neuronal #link("https://www.geeksforgeeks.org/deep-learning-introduction-to-long-short-term-memory/")[LSTM]*#footnote[Base para a criação do nosso modelo de _Machine Learning_ de *Regressão*: https://www.simplilearn.com/tutorials/machine-learning-tutorial/stock-price-prediction-using-machine-learning], amplamente reconhecido pela sua robustez e capacidade de captura de padrões complexos temporais. O objetivo principal deste modelo é prever o preço da variável *`Close`* com base em variáveis históricas e indicadores financeiros. As variáveis preditivas utilizadas foram as seguintes:

- *Retornos*: Calcula a variação percentual diária do preço da variável `Close`.
- *Lags*: Criação de variáveis que representam os preços da variável `Close` dos dias anteriores (_lags_ de 1 a 4 dias).
- *Volatilidade*: Calcula o desvio padrão dos retornos diários com uma janela de 5 dias.
- *Momentum*: Calcula a diferença entre o preço da variável `Close` atual e o de 5 dias atrás, capturando a tendência recente do mercado.

No pré-processamento dos dados, foram eliminadas as linhas que continham valores nulos, a fim de evitar que esses dados faltantes prejudicassem o desempenho do modelo. Além disso, a variável `close` foi normalizada utilizando o *MinMaxScaler*, que escala os valores entre 0 e 1, garantindo que as variáveis estejam no mesmo intervalo e, assim, facilitando a convergência do modelo durante o treino.

Para a divisão dos dados em treino e teste, optou-se por uma distribuição de *80%* para treino e *20%* para teste. As variáveis preditivas escolhidas foram: *`lags (4x)`*, *`volatilidade`* e *`momentum`*. A _target_ escolhida foi a variável *`Close`*, sendo esta a que tinhamos como objetivo prever.

Para a criação do modelo de *rede neuronal LSTM*, foram definidas três camadas com as seguintes características:

- *`Camada de Entrada (LSTM)`*: Composta por *64 unidades* e função de ativação _ReLU_ (Rectified Linear Unit), uma camada recorrente que permite capturar dependências temporais nos dados, essencial para séries temporais.
- *`Camada Oculta`*: Com *32 unidades*, também utilizando a função de ativação _ReLU_, o que permite à rede aprender representações mais complexas dos dados.
- *`Camada de Saída`*: Uma única unidade que tem como objetivo prever o valor contínuo do preço de fecho da ação. 

A rede foi compilada utilizando o #link("https://pt.eitca.org/intelig%C3%AAncia-artificial/eitc-ai-dltf-aprendizado-profundo-com-tensorflow/fluxo-tensor/modelo-de-rede-neural/revis%C3%A3o-de-exame-modelo-de-rede-neural/como-o-otimizador-adam-otimiza-o-modelo-de-rede-neural/")[*Otimizador Adam*], que ajusta os pesos de maneira eficiente durante o treino, e a #link("https://www.ibm.com/br-pt/think/topics/loss-function")[*Função de perda MSE (Erro Quadrático Médio)*], que mede a diferença entre as previsões do modelo e os valores reais, visando minimizar esse erro.

No treino do modelo, foram escolhidos parâmetros que garantissem um bom desempenho sem comprometer a eficiência computacional. Optou-se por *50 #link("https://deepai.org/machine-learning-glossary-and-terms/epoch")[_epochs_]*, o que permite ao modelo aprender de forma adequada sem sobrecarregar o tempo de treino. O #link("https://stats.stackexchange.com/questions/153531/what-is-batch-size-in-neural-network")[*_Batch Size_*] foi definido como *32*, o que oferece um equilíbrio entre eficiência computacional e precisão na atualização dos pesos durante o treino. Após aplicar o modelo, o resultado pode ser visualizado na *@MLRegPrevCloseVSRealClose*, onde comparamos as previsões do preço da variável *`Close`* com os valores reais.


#align(center)[
  #figure(
image("images/MLRegPrevCloseVSRealClose.png", width: 100%),
  caption: [Previsão do preço da variável *`Close`* (conjunto teste) VS Valor real da variável *`Close`*]
) <MLRegPrevCloseVSRealClose>
]

Para uma análise mais detalhada, iremos combinar os valores das métricas, calculadas na *@MetricsMLReg*, com a visualização do gráfico da *@MLRegPrevCloseVSRealClose*.


#figure(code(lang:"",  lang-box: (
    gutter: 5pt,
    radius: 3pt,
    outset: 3pt,
    fill: rgb("ffe05d"),
    stroke: 1pt + rgb("#3c79a9")
  ),```python
Mean Squared Error (MSE): 132.95054324484673
Mean Absolute Error (MAE): 9.053899865893644
Root Mean Squared Error (RMSE): 11.530418173025934
R-squared (R²): 0.8765712665219383
  ```), caption: [Parâmetros do _LSTM model_])<MetricsMLReg>

Os resultados sugerem que o modelo pode estar a sofrer de #link("https://didatica.tech/underfitting-e-overfitting/")[_overfitting_], como indicado pelo alto valor de $R^2$ (*0.8766*), que revela um bom ajuste no treino, mas levanta dúvidas sobre a generalização para novos dados. O uso de _features_ como *lag* e *momentum*, derivadas da variável alvo (*`Close`*), pode estar a exacerbar este comportamento, criando relações artificiais no treino. A *@MLRegPrevCloseVSRealClose* também sugere _overfitting_, enquanto os erros absolutos (MAE e RMSE) apontam uma margem de erro significativa nas previsões. Assim, priorizar um modelo de classificação aparenta ser a decisão adequada para melhorar os resultados do nosso objetivo.


#pagebreak()

=== Classificação <MLclassificação>

Neste modelo, a variável `Close` é utilizada como alvo, mas com um objetivo distinto: decidir se deve comprar, vender ou manter uma ação. Para isso, foi empregado o modelo XGBoost para classificação multiclasse, utilizando os parâmetros `eval_metric='mlogloss'` e `objective='multi:softmax'`. Foram definidos três possíveis estados para o modelo: *Buy*, *Sell* e *Hold*. Para otimizar a performance do modelo, foi realizada uma procura aleatória (`random_search`) nos hiperparâmetros, o que permitiu encontrar os valores mais adequados para o problema.

O tratamento dos dados, as features e a divisão entre os conjuntos de treino e teste seguiram a mesma abordagem da @MLregressão, com a diferença de que foi introduzido um *threshold*. Este *threshold* foi definido previamente para que o modelo pudesse gerar labels para treino. Após várias testes, o grupo determinou que o valor de 1,5% seria o mais apropriado para esta métrica, levando à seguinte lógica para atribuição das _labels_:

1. Se o preço da variável `Close` do próximo dia for *superior* ao preço da variável `Close` de hoje, multiplicado por $1 + italic("threshold")$, a label para o dia de hoje será *Buy*: $italic("Preço"_"amanhã") > italic("Preço"_"Hoje") times (1 + italic("threshold"))$;

2. Se o preço da variável `Close` do próximo dia for *inferior* ao preço da variável `Close` de hoje, multiplicado por $1 + italic("threshold")$, a label para o dia de hoje será *Sell*: $italic("Preço"_"amanhã") < italic("Preço"_"Hoje") times (1 - italic("threshold"))$;

3. Caso nenhuma das condições anteriores se aplique, a label será *Hold*.

Após a criação e aplicação do modelo aos dados, obtivemos as seguintes métricas:
  
#align(center + horizon)[
  #figure(
  grid(
    columns: (150pt, 390pt), gutter: 8pt,
    rows: 1,
    rect([

Após aplicar o modelo, o grupo criou uma _confusion matrix_ para realizar uma análise preliminar dos resultados. Ao analisar a _confusion matrix_, é evidente que os resultados não são ideais, embora seja importante destacar que as labels utilizadas não são 100% confiáveis, pois foram definidas manualmente. Além disso, é relevante examinar as métricas e os melhores valores dos hiperparâmetros apresentados na @ResultConfMatrixClass. Para avaliar a robustez do modelo, será realizado um teste na @investirMLClass, permitindo tirar conclusões mais precisas.
          
], inset: 8pt,
  fill: rgb("fff"),
  width: 110%,
  stroke: 0.1pt, radius: (
    left: 5pt,
    right: 5pt,
  )),
    image("images/ConfMetrixClass.png", width: 100%),
  ),
  caption: [
    _Confusion Matrix_ (conjunto teste)
  ],
) <ConfusionMatrixClass>
]

#figure(code(lang:"",  lang-box: (
    gutter: 5pt,
    radius: 3pt,
    outset: 3pt,
    fill: rgb("ffe05d"),
    stroke: 1pt + rgb("#3c79a9")
  ),```python
Melhores hiperparâmetros encontrados: {'subsample': 0.9, 'n_estimators': 300, 'max_depth': 7, 'learning_rate': 0.2, 'colsample_bytree': 0.8}
Acurácia: 0.36860068259385664
Precisão: 0.3443353552280855
Recall: 0.33394224392596605
F1-Score: 0.31857866151155295
  ```), caption: [Métricas e hiperpâmetros do modelo de classificação])<ResultConfMatrixClass>

#pagebreak()
  
==== Aplicação do modelo <investirMLClass>

Para realizar este teste, utilizaremos um orçamento de $dollar 1000$. É importante destacar algumas limitações deste método, que, para serem corrigidas, exigiriam mais tempo e testes. Primeiramente, por ser um modelo de _Machine Learning_, é necessário dividir os dados em conjunto de treino e teste, o que significa que só será possível avaliar o desempenho do modelo após a execução das ações. Além disso, o modelo pode sugerir a compra de uma ação, mas, devido à limitação do orçamento, pode não ser viável, já que o modelo não foi treinado para considerar essa restrição. Mesmo assim, vamos observar o comportamento do modelo e tirar algumas conclusões. Para uma visualização representativa das recomendações do modelo, podemos utilizar a @MLClassMapaEstrat.


#align(center)[
  #figure(
image("images/MLClassMapaEstrat.png", width: 100%),
  caption: [Estratégia de *Compra*, *Venda* e *Hold*: Resultados no Período Final do Dataset]
) <MLClassMapaEstrat>
]

Analisando a @MLClassMapaEstrat, é evidente o elevado número de *Hold* registrados, o que é esperado, pois o modelo tende a manter as posições em períodos de incerteza ou estabilidade. Além disso, é importante observar que existem muitos casos de *Buy* seguidos de *Sell*, o que pode refletir a tentativa de aproveitar movimentos de curto prazo no mercado. 

Nesse contexto, é relevante destacar a estratégia de tomada de decisão adotada, levando em consideração a #link("https://supercasa.pt/noticias/custo-de-transacao-entenda-como-funciona/n5173")[*taxa de transação*] de 0,1%, que impacta diretamente os resultados de cada operação, reduzindo o lucro potencial de compras e vendas frequentes. Tendo isso em conta, a estratégia de tomada de decisão adotada foi a seguinte:

- *$italic("if Budget" > 0) and italic("label") = italic("Buy")$*: Compramos todas as ações possíveis e atualizamos o nosso *_Budget_* da seguinte forma:
  - *$italic("Budget")_"new" = italic("Budget")_"old" - (italic("quantity")_"shares purchased" times italic("price")_"shares" times (1 + italic("fee")_"transaction"))$*

- *$italic("if Shares" > 0) and italic("label") = italic("Sell")$*: Vendemos todas as nossas ações possíveis e atualizamos o nosso *_Budget_* da seguinte forma:
  - *$italic("Budget")_"new" = italic("Budget")_"old" + (italic("quantity")_"shares in stock" times italic("new price")_"shares"times (1 - italic("fee")_"transaction")$*

- *$italic("else")$*: Fazemos *hold* quando não houver *budget* suficiente para comprar ações, quando não tivermos ações para vender ou quando a _label_ for *hold*.

Após aplicar o algoritmo, é essencial analisar os resultados obtidos, e para isso utilizaremos _backtesting_. As diversas métricas de _backtesting_ que serão mencionadas ao longo do relatório estão explicadas e detalhadas na seção @4.4tuningmodelos. Na @BackTestingMLClass, será possível visualizar o comportamento do modelo durante o período de investimentos.

==== _BackTesting_ do modelo de Machine Learning <BackTestingMLClass>

De forma geral, os resultados obtidos durante este período foram positivos. Inicialmente, o nosso _budget_ era de $dollar 1000$, e ao final do período o modelo concluiu com $dollar 1952$, resultando assim em um lucro de $dollar 952$, por outras palavras, um retorno sobre o investimento *ROI* @ROI de 95,30%. Vale ressaltar que o cálculo do _budget_ final leva em consideração o preço das _shares_ ainda em _stock_. Além disso, não basta apenas observar o lucro; é fundamental analisar e interpretar outras métricas, cujas explicações detalhadas podem ser encontradas na @statsgerais e na @4.4tuningmodelos.

Outras métricas interessantes de se comentar podem ser visualizadas na @BackTestingMLClassCode:

#figure(code(lang:"",  lang-box: (
    gutter: 5pt,
    radius: 3pt,
    outset: 3pt,
    fill: rgb("ffe05d"),
    stroke: 1pt + rgb("#3c79a9")
  ),```python
Drawdown Máximo: -21.98%
CAGR: 0.78%
Value at Risk (VaR 5%): 3.82%
  ```), caption: [Métricas e hiperpâmetros do modelo de classificação])<BackTestingMLClassCode>

No *backtesting* do modelo, o *Drawdown Máximo* @MDD de -21,98% reflete a maior perda observada durante o período de teste, indicando que o modelo enfrentou uma queda considerável em algum momento. O *CAGR* @CAGR de 0,78% sugere que o crescimento anual composto foi relativamente baixo, apontando para um retorno modesto ao longo do tempo. O *Value at Risk (VaR) de 5%* @VaR, de 3.82% o que significa que, com uma probabilidade de 5%, o portfólio poderia sofrer uma perda superior a 3,82% ($0,0382 times dollar 1000 = dollar#calc.round(0.0382*1000, digits: 2))$ em um determinado período. Esses indicadores mostram que, embora o modelo tenha apresentado ganhos, o risco de perdas significativas foi relevante durante o período analisado. Para visualizar a evolução do _backtesting_ do modelo, podemos visualizar na @BackTestingTimeMLClass.

#align(center)[
  #figure(
image("images/BackTestingTimeMLClass.png", width: 100%),
  caption: [_Backtesting_ do modelo de _Machine Learning_]
) <BackTestingTimeMLClass>
]

Ao analisar a @BackTestingTimeMLClass, é claro que o nosso _budget_ seguiu uma evolução predominantemente linear, com alguns picos de aumento e decréscimo, especialmente no final. Contudo, é importante refletir sobre essas visualizações, pois as ações da _NVIDIA_ apresentaram uma tendência constante de valorização, o que facilita a geração de lucro pelo modelo ao investir nessas ações. Para uma análise mais precisa, é necessário combinar essas observações com métricas previamente discutidas, como a @BackTestingMLClassCode.

Um exemplo relevante é o _DrawDown_ @MDD, que indica as perdas durante o período de teste. Ao examinar os valores, é evidente que houve períodos em que ocorreram perdas significativas, o que sugere que, em algumas situações, este modelo pode não ser o mais adequado. Tendo isso em mente, na próxima @4.2RLmodels, iremos explorar uma técnica que acreditamos ser mais apropriada para este tipo de problema: #link("https://www.geeksforgeeks.org/what-is-reinforcement-learning/")[*Reinforcement Learning*]. 

== Algoritmo de _Reinforcement Learning_<4.2RLmodels>

Para a componente de _Reinforcement Learning_ iremos treinar um agente para tomar decisões baseado nos dados históricos da NVIDIA. Para isso, vamos utilizar o algoritmo de _Q-Learning_:

$ Q^"new" (s_t,a_t) <- Q (s_t,a_t) + alpha times (r_t + gamma times max_a Q(s_(t+1),a) - Q(s_t,a_t)) $<Q-Learning>

#set text(13pt)
*Definição do _environment_:*
#set text(11pt)

- $a_t ("action")$ -> corresponde à ação que o agente pode tomar estando num estado $s_t$. O `num_actions` corresponde a 3 porque são as 3 ações que ele pode tomar:
  - 0 = Hold, que significa manter a posição atual sem realizar nenhuma operação;
  - 1 = Buy, que representa a compra do ativo;
  - 2 = Sell, que corresponde à venda do ativo.

- $s_t ("state")$ -> representa a condição atual do mercado baseado nas estratégias estatísticas de _trading_ ( @4.1strats ). Através de uma função `get_state()` obtemos a discretização do espaço dos estados. 

Como foi referido anteriormente, foi discutido o _trade-off_ entre a complexidade e a explicabilidade com a performance e concluímos que seria melhor utilizar, nesta função de `get_state`, a primeira estratégia das EMAs apenas. Isto deve-se ao facto das duas estratégias revelarem resultados bons o suficiente, mas com grandes margens de diferença a nível de complexidade de implementação e explicabilidade. Nesse sentido, o _Backtest_ da estratégia de _Machine Learning_ permanece como está na .

$ "int"("EMA"_("fast") times 10+"EMA"_("slow") times 10) $<EMAgetspace>

A função retorna um estado, que é um número inteiro representando a combinação das duas EMAs. O valor de cada uma da EMA é multiplicado por 10 para os valores não serem demasiado baixos e existir uma maior distribuição de estados diferentes.

- `q_table` é uma matriz inicializada com zeros de dimensões $"num_states" = 100$ x $"num_actions" = 3$, ou seja, uma tabela que armazenará os valores Q para cada combinação de estado e ação. O algoritmo Q-Learning irá preencher essa tabela com valores que representam a "qualidade" ou a expectativa de recompensa de cada ação em um determinado estado.

- *$italic("Alpha") (alpha)$* -> corresponde à taxa de aprendizagem, ou seja, é um equilíbrio entre velocidade e estabilidade. No nosso contexto, o valor inicial foi de 0.1 no *_baseline model_*, sendo posteriormente ajustado, como irá ser referido na @4.4tuningmodelos.

- *$italic("Gamma") (gamma)$* -> corresponde ao fator de desconto, que controla a importância das recompensas futuras em relação às recompensas imediatas. Iniciámos o *_baseline model_* com um valor de 0.95, que será "refinado" na @4.4tuningmodelos.
- *$italic("Epsilon") (epsilon)$* -> é a taxa de exploração, inicializada como 1.0 (irá passar pelo mesmo processo de ajuste na @4.4tuningmodelos). Por outras palavras, no início, o agente explorará aleatoriamente as ações disponíveis, sem confiar apenas na `Q-table`, daí o valor de 1. O valor de `epsilon` diminui ao longo do tempo, à medida que o agente se torna mais confiante nas suas decisões, o que é controlado pela taxa de `epsilon_decay`, iniciada como 0.995, que serve para reduzir gradualmente a taxa de exploração, permitindo que o agente explore no início e, aos poucos, foque em estratégias aprendidas: *`exploit`*.

- *$italic("reward") (r_t)$* -> a _reward_ corresponde ao desempenho do agente ao longo do tempo. Foram utilizados diferentes tipos de _reward_ diferentes:

  - *1º caso*: _reward_ só é calculada no momento da venda e reflete no lucro ou prejuízo, com base no balanço final e inicial da transação;
  - *2º caso*: _reward_ é calculada a partir do Sharpe Ratio @SharpeRatio, onde o objetivo é maximizar os lucros ao mesmo tempo que o risco é minimizado.
  
Por fim, temos as variáveis `initial_balance` que é definida com um valor inicial de carteira de $dollar 1000$; `balance` que corresponde ao valor da carteira enquanto o agente é treinado -> este valor a cada início de episódio é igual ao `initial_balance`; `position` que indica se o agente está sem ativos na sua posse (0), ou se está a "segurar" ativos (1) -> é inicializada como 0; `transaction_fee` é definida como 0.001, o que significa uma taxa de 0.1% sobre cada transação realizada.

#set text(13pt)
*Parâmetros Q-Learning _baseline model_:*
#set text(11pt)

#figure(code(lang:"",  lang-box: (
    gutter: 5pt,
    radius: 3pt,
    outset: 3pt,
    fill: rgb("ffe05d"),
    stroke: 1pt + rgb("#3c79a9")
  ),```python
num_states = 100
num_actions = 3  # 0 = Hold, 1 = Buy, 2 = Sell
q_table = np.zeros((num_states, num_actions))
alpha = 0.1
gamma = 0.95
epsilon = 1.0
epsilon_decay = 0.995
min_epsilon = 0.01
initial_balance = 1000
transaction_fee = 0.001 # 0.001*100 = 0.1% de taxa
episodes = 500 # número de episódios do algoritmo de RL
  ```), caption: [Parâmetros do _baseline model_])<paramsBASELINE>



== Avaliação, Comparação e _Fine Tune_ dos modelos de RL<4.4tuningmodelos>

Após executarmos os modelos criados, foi necessário utilizar métricas de comparação entre modelos e dar _tuning_ ao(s) melhor(es) modelo(s). 

Como métricas de _Backtesting_#footnote[Métricas de avaliação de performance: https://blankly.finance/list-of-performance-metrics/] e de comparação utilizámos a evolução do saldo/_balance_, o retorno sobre o investimento (ROI), o _Maximum Drawdown_ (MDD) e o _Value at Risk_ (VaR).

A evolução do saldo/_balance_ é, como o próprio nome indica, as variações da carteira do investidor no processo de aprendizagem do algoritmo. Esta evolução será observada nos resultados com um gráfico do último episódio (500).


O _Return on Investment_ (ROI) é uma métrica financeira que mede a eficiência ou lucratividade de um investimento. É dado em termos percentuais e informa o retorno obtido em relação ao custo inicial do investimento.

$ "ROI" = ("balanço final" - "balanço inicial")/"balanço inicial" times 100 $<ROI>

O _Maximum Drawdown_ (MDD)#footnote[Explicação detalhada do MDD: https://www.investopedia.com/terms/m/maximum-drawdown-mdd.asp] é uma métrica utilizada para avaliar a maior perda de uma série de retornos de investimentos em relação a um pico anterior. Ele mede o risco de uma estratégia de investimento ou de um portfólio, onde reflete o pior cenário de perda, durante um período específico.

O MDD é medido como uma percentagem negativa, que indica a perda máxima relativamente ao valor máximo histórico. Assim, um MDD de 0% indica que o valor do portfólio nunca diminuiu em relação ao seu pico anterior e simboliza um investimento constante. Da mesma forma, quanto maior o MDD (mais negativo), maior será a perda em relação ao ponto máximo atingido e, consequentemente, maior será o risco.

$  "MDD" = min ((V_t-V_"Peak")/V_"Peak") $<MDD>

O _Value at Risk_ (VaR) é uma métrica estatística que serve para medir o risco de perda de um portfólio ou investimento, em um determinado intervalo de tempo e com um nível de confiança específico. A métrica responde à pergunta: "Qual é a perda máxima esperada para o meu portfólio, em condições normais de mercado, com uma determinada probabilidade?"

Por exemplo, se o investimento inicial for de $dollar 1000$ e o valor de $"VaR"$ for 2.11% isso indica que a perda diária máxima do saldo não excederá os 2.11%, com intervalo de confiança de 95%. Ou seja, em 5% dos piores dias, a perda máxima no portfólio seria de $0,0211 times dollar 1000 = dollar#calc.round(0.0211*1000, digits: 2)$.

$ "VaR"_((alpha=0.95)) "(%)"=-"Quantile"("DailyReturns") times 100 $ <VaR>

Para refinar os modelos (_fine tune_), foram ajustados os valores dos parâmetros na @paramsBASELINE, com base na sua _performance_. Inicialmente, foi dada uma lista que continha valores distintos para as várias métricas presentes na fórmula do _Q-Learning_, onde eram executadas todas as combinações possíveis através da biblioteca _itertools_ do _Python_. Contudo, como esta abordagem tem uma grande complexidade temporal, foi ajustada para um _Random Search_,  que otimiza a escolha dos parâmetros com base nos resultados obtidos ao longo dos episódios. 

Os vários valores testados foram os seguintes:

#figure(code(lang:"",  lang-box: (
    gutter: 5pt,
    radius: 3pt,
    outset: 3pt,
    fill: rgb("ffe05d"),
    stroke: 1pt + rgb("#3c79a9")
  ),```python
alpha_space = [0.1, 0.2, 0.5]
gamma_space = [0.9, 0.95, 0.99]
epsilon_space = [1.0, 0.7, 0.5]
epsilon_decay_space = [0.995, 0.99]

  ```), caption: [Parâmetros que serão alterados no _fine-tune_])<paramsRandomSearch>

Na fase de _fine-tune_ serão submetidas duas propostas:

- Uma focada na maximização do _Final Balance_, em que serão utilizados os parâmetros seguintes (após a execução do _Random Search_):

#figure(code(lang:"",  lang-box: (
    gutter: 5pt,
    radius: 3pt,
    outset: 3pt,
    fill: rgb("ffe05d"),
    stroke: 1pt + rgb("#3c79a9")
  ),```python
alpha = 0.5
gamma = 0.95
epsilon = 1.0
epsilon_decay = 0.995
min_epsilon = 0.01
  ```), caption: [Parâmetros do _tunning model_ focado no Final Balance])<paramsTUNNINGFinalBalance>

- Outra focalizada na maximização do _Sharpe Ratio_, onde serão utilizados estes parâmetros (após a execução do _Random Search_)

#figure(code(lang:"",  lang-box: (
    gutter: 5pt,
    radius: 3pt,
    outset: 3pt,
    fill: rgb("ffe05d"),
    stroke: 1pt + rgb("#3c79a9")
  ),```python
alpha = 0.5
gamma = 0.95
epsilon = 0.5
epsilon_decay = 0.99
  ```), caption: [Parâmetros do _tunning model_ focado no _Sharpe Ratio_])<paramsTUNNINGSharpRatio>

Com toda a metodologia apresentada, serão apresentados os resultados obtidos dos modelos de _Reinforcement Learning_, bem como todas as várias tentativas e ajustes efetuados. Os parâmetros para esses ajustes foram descritos nesta secção ( @4.4tuningmodelos).
  
#pagebreak()

= Resultados <5.Resultados>

Nesta secção serão apresentados os resultados dos algoritmos treinados por um agente de _Reinforcement Learning_ e depois serão ajustados os hiperparâmetros desses modelos. De notar que: 

#rect(fill: rgb("f8c3c0"), inset: 12pt,
  width: 100%,
  stroke: 0.1pt,  radius: (
    left: 5pt,
    right: 5pt,
  ))[#quote(attribution: [Grupo OEOD7])[Os valores apresentados podem sofrer algumas alterações ao executar o código porque a escolha do modelo optar por _exploitation_ ou _exploration_ sugere valores aleatórios, que tem implicação direta na Q-Table.]]



Após executarmos o 1º algoritmo de _Reinforcement Learning_ obtivemos os seguintes resultados:

- $"final balance": dollar 926.96$
- $"ROI"= -7.30%$
- $"MDD"= -17.27%$
- $"VaR (95% confiança)"= 0%$

#align(center)[
  #figure(
image("images/BaselineModelAlgo1.png", width: 100%),
  caption: [_Backtest_ do $"1º caso" r_t$: através do balanço @paramsBASELINE[(parâmetros _baseline_)]]
)<Modelo1>
]

Através destas métricas conseguimos perceber que o modelo gerou uma perda líquida ao longo do período de treino e execução. Conseguimos ver isto, quer pelo valor final de carteira (inferior ao inicial de $dollar 1000$), quer pelo ROI (-7.30%). 

O MDD de -17.27% representa um valor moderado que remete o modelo foi mais conservador e que enfrentou menos volatilidade, mas não foi capaz de se recuperar das perdas para gerar lucros.

O valor de VaR já seria de se esperar que 0 porque houve prejuízo. Contudo, esta métrica não traduz bem os maus resultados do modelo.

Ao observar a @Modelo1, é possível verificar que o modelo fica bastante tempo a dar "Hold" e perto do final ele corre um risco baixo para tentar gerar lucro. Porém, acaba por tomar decisões fracas e comprar o ativo numa altura de baixa, que origina numa cadeia sucessiva de dificuldade em gerar lucro. 

#pagebreak()

- $"final balance": dollar 1113.08$
- $"ROI"= 11.31%$
- $"MDD"= -6.21%$
- $"VaR (95% confiança)"= 0%$

#align(center)[
  #figure(
image("images/Graficos-Reward_Sharp2Baseline.png", width: 100%),
  caption: [_Backtest_ do $"2º caso" r_t$: através do _Sharpe Ratio_ @paramsBASELINE[(parâmetros _baseline_)]]
)
]

O modelo apresentou um _final balance_ superior ao inicial de $1000$, que indica um lucro líquido no período de _backtesting_. Apesar do resultado positivo, o aumento no valor da carteira é modesto, pois a estratégia continua a ser bastante conservadora e sem muito risco (bastante tempo a dar "Hold" ao ativo). O ROI de 11.31%, à semelhança do _final balance_, demonstra que o modelo foi capaz de gerar um retorno positivo sobre o capital investido.

O MDD de -6.21% indica que o modelo conseguiu limitar as perdas em relação ao pico acumulado do saldo. Este valor relativamente baixo sugere um gerenciamento de risco eficaz, com pouca exposição a grandes flutuações no mercado. Todavia, este valor pode ser "enganador" porque, no período todo de teste, o investimento foi muito reduzido.

O Value at Risk em 0%, para um intervalo de confiança de 95%, que indica que o modelo operou de forma extremamente "preguiçosa" no dia-a-dia, sem apresentar grandes riscos diários. No entanto, como o VaR é uma métrica de curto prazo, ele não reflete totalmente os ganhos ou perdas acumulados.

Os gráficos estão muito refletidos nas métricas apresentadas porque não existiu uma flutuação de investimentos. Por outras palavras, o modelo foi bastante controlado na sua aprendizagem, não 

#line(length: 100%,stroke: (paint: black, thickness: 1pt, dash: "dashed"))

Os resultados com os valores de parâmetros do _baseline model_ ficaram aquém do esperado, talvez devido ao valor _learning rate_ ($alpha$) ser baixo. O valor de 0.1 provavelmente impediu o modelo de atualizar a Q-Table de forma significativa a cada iteração, resultando numa convergência lenta ou numa falta de adaptação aos padrões do mercado. Um _learning rate_ baixo pode limitar a capacidade do modelo de aprender rapidamente com as recompensas recebidas, especialmente em cenários onde as condições mudam frequentemente, como no nosso caso de _stock trading_.


#pagebreak()

Após o _Backtesting_ foram atualizados os hiperparâmetros do algoritmo de _Reinforcement-Learning_, através dos valores do _Random Search_ (@paramsRandomSearch) e focados em duas métricas diferentes: o _final balance_ e _Sharpe Ratio_. 

Começaremos por ver os valores obtidos focados para o Final Balance:



- $"final balance": dollar 1315.21$
- $"ROI"= 31.52%$
- $"MDD"= -19.96%$
- $"VaR (95% confiança)"= 0%$

#align(center)[
  #figure(
image("images/finetunningFinalBalance1.png", width: 100%),
  caption: [_Backtest_ do $"1º caso" r_t$: através do _Final Balance_ @paramsTUNNINGFinalBalance[(parâmetros _tunning_ Final Balance)]]
)
]

O _final balance_  de $dollar 1315.21$ representa um aumento de 31.52% (ROI) em relação ao valor inicial de $dollar 1000$. Esse resultado indica que o modelo conseguiu gerar lucros substanciais ao longo do período de _backtesting_, o que demonstra um desempenho positivo. 


O MDD de -19.96% evidencia que, em algum momento, o modelo enfrentou uma queda considerável no saldo durante a fase de treino. Contudo, o valor está dentro de um intervalo razoável para estratégias de risco moderado, o que sugere uma gestão adequada de perdas.

O VaR de 0% (a 95% de confiança) implica que o modelo teve um risco muito baixo de apresentar perdas no _final balance_ ao longo do tempo. Embora isso seja um bom sinal, também pode sugerir que o modelo priorizou a estabilidade em detrimento de estratégias mais "agressivas".

A partir de aproximadamente 1100 dias, observa-se uma inclinação significativa no saldo, sugerindo que o modelo identificou padrões ou oportunidades no mercado que, consequentemente, resultou numa sequência de operações lucrativas.
Após o pico, o saldo estabiliza, que pode refletir decisões mais seguras após ser atingido um nível de lucro confortável.

#pagebreak()

- $"final balance": dollar 8273.28$
- $"ROI"= 727.33%$
- $"MDD"= 44.91%$
- $"VaR (95% confiança)"= 0.03%$

#align(center)[
  #figure(
image("images/finetunningFinalBalance2.png", width: 100%),
  caption: [_Backtest_ do $"2º caso" r_t$: através do _Final Balance_ @paramsTUNNINGFinalBalance[(parâmetros _tunning_ _Final Balance_)]]
) <FixeGranaMuita>
]

Os valores do saldo final e do ROI foram surpreendentemente positivos, tendo sido obtido um retorno sobre o investimento de mais de 700%.

Um _Maximum Drawdown_ de -44.91% indica que o modelo enfrentou momentos de alta volatilidade e risco durante o treinamento. Apesar de ser um valor elevado, o saldo final sugere que o modelo conseguiu superar as perdas temporárias para alcançar resultados positivos nos passos seguintes. Isso mostra que, embora mais agressivo, o modelo foi resiliente.

O VaR de 0.03% (a 95% de confiança) implica que o modelo apresentou baixo risco de perdas severas no saldo final. Isso contrasta com o MDD mais elevado e indica que as perdas mais extremas foram pontuais e não impactaram o valor da carteira de forma contínua.

#line(length: 100%,stroke: (paint: black, thickness: 1pt, dash: "dashed"))

Após o ajuste dos hiperparâmetros através no _Random Search_, os resultados apresentados refletem uma melhoria significativa no desempenho do modelo focado no _final balance_.

Este ajuste de parâmetros, em particular o aumento no $alpha=0.5$, parece ter permitido ao modelo aprender de forma mais eficiente durante o treino. Além disso, o `epsilon_decay` (0.995) e o `min_epsilon` (0.01) garantiram um equilíbrio adequado entre exploração e exploração, permitindo ao modelo explorar oportunidades no início e refinar sua política no final.

Embora o MDD mostre que ainda houve momentos de maior risco, o saldo final e o ROI positivos demonstram que a estratégia geral com estes parâmetros foi bem sucedida. Isto deve-se ao facto de estarmos a focar-nos no valor do _final balance_ apenas, em que o modelo não dá um peso significativo ao risco. Ajustes na medida do risco podem explorar uma maior diversificação para reduzir o _Drawdown_ enquanto mantêm a lucratividade.

#pagebreak()

- $"final balance": dollar 2081.65$
- $"ROI"= 108.16%$
- $"MDD"= -84.33%$
- $"VaR (95% confiança)"= 0.04%$

#align(center)[
  #figure(
image("images/finetunningSharpRatio1Final.png", width: 100%),
  caption: [_Backtest_ do $"1º caso" r_t$: através do _Sharpe Ratio_ @paramsTUNNINGSharpRatio[(parâmetros _tunning_ _Sharpe Ratio_)]]
)<figura12>
]

O saldo final de $dollar 2081.65$ indica um crescimento significativo em relação aos $dollar 1000$ iniciais, o que demonstra que o modelo conseguiu gerar lucro substancial. Podemos ver isto refletido no ROI de 108.16%, que diz que o investimento foi duplicado no período analisado.

O MDD de -84.33% é extremamente elevado, o que significa que, em determinado momento, o saldo do modelo caiu para apenas 15.67% do capital inicial antes de se recuperar. Este valor alto de _drawdown_ indica que o modelo esteve exposto a decisões ou condições de mercado muito desfavoráveis, colocando o capital num risco risco significativo. 

O VaR de 0.04% (a 95% de confiança) sugere um risco baixo de perdas severas no saldo consolidado, mas essa métrica não captura adequadamente o risco elevado representado pelo MDD. Por essa razão, o VaR deve ser interpretado com cuidado neste contexto, já que não reflete os momentos de grande volatilidade enfrentados pelo modelo antes de chegar a uma estabilidade (nas últimas etapas do modelo; em que o saldo manteve-se mais ou menos constante).

Para além disso, pela @figura12, conseguimos perceber que há um momento do tempo em que são efetuadas várias ações em que o modelo explora mais e onde o risco aumenta. Após esta fase, os investimentos estabilizam e o saldo não é tão afetado, talvez pela capacidade de aprendizagem através da Q-table ter mais peso.





#pagebreak()

- $"final balance": dollar 1279.15$
- $"ROI"= 27.91%$
- $"MDD"= -25.42%$
- $"VaR (95% confiança)"= 0%$

#align(center)[
  #figure(
image("images/finetunningSharpRatio2Final.png", width: 100%),
  caption: [_Backtest_ do $"2º caso" r_t$: através do _Sharpe Ratio_ @paramsTUNNINGSharpRatio[(parâmetros _tunning_ _Sharpe Ratio_)]]
)
]

O _final balance_ de $dollar 1279.15$ representa um crescimento em relação ao inicial de $dollar 1000$, indicando que o modelo conseguiu gerar lucro ao longo do período. Este resultado traduz num desempenho razoável, com um retorno de 27.91%. O que mostra que o modelo teve um crescimento limitado no capital inicial, mas que pode ser mais adequado para cenários em que há preservação de capital e de risco.

O _Drawdown_ máximo de -25.42% reflete um período significativo de perdas temporárias durante o _backtesting_. Esse valor sugere que o modelo foi enfrentou dificuldades em alguns momentos, chegando a perder até um quarto do capital inicial, antes de se recuperar.

O VaR de 0% (a 95% de confiança) indica que, no saldo final, o modelo apresentou um risco reduzido de perdas severas. Isto significa que, ao longo do período analisado, o saldo manteve-se suficientemente estável no momento de maior impacto sobre os resultados.

#line(length: 100%,stroke: (paint: black, thickness: 1pt, dash: "dashed"))


Após analisar os resultados focados no _Sharpe Ratio_, podemos concluir que os modelos apresentaram um comportamento mais estável e menos arriscado em comparação aos anteriores, demonstrando uma melhor preservação do capital, ao gerenciar o risco de forma mais eficaz. Além disso, os valores configurados para `epsilon` (0.5) e `epsilon_decay` (0.99) proporcionaram uma maior "confiança" na Q-table, favorecendo decisões mais consistentes e equilibradas ao longo do tempo.



#pagebreak()
= Conclusões <6.Conclusões>

Pelos resultados obtidos, concluímos que a _NVIDIA_ é uma empresa em constante evolução #footnote[https://www.linkedin.com/pulse/ascens%C3%A3o-exponencial-da-nvidia-conquistas-passadas-e-ewaldo-del-valle-gchzf/], sustentada pela sua incrível tecnologia focada em inteligência artificial e pelo desenvolvimento das _GPUs_ mais potentes do mercado. Consequentemente, as ações da _NVIDIA_ têm apresentado um crescimento exponencial #footnote[https://pt.investing.com/equities/nvidia-corp-technical] (Visualizar @AnexoAdash[]) resultado do elevado prestígio que a empresa tem alcançado.

Dado este contexto, já era de se esperar que investir na _NVIDIA_ pudesse ser considerado "seguro" – ainda que seja sempre necessário ter em mente que o mercado acionista envolve #link("https://www.degiro.pt/riscos-de-investir")[riscos inerentes]. O impressionante crescimento da _NVIDIA_ reflete-se numa elevada valorização das suas ações, tornando mais previsível o seu comportamento futuro e oferecendo, aparentemente, uma oportunidade atrativa para investidores.

Com base nas nossas análises e resultados, as estatísticas ( @3.3stats ) demonstram que, apesar de ser relativamente "seguro" investir na _NVIDIA_, tal não se traduz, necessariamente, em lucros significativos em larga escala. Para testar esta premissa, foram exploradas duas estratégiaspara prever o comportamento das ações da NVIDIA: 
1. * @MachineLearning[Modelos de machine learning - Secção] (@MLregressão[regressão - Secção] e @MLclassificação[classificação - Secção])*
2. * @4.2RLmodels[Reinforcement learning - Secção]* (apoiados pela estratégia de *@CMME[crossover de média móvel exponencial - Secção]).*

#align(center)[*Modelos de Machine Learning*]

#line(length: 100%)

   - O modelo de regressão mostrou-se inadequado para este contexto, pois o objetivo era criar um sistema capaz de comprar e vender _shares_, algo inviável para este tipo de abordagem. Estes modelos limitam-se à previsão de valores, como a variável `close`, utilizada neste caso. Embora promissora, esta abordagem enfrenta desafios significativos e permanece em desenvolvimento#footnote[https://repositorio.ulisboa.pt/handle/10400.5/19517]. Mesmo com modelos avançados como o #link("https://didatica.tech/lstm-long-short-term-memory/")[LSTM], o problema de overfitting manteve-se evidente (ver @MLRegPrevCloseVSRealClose). Este resultado era esperado, dada a alta volatilidade do mercado acionista, que dificulta a previsão precisa dos seus valores.

   - Por outro lado, o modelo de classificação revelou-se mais adequado, proporcionando resultados interessantes, apesar de diversas limitações. As _labels_ tiveram de ser definidas manualmente pelo grupo, utilizando um _threshold_, o que dificultou determinar a melhor altura para comprar ou vender. Além disso, este modelo não consegue adaptar-se ao longo do tempo, sendo treinado apenas uma vez – como discutido na @BackTestingMLClass. Ainda assim, o desempenho foi surpreendente, alcançando um lucro de $dollar 952$, um resultado que excedeu as expectativas do grupo, embora tenhamos plena consciência de que não é viável para aplicação no mundo real.


#align(center + horizon)[*Modelos de Reinforcement Learning*]
#line(length: 100%)
   - Este modelo foi consideravelmente mais trabalhoso do que o de _Machine Learning_. Inicialmente, foi necessário definir uma estratégia, o que exigiu um estudo detalhado sobre o comportamento das ações da _NVIDIA_. Após esta análise, o grupo concluiu que a melhor abordagem seria utilizar a EMA @CMMEFormula, dado o crescimento exponencial das ações da empresa nos últimos meses. Na @tabcrossoverEMA, são apresentados vários valores de `span` aplicados na estratégia de _crossover_, sendo fundamental realizar múltiplos testes para maximizar o *CumReturn* @CumReturnFormula. Após diversas iterações, determinou-se que os parâmetros ideais eram: EMA _fast_ de 50 e EMA _slow_ de 140.

   - Com a estratégia definida, passámos finalmente para a criação do modelo de _reinforcement learning_. Para tal, estabelecemos algumas bases, como o número de ações possíveis (*Buy*, *Sell*, *Hold*), e implementámos e adaptámos a estratégia mencionada anteriormente. De seguida, optámos pelo algoritmo de #link("https://www.geeksforgeeks.org/q-learning-in-python/")[_Q-learning_], tendo criado 2 diferentes: o primeiro com *reward* do balanço atual - inicial, e o segundo com *reward* do *sharpe ratio*.
   
   - A seguir, chegámos à fase mais desafiante deste trabalho: a definição dos hiperparâmetros. Para tal, foram definidas 3 modelos:
   
    - O modelo baseline ( @paramsBASELINE ) não teve um desempenho satisfatório, chegando até a gerar prejuízo quando comparado aos modelos de machine learning.
    - Para os restantes modelos, estes foram baseados na técnica de #link("https://medium.com/@hammad.ai/tuning-model-hyperparameters-with-random-search-f4c1cc88f528")[_random search_], com o objetivo de realizar o _tuning_ dos hiperparâmetros. Consequentemente, chegámos aos seguintes resultados:
      - *Modelo focado em Lucro* (@paramsTUNNINGFinalBalance): Este modelo apresentou um risco elevado, como evidenciado pelas várias tentativas do grupo ao rodar o código, que resultaram sempre em resultados insatisfatórios, como os demonstrados na @Erro. Contudo, apesar desses desafios, foi este o modelo que obteve o melhor resultado em termos de lucro, conforme ilustrado em @FixeGranaMuita.

      
      
      
      - *Modelo focado em _Sharpe Ratio_* (@paramsTUNNINGSharpRatio): Ao contrário do outro modelo, este tinha um foco principal e ser seguro, sendo também a recomendação principal do #link("https://medium.com/@amanatulla1606/fine-tuning-the-model-what-why-and-how-e7fa52bc8ddf")[_Fine-Tune Algorythm_]. Estes hiperparâmetros estavam mais focados em garantir a obtenção de lucro. O objetivo foi atingido, já que ambas as versões do modelo geraram lucro, sendo que uma delas superou o modelo de *machine learning* em termos de lucro, embora com um desempenho inferior aos hiperparâmetros otimizados para maximizar o lucro.

      
    - Estes modelos destacaram-se por serem mais apropriados para este tipo de problema, pois têm a capacidade de melhorar continuamente com o passar do tempo, uma característica que os modelos de machine learning não conseguem replicar de forma eficaz.

#align(center)[*Reflexão Final*]
#line(length: 100%)

Concluímos que, embora os modelos desenvolvidos ao longo deste trabalho tenham apresentado lucros, é importante destacar que a NVIDIA é um caso especial, cuja previsibilidade facilitou a obtenção de resultados positivos. Este facto contribuiu significativamente para os lucros registados. Assim, ressaltamos que estes modelos não são suficientemente robustos para serem aplicados no mundo real com garantias de lucro, uma vez que apresentam limitações, especialmente no caso dos modelos de *machine learning*, em que os resultados dependeram, em parte, de "sorte". 

Adicionalmente, concluímos que os modelos de *reinforcement learning* são mais adequados para este tipo de problemas, pois têm a capacidade de se adaptar e melhorar com o tempo, algo que os modelos de *machine learning* não conseguem fazer da mesma forma. O código deste trabalho encontra-se no seguinte repositório: #link("https://github.com/JoniFB03/OEOD")[GitHub].


#align(center)[
  #figure(
image("images/nvidia.jpg", width: 30%),
  caption: [Logotipo da _NVIDIA_]
)
] 

#pagebreak()
#set heading(numbering: none)
= Anexos <Anexos>
#set heading(numbering: (level1, level2,..levels ) => {
  if (levels.pos().len() > 0) {
    return []
  }
  ("Anexo", str.from-unicode(level2 + 64)/*, "-"*/).join(" ")
}) // seria so usar counter(heading).display("I") se nao tivesse o resto
//show heading(level:3)

== - _Dashboard_ com os dados iniciais<AnexoAdash>

#align(center)[
  #figure(
image("images/OHLC.png", width: 95%),
  caption: [Gráfico OHLC (_Dashboard_)]
) <OHLC>
] 

#align(center)[
  #figure(
image("images/volume.png", width: 95%),
  caption: [Variável `Volume` (_Dashboard_)]
) <volumedata>
]


== - Gráficos EMA para valores da @tabcrossoverEMA (restantes)<graficosCrossover>

#align(center)[
  #figure(
image("images/ema50_150.png", width: 85%),
  caption: [Estratégia de _Crossover_ EMA(_fast_:50, _slow_:150)]
)
] 

#align(center)[
  #figure(
image("images/ema50_130.png", width: 85%),
  caption: [Estratégia de _Crossover_ EMA(_fast_:50, _slow_:130)]
)
] 

#align(center)[
  #figure(
image("images/ema40_140.png", width: 85%),
  caption: [Estratégia de _Crossover_ EMA(_fast_:40, _slow_:140)]
)
] 

#align(center)[
  #figure(
image("images/ema20_140.png", width: 85%),
  caption: [Estratégia de _Crossover_ EMA(_fast_:20, _slow_:140)]
)
] 

#pagebreak()

== - Mau exemplo de parâmetros Reinforcemente Learning


#align(center)[
  #figure(
image("images/BaseLineModelLRZero.png", width: 85%),
  caption: [Erro do BackTesting]
) <Erro>
] 

#figure(code(lang:"",  lang-box: (
    gutter: 5pt,
    radius: 3pt,
    outset: 3pt,
    fill: rgb("ffe05d"),
    stroke: 1pt + rgb("#3c79a9")
  ),```python
Final balance: 1000
Return on Investment (ROI): 0.00%
Maximum Drawdown (MDD): 0.00%
Value at Risk (95% confidence): 0.00%

  ```), caption: [Métricas de um modelo de *Reinforcement Learning* quando a taxa de aprendizagem (_learning rate_) se aproxima de 0.])<BaseLineModelRLLRzero>