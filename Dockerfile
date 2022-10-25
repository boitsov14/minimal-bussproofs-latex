FROM alpine:latest AS installer
RUN apk add --no-cache perl tar wget
WORKDIR /install-tl-unx
RUN wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN tar xvzf ./install-tl-unx.tar.gz --strip-components=1
COPY texlive.profile .
RUN ./install-tl --profile=texlive.profile
RUN ln -sf /usr/local/texlive/*/bin/* /usr/local/bin/texlive
ENV PATH=/usr/local/bin/texlive:$PATH
RUN tlmgr install \
  amsfonts \
  bussproofs \
  dvipng \
  latex-bin \
  preview \
  standalone \
  varwidth \
  xkeyval

FROM alpine:latest
COPY --from=installer /usr/local/texlive/*/texmf-var/web2c/pdftex/latex.fmt             /usr/local/texlive/texmf-var/web2c/pdftex/latex.fmt
COPY --from=installer /usr/local/texlive/*/texmf-var/ls-R                               /usr/local/texlive/texmf-var/ls-R
COPY --from=installer /usr/local/texlive/*/texmf-var/fonts/map/dvips/updmap/psfonts.map /usr/local/texlive/texmf-var/fonts/map/dvips/updmap/psfonts.map
COPY --from=installer /usr/local/texlive/*/texmf-dist/fonts/tfm/public/cm               /usr/local/texlive/texmf-dist/fonts/tfm/public/cm
COPY --from=installer /usr/local/texlive/*/texmf-dist/fonts/type1/public/amsfonts/cm    /usr/local/texlive/texmf-dist/fonts/type1/public/amsfonts/cm
COPY --from=installer /usr/local/texlive/*/texmf-dist/ls-R                              /usr/local/texlive/texmf-dist/ls-R
COPY --from=installer /usr/local/texlive/*/texmf-dist/tex/generic/xkeyval               /usr/local/texlive/texmf-dist/tex/generic/xkeyval
COPY --from=installer /usr/local/texlive/*/texmf-dist/tex/latex/xkeyval                 /usr/local/texlive/texmf-dist/tex/latex/xkeyval
COPY --from=installer /usr/local/texlive/*/texmf-dist/tex/latex/l3backend               /usr/local/texlive/texmf-dist/tex/latex/l3backend
COPY --from=installer /usr/local/texlive/*/texmf-dist/tex/latex/base                    /usr/local/texlive/texmf-dist/tex/latex/base
COPY --from=installer /usr/local/texlive/*/texmf-dist/tex/latex/varwidth                /usr/local/texlive/texmf-dist/tex/latex/varwidth
COPY --from=installer /usr/local/texlive/*/texmf-dist/tex/latex/preview                 /usr/local/texlive/texmf-dist/tex/latex/preview
COPY --from=installer /usr/local/texlive/*/texmf-dist/tex/latex/bussproofs              /usr/local/texlive/texmf-dist/tex/latex/bussproofs
COPY --from=installer /usr/local/texlive/*/texmf-dist/tex/latex/standalone              /usr/local/texlive/texmf-dist/tex/latex/standalone
COPY --from=installer /usr/local/texlive/*/texmf-dist/web2c/texmf.cnf                   /usr/local/texlive/texmf-dist/web2c/texmf.cnf
COPY --from=installer /usr/local/texlive/*/bin/x86_64-linuxmusl/dvipng                  /usr/local/texlive/bin/x86_64-linuxmusl/dvipng
COPY --from=installer /usr/local/texlive/*/bin/x86_64-linuxmusl/latex                   /usr/local/texlive/bin/x86_64-linuxmusl/latex
