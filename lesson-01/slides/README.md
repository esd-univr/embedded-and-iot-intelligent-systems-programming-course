# Lesson 01 slides

English and Italian versions of the same deck (same 30 slides):

- `lab01-slides.pdf` and `lab01-slides.it.pdf`: the decks as presented in class.
- `lab01.md` and `lab01.it.md`: the Markdown sources ([Marp](https://marp.app/)).
  Open them in Visual Studio Code with the Marp extension to preview them.
- `theme/cisd.css`, `assets/`: theme and figures used by the Markdown.

To rebuild a PDF from this folder:

```bash
npx @marp-team/marp-cli@4.2.3 --theme theme/cisd.css --allow-local-files lab01.md -o lab01-slides.pdf
npx @marp-team/marp-cli@4.2.3 --theme theme/cisd.css --allow-local-files lab01.it.md -o lab01-slides.it.pdf
```

The theme loads the IBM Plex fonts from Google Fonts, so the build needs a network
connection.
