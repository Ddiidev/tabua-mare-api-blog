Quando penso num passeio a uma piscina natural, logo vem a pergunta: a maré vai estar boa na hora que eu chegar? A tábua ajuda a planejar, mas tem um detalhe: a previsão costuma ser de um porto, enquanto o passeio pode acontecer em outro ponto da costa.

Eu quis deixar essa consulta mais prática: toque no botão, permita o acesso à localização e veja a previsão do porto mais próximo. O gráfico dá uma ideia de como a maré deve estar naquele horário. Use como referência para conversar com a operadora; a condição na piscina natural pode ser diferente.

<div id="tide-widget" class="tide-widget" aria-labelledby="tide-widget-title"><style>
#tide-widget{max-width:820px;margin:2rem auto;padding:clamp(1rem,3vw,1.6rem);border:1px solid var(--line);border-radius:1rem;background:var(--surface-muted);color:var(--text)}
#tide-widget .tide-title{margin:0 0 .5rem;color:var(--ocean-950);font-size:clamp(1.2rem,3vw,1.55rem);line-height:1.25}
#tide-widget .tide-intro{margin:0 0 1rem;color:var(--muted)}
#tide-widget .tide-button{display:inline-flex;align-items:center;justify-content:center;min-height:46px;padding:.7rem 1rem;border:0;border-radius:.55rem;background:var(--ocean-800);color:#fff;font:inherit;font-weight:700;cursor:pointer}
#tide-widget .tide-button:hover{filter:brightness(.92)}
#tide-widget .tide-button:focus-visible{outline:3px solid var(--sun-400);outline-offset:3px}
#tide-widget .tide-button:disabled{cursor:wait;opacity:.7}
#tide-widget .tide-status{min-height:1.5em;margin:.8rem 0 0;color:var(--muted);font-size:.9rem}
#tide-widget .tide-status[data-state="error"]{color:#9b3026}
#tide-widget .tide-result{margin-top:1.25rem;padding-top:1rem;border-top:1px solid var(--line)}
#tide-widget .tide-port{margin:0 0 .25rem;color:var(--ocean-950);font-size:1rem;font-weight:700}
#tide-widget .tide-time{margin:0 0 .85rem;color:var(--muted);font-size:.85rem}
#tide-widget .tide-summary{margin:.5rem 0 0;color:var(--text);font-weight:600}
#tide-widget .tide-chart{width:100%;margin:.6rem 0 0;overflow:hidden}
#tide-widget .tide-svg{display:block;width:100%;height:auto;overflow:visible}
#tide-widget .tide-chart-grid{stroke:var(--line);stroke-width:1}
#tide-widget .tide-chart-axis{fill:var(--muted);font:12px system-ui,sans-serif}
#tide-widget .tide-chart-line{fill:none;stroke:var(--ocean-600);stroke-width:3;stroke-dasharray:7 5;stroke-linecap:round;stroke-linejoin:round}
#tide-widget .tide-event-dot{fill:var(--ocean-800);stroke:var(--surface);stroke-width:2}
#tide-widget .tide-now-line{stroke:#cf6335;stroke-width:2;stroke-dasharray:4 4}
#tide-widget .tide-now-dot{fill:#cf6335;stroke:var(--surface);stroke-width:2}
#tide-widget .tide-legend{display:flex;flex-wrap:wrap;gap:.5rem 1rem;margin:.5rem 0 0;color:var(--muted);font-size:.78rem}
#tide-widget .tide-note{margin:.75rem 0 0;color:var(--muted);font-size:.78rem;line-height:1.5}
#tide-widget [hidden]{display:none!important}
@media(max-width:520px){#tide-widget .tide-button{width:100%}#tide-widget .tide-chart-axis{font-size:11px}}
</style><h2 id="tide-widget-title" class="tide-title">Consulte a previsão perto de você</h2><p class="tide-intro">Toque no botão e permita o acesso à localização. Ela será enviada para encontrar o porto mais próximo e consultar a previsão de hoje.</p><button id="tide-query" class="tide-button" type="button">Usar minha localização e consultar</button><p id="tide-status" class="tide-status" role="status" aria-live="polite">A consulta começa quando você tocar no botão.</p><div id="tide-result" class="tide-result" hidden><p id="tide-port" class="tide-port"></p><p id="tide-time" class="tide-time"></p><div class="tide-chart"><svg id="tide-chart" class="tide-svg" viewBox="0 0 680 260" role="img" aria-label="Gráfico da previsão de maré"></svg></div><div class="tide-legend"><span>Horários da previsão</span><span>Marcador laranja: agora</span></div><p id="tide-summary" class="tide-summary"></p><p class="tide-note">Os pontos mostram os horários previstos. A linha entre eles é uma estimativa, não uma medição em tempo real. O porto mais próximo pode não representar exatamente a praia.</p></div><script>
(() => {
  const widget = document.getElementById("tide-widget");
  if (!widget) return;
  const button = widget.querySelector("#tide-query");
  const status = widget.querySelector("#tide-status");
  const resultBox = widget.querySelector("#tide-result");
  const portLabel = widget.querySelector("#tide-port");
  const timeLabel = widget.querySelector("#tide-time");
  const summary = widget.querySelector("#tide-summary");
  const chart = widget.querySelector("#tide-chart");
  const apiBase = window.location.hostname === "tabuamare.api.br"
    ? `${window.location.origin}/api/v2`
    : "https://tabuamare.api.br/api/v2";
  const svgNamespace = "http://www.w3.org/2000/svg";
  const pad = value => String(value).padStart(2, "0");
  widget.dataset.scriptReady = "true";
  function setStatus(message, state = "info") {
    status.textContent = message;
    status.dataset.state = state;
  }
  function getLocation() {
    if (!navigator.geolocation) return Promise.reject(new Error("geolocation-unavailable"));
    return new Promise((resolve, reject) => navigator.geolocation.getCurrentPosition(resolve, reject, {
      enableHighAccuracy: true,
      maximumAge: 0,
      timeout: 15000
    }));
  }
  async function getJson(url) {
    const response = await fetch(url, { headers: { Accept: "application/json" } });
    const payload = await response.json();
    if (!response.ok || payload.error) throw new Error(payload.error?.message || `HTTP ${response.status}`);
    return payload;
  }
  function svgElement(name, attributes = {}, text = "") {
    const element = document.createElementNS(svgNamespace, name);
    for (const [key, value] of Object.entries(attributes)) element.setAttribute(key, String(value));
    if (text) element.textContent = text;
    return element;
  }
  function formatLevel(value) {
    return new Intl.NumberFormat("pt-BR", { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(value);
  }
  function collectEvents(payloads, todayStart) {
    const events = [];
    for (const payload of payloads) {
      for (const place of payload.data || []) {
        for (const month of place.months || []) {
          for (const day of month.days || []) {
            for (const item of day.hours || []) {
              const [hour, minute] = String(item.hour).split(":").map(Number);
              const level = Number(item.level);
              if (!Number.isFinite(hour) || !Number.isFinite(minute) || !Number.isFinite(level)) continue;
              const eventTime = Date.UTC(place.year, month.month - 1, day.day, hour, minute);
              events.push({
                minute: (eventTime - todayStart) / 60000,
                hour: `${pad(hour)}:${pad(minute)}`,
                day: Number(day.day),
                month: Number(month.month),
                year: Number(place.year),
                level
              });
            }
          }
        }
      }
    }
    const unique = new Map(events.map(event => [`${event.year}-${event.month}-${event.day}-${event.hour}`, event]));
    return [...unique.values()].sort((a, b) => a.minute - b.minute);
  }
  function drawChart(dayEvents, nowMinute, nowLevel, currentYear, currentMonth, currentDay) {
    const width = 680;
    const height = 260;
    const left = 56;
    const right = 18;
    const top = 18;
    const bottom = 34;
    const levels = dayEvents.map(event => event.level);
    if (nowLevel !== null) levels.push(nowLevel);
    let minLevel = Math.min(...levels);
    let maxLevel = Math.max(...levels);
    const padding = Math.max((maxLevel - minLevel) * 0.15, 0.08);
    minLevel -= padding;
    maxLevel += padding;
    const x = minute => left + (minute / 1440) * (width - left - right);
    const y = level => top + ((maxLevel - level) / (maxLevel - minLevel)) * (height - top - bottom);
    chart.replaceChildren();
    chart.setAttribute("viewBox", `0 0 ${width} ${height}`);
    chart.setAttribute("aria-label", `Previsão de maré para ${portLabel.textContent}, em ${pad(currentDay)}/${pad(currentMonth)}/${currentYear}`);
    chart.appendChild(svgElement("title", {}, "Previsão de maré ao longo do dia. A linha entre os pontos é uma estimativa."));
    for (let index = 0; index < 3; index++) {
      const level = maxLevel - ((maxLevel - minLevel) * index / 2);
      const lineY = y(level);
      chart.appendChild(svgElement("line", { x1: left, y1: lineY, x2: width - right, y2: lineY, class: "tide-chart-grid" }));
      chart.appendChild(svgElement("text", { x: left - 8, y: lineY + 4, "text-anchor": "end", class: "tide-chart-axis" }, formatLevel(level)));
    }
    for (let hour = 0; hour <= 24; hour += 6) {
      const minute = hour * 60;
      const tickX = x(minute);
      chart.appendChild(svgElement("line", { x1: tickX, y1: top, x2: tickX, y2: height - bottom, class: "tide-chart-grid" }));
      chart.appendChild(svgElement("text", { x: tickX, y: height - 10, "text-anchor": "middle", class: "tide-chart-axis" }, `${pad(hour)}h`));
    }
    const path = dayEvents.map((event, index) => `${index ? "L" : "M"} ${x(event.minute).toFixed(1)} ${y(event.level).toFixed(1)}`).join(" ");
    if (path) chart.appendChild(svgElement("path", { d: path, class: "tide-chart-line" }));
    for (const event of dayEvents) {
      const dot = svgElement("circle", { cx: x(event.minute), cy: y(event.level), r: 5, class: "tide-event-dot" });
      dot.appendChild(svgElement("title", {}, `${event.hour} · ${formatLevel(event.level)} m`));
      chart.appendChild(dot);
    }
    const nowX = x(nowMinute);
    chart.appendChild(svgElement("line", { x1: nowX, y1: top, x2: nowX, y2: height - bottom, class: "tide-now-line" }));
    if (nowLevel !== null) chart.appendChild(svgElement("circle", { cx: nowX, cy: y(nowLevel), r: 6, class: "tide-now-dot" }));
    chart.appendChild(svgElement("text", { x: Math.min(Math.max(nowX, left + 18), width - right - 18), y: top - 4, "text-anchor": "middle", class: "tide-chart-axis" }, "agora"));
  }
  function showError(error) {
    if (error && error.code === 1) return setStatus("Localização não autorizada. Libere a permissão no navegador e tente de novo.", "error");
    if (error && error.code === 2) return setStatus("O navegador não conseguiu determinar sua localização. Tente novamente em outro ponto.", "error");
    if (error && error.code === 3) return setStatus("A localização demorou demais para responder. Tente de novo.", "error");
    if (error && error.message === "geolocation-unavailable") return setStatus("Não consegui acessar sua localização por este navegador. Você pode abrir o playground mais abaixo.", "error");
    if (error && error.message === "harbor-not-found") return setStatus("Não encontrei uma previsão para este local. Tente outra vez mais tarde.", "error");
    if (error && error.message === "timezone-not-found") return setStatus("Não consegui identificar o horário local deste porto. Tente outra vez mais tarde.", "error");
    if (error && error.message === "no-tide-data") return setStatus("Não encontrei informações suficientes para montar o gráfico de hoje.", "error");
    setStatus("Não consegui consultar a tábua agora. Confira sua conexão e tente novamente.", "error");
  }
  async function consult() {
    button.disabled = true;
    resultBox.hidden = true;
    setStatus("Pedindo sua localização ao navegador…");
    try {
      const position = await getLocation();
      setStatus("Achei sua localização. Buscando a previsão mais próxima…");
      const lat = position.coords.latitude;
      const lng = position.coords.longitude;
      const nearest = await getJson(`${apiBase}/nearest-harbor-independent-state/[${lat},${lng}]`);
      const harbor = nearest.data?.[0];
      if (!harbor || !harbor.id) throw new Error("harbor-not-found");
      const offsetHours = Number(String(harbor.timezone || "").replace(/^UTC\s*/i, "").trim());
      if (!Number.isFinite(offsetHours)) throw new Error("timezone-not-found");
      const localNow = new Date(Date.now() + offsetHours * 60 * 60 * 1000);
      const year = localNow.getUTCFullYear();
      const month = localNow.getUTCMonth() + 1;
      const day = localNow.getUTCDate();
      const todayStart = Date.UTC(year, month - 1, day);
      const nowMinute = localNow.getUTCHours() * 60 + localNow.getUTCMinutes() + localNow.getUTCSeconds() / 60;
      const dates = [-1, 0, 1].map(offset => new Date(todayStart + offset * 86400000));
      const groups = new Map();
      for (const date of dates) {
        if (date.getUTCFullYear() !== year) continue;
        const monthNumber = date.getUTCMonth() + 1;
        if (!groups.has(monthNumber)) groups.set(monthNumber, new Set());
        groups.get(monthNumber).add(date.getUTCDate());
      }
      const tableResponses = await Promise.all([...groups.entries()].map(([monthNumber, days]) => {
        const dayList = [...days].sort((a, b) => a - b).join(",");
        return getJson(`${apiBase}/tabua-mare/${encodeURIComponent(harbor.id)}/${monthNumber}/[${dayList}]`);
      }));
      const events = collectEvents(tableResponses, todayStart);
      const dayEvents = events.filter(event => event.minute >= 0 && event.minute <= 1440);
      if (dayEvents.length < 2) throw new Error("no-tide-data");
      const previous = events.filter(event => event.minute <= nowMinute).pop();
      const next = events.find(event => event.minute > nowMinute);
      let currentLevel = null;
      if (previous && next && next.minute > previous.minute) {
        const ratio = (nowMinute - previous.minute) / (next.minute - previous.minute);
        currentLevel = previous.level + (next.level - previous.level) * ratio;
        const change = next.level - previous.level;
        const direction = Math.abs(change) < 0.01 ? "quase estável" : change > 0 ? "subindo" : "baixando";
        summary.textContent = `Pela previsão, a maré está ${direction}. Altura aproximada agora: ${formatLevel(currentLevel)} m. Próxima mudança: ${pad(next.day)}/${pad(next.month)} às ${next.hour}.`;
      } else {
        summary.textContent = "Há previsão para hoje, mas não informações suficientes para estimar a maré neste momento.";
      }
      portLabel.textContent = `Previsão do porto mais próximo: ${harbor.harbor_name}`;
      timeLabel.textContent = `Previsão de hoje · ${pad(day)}/${pad(month)}/${year}`;
      drawChart(dayEvents, nowMinute, currentLevel, year, month, day);
      resultBox.hidden = false;
      setStatus("Consulta concluída.");
    } catch (error) {
      showError(error);
    } finally {
      button.disabled = false;
    }
  }
  button.addEventListener("click", consult);
})();
</script></div>

## O porto é uma referência, não a piscina natural

O botão procura o porto mais próximo e mostra a previsão para hoje, no horário local. Assim você tem uma noção da tendência antes de sair.

Essa previsão não mostra exatamente o que acontece na praia. Vento, ondas, recifes e o formato do lugar também fazem diferença. A Marinha explica que as tábuas não consideram as condições do tempo; [veja as informações do CHM sobre marés](https://www.marinha.mil.br/chm/pagina-basica/informacoes-sobre-mares).

Se você vai fazer o passeio, pergunte à operadora qual horário costuma funcionar melhor naquele ponto. Se organiza o roteiro, considere o tempo do trajeto e siga a orientação de quem conhece a região. A tábua ajuda a planejar; a conversa local completa o quadro.

## Use a previsão junto com a conversa local

O gráfico ajuda a entender a previsão para o porto mais próximo. Sozinho, ele não diz se a piscina estará acessível, se o mar estará calmo ou se o passeio deve acontecer.

Se você organiza passeios, vale mostrar essa previsão junto com a duração do roteiro e as orientações da equipe. Se vai visitar, confira a data e pergunte sobre as condições do ponto. Quem conhece o caminho tem a melhor informação sobre o passeio.

Quer explorar outras consultas? Acesse o [playground da Tábua de Marés](https://tabuamare.api.br/playground).
