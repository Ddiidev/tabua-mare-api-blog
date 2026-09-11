(() => {
  const languageAliases = {
    cs: 'csharp',
    csharp: 'csharp',
    dotnet: 'csharp',
    v: 'v',
    vlang: 'v',
    go: 'go',
    golang: 'go',
    js: 'javascript',
    javascript: 'javascript',
    ts: 'typescript',
    typescript: 'typescript',
  };

  const keywords = {
    csharp: new Set('abstract as async await base bool break byte case catch char checked class const continue decimal default delegate do double else enum event explicit extern false finally fixed float for foreach goto if implicit in int interface internal is lock long namespace new null object operator out override params partial private protected public readonly record ref return sbyte sealed short sizeof stackalloc static string struct switch this throw true try typeof uint ulong unchecked unsafe ushort using var virtual void volatile while yield'.split(' ')),
    v: new Set('as asm assert atomic break chan const continue defer else enum false fn for go goto if import in interface is lock match module mut none or pub return rlock select shared sizeof spawn static struct true type typeof union unsafe volatile __global'.split(' ')),
    go: new Set('break case chan const continue default defer else fallthrough false for func go goto if import interface map nil package range return select struct switch true type var'.split(' ')),
    javascript: new Set('async await break case catch class const continue debugger default delete do else export extends false finally for from function get if import in instanceof let new null of return set static super switch this throw true try typeof undefined var void while with yield'.split(' ')),
    typescript: new Set('abstract any as asserts async await bigint boolean break case catch class const constructor continue debugger declare default delete do else enum export extends false finally for from function get if implements import in infer instanceof interface is keyof let module namespace never new null number object of override private protected public readonly require return set static string super switch symbol this throw true try type typeof undefined unique unknown var void while with yield'.split(' ')),
  };

  function token(kind, value) {
    const span = document.createElement('span');
    span.className = `syntax-${kind}`;
    span.textContent = value;
    return span;
  }

  function highlight(code, language) {
    const source = code.textContent || '';
    const fragment = document.createDocumentFragment();
    let index = 0;

    while (index < source.length) {
      const current = source[index];
      const next = source[index + 1];

      if (current === '/' && next === '/') {
        const end = source.indexOf('\n', index);
        const stop = end === -1 ? source.length : end;
        fragment.append(token('comment', source.slice(index, stop)));
        index = stop;
        continue;
      }

      if (current === '/' && next === '*') {
        const end = source.indexOf('*/', index + 2);
        const stop = end === -1 ? source.length : end + 2;
        fragment.append(token('comment', source.slice(index, stop)));
        index = stop;
        continue;
      }

      if (current === '"' || current === "'" || current === '`') {
        let stop = index + 1;
        while (stop < source.length) {
          if (source[stop] === '\\') {
            stop += 2;
            continue;
          }
          if (source[stop] === current) {
            stop += 1;
            break;
          }
          stop += 1;
        }
        fragment.append(token('string', source.slice(index, stop)));
        index = stop;
        continue;
      }

      if (/\d/.test(current)) {
        let stop = index + 1;
        while (stop < source.length && /[\dA-Fa-f_xXbBoO.]/.test(source[stop])) stop += 1;
        fragment.append(token('number', source.slice(index, stop)));
        index = stop;
        continue;
      }

      if (/[A-Za-z_$]/.test(current)) {
        let stop = index + 1;
        while (stop < source.length && /[A-Za-z0-9_$]/.test(source[stop])) stop += 1;
        const word = source.slice(index, stop);
        fragment.append(keywords[language].has(word) ? token('keyword', word) : document.createTextNode(word));
        index = stop;
        continue;
      }

      fragment.append(document.createTextNode(current));
      index += 1;
    }

    code.replaceChildren(fragment);
    code.dataset.highlighted = 'true';
  }

  document.querySelectorAll('.post-body pre > code').forEach((code) => {
    const languageClass = [...code.classList].find((className) => className.startsWith('language-'));
    const language = languageAliases[languageClass?.slice(9).toLowerCase()];
    if (language) highlight(code, language);
  });

  const scrollFadeElements = [...document.querySelectorAll('[data-scroll-fade]')];
  const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');

  const revealScrollFade = (element) => {
    element.classList.remove('is-scroll-pending');
    element.classList.add('is-scroll-revealed');
  };

  if (scrollFadeElements.length > 0) {
    if (reducedMotion.matches || !('IntersectionObserver' in window)) {
      scrollFadeElements.forEach(revealScrollFade);
    } else {
      const scrollFadeObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach((entry) => {
          if (!entry.isIntersecting) return;
          revealScrollFade(entry.target);
          observer.unobserve(entry.target);
        });
      }, { rootMargin: '0px 0px -10% 0px', threshold: 0.12 });

      scrollFadeElements.forEach((element) => {
        const isAlreadyVisible = element.getBoundingClientRect().top < window.innerHeight * 0.9;
        if (isAlreadyVisible) {
          revealScrollFade(element);
          return;
        }
        element.classList.add('is-scroll-pending');
        scrollFadeObserver.observe(element);
      });
    }
  }

  const syncCodeScrollFade = () => {
    document.querySelectorAll('.post-body pre').forEach((codeBlock) => {
      const overflowsHorizontally = codeBlock.scrollWidth > codeBlock.clientWidth + 1;
      codeBlock.classList.toggle('scroll-fade-x', overflowsHorizontally);
    });
  };

  syncCodeScrollFade();
  window.addEventListener('resize', syncCodeScrollFade, { passive: true });

  const topVignette = document.querySelector('.content-scroll-vignette--top');
  const bottomVignette = document.querySelector('.content-scroll-vignette--bottom');
  if (topVignette && bottomVignette) {
    let vignetteFrame;
    const vignetteThreshold = 24;

    const syncContentVignette = () => {
      const scrollElement = document.scrollingElement || document.documentElement;
      const scrollTop = scrollElement.scrollTop;
      const maxScroll = Math.max(0, scrollElement.scrollHeight - window.innerHeight);
      topVignette.classList.toggle('is-hidden', scrollTop <= vignetteThreshold);
      bottomVignette.classList.toggle('is-hidden', maxScroll === 0 || scrollTop >= maxScroll - 1);
      vignetteFrame = undefined;
    };

    const scheduleContentVignette = () => {
      if (!vignetteFrame) vignetteFrame = window.requestAnimationFrame(syncContentVignette);
    };

    syncContentVignette();
    window.addEventListener('scroll', scheduleContentVignette, { passive: true });
    document.addEventListener('scroll', scheduleContentVignette, { passive: true, capture: true });
    window.addEventListener('resize', scheduleContentVignette, { passive: true });
  }

  const boat = document.querySelector('.tide-track--divider .tide-boat');
  if (boat) {
    const track = boat.closest('.tide-track--divider');
    let scheduled = false;

    const updateBoat = () => {
      const maxScroll = Math.max(0, document.documentElement.scrollHeight - window.innerHeight);
      const progress = maxScroll === 0 ? 0 : Math.min(1, Math.max(0, window.scrollY / maxScroll));
      const padding = 8;
      const maxLeft = Math.max(padding, track.clientWidth - boat.offsetWidth - padding);
      boat.style.setProperty('--boat-left', `${padding + (maxLeft - padding) * progress}px`);
      scheduled = false;
    };

    const scheduleBoatUpdate = () => {
      if (!scheduled) {
        scheduled = true;
        window.requestAnimationFrame(updateBoat);
      }
    };

    updateBoat();
    window.addEventListener('scroll', scheduleBoatUpdate, { passive: true });
    window.addEventListener('resize', scheduleBoatUpdate);
  }

  const postTitle = document.querySelector('#post-title')?.textContent.trim() || document.title;
  const articleUrl = window.location.href;
  const encodedTitle = encodeURIComponent(postTitle);
  const encodedUrl = encodeURIComponent(articleUrl);
  const encodedMessage = encodeURIComponent(`${postTitle} ${articleUrl}`);
  const shareUrls = {
    whatsapp: `https://wa.me/?text=${encodedMessage}`,
    telegram: `https://t.me/share/url?url=${encodedUrl}&text=${encodedTitle}`,
    x: `https://x.com/intent/post?text=${encodedMessage}`,
    bluesky: `https://bsky.app/intent/compose?text=${encodedMessage}`,
  };

  document.querySelectorAll('a[data-share-service]').forEach((link) => {
    link.href = shareUrls[link.dataset.shareService];
  });

  const instagramButton = document.querySelector('[data-share-service="instagram"]');
  const shareStatus = document.querySelector('#share-status');
  instagramButton?.addEventListener('click', async () => {
    const shareData = { title: postTitle, text: postTitle, url: articleUrl };
    try {
      if (navigator.share && (!navigator.canShare || navigator.canShare(shareData))) {
        await navigator.share(shareData);
        if (shareStatus) shareStatus.textContent = 'Menu de compartilhamento aberto.';
        return;
      }
      await navigator.clipboard.writeText(articleUrl);
      if (shareStatus) shareStatus.textContent = 'Link copiado. Cole no Instagram.';
    } catch (error) {
      if (error?.name !== 'AbortError' && shareStatus) {
        shareStatus.textContent = 'Não foi possível compartilhar. Copie o endereço desta página.';
      }
    }
  });
})();
