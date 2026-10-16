# Lesson 01 slides

- `lab01-slides.pdf`: the deck as presented in class.
- `lab01.md`: the same deck as Markdown source ([Marp](https://marp.app/)).
  Open it in Visual Studio Code with the Marp extension to preview it.
- `theme/cisd.css`, `assets/`: theme and figures used by the Markdown.

To rebuild the PDF from this folder:

```bash
npx @marp-team/marp-cli@4.2.3 --theme theme/cisd.css --allow-local-files lab01.md -o lab01-slides.pdf
```

The theme loads the IBM Plex fonts from Google Fonts, so the build needs a network
connection.
