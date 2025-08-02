# daisyuiwidget

An experimental R htmlwidget for rendering timeline components inspired by [daisyUI](https://daisyui.com/components/timeline). 
Built with the goal of testing out LLMs' ability to create this package.
All text below is LLM-generated and may not accurately reflect the status of repo contents!


# LLM Summary

Build with the goal of wrapping Tailwind + daisyUI styles into a reusable htmlwidget for use in Shiny apps and R Markdown.

> ⚠️ **Project status: on hold**  
> This widget renders timelines, but the full daisyUI styles are not yet functioning correctly due to challenges compiling and bundling Tailwind/daisyUI CSS. The JS rendering pipeline works correctly, and a minimal inline CSS fallback is currently in place. Full styling integration is a work in progress.

## Installation

This is not yet available on CRAN. You can install it from source:

```r
# assuming you have the repo locally
devtools::install("path/to/daisyuiwidget")
```

## Usage

```
library(daisyuiwidget)

daisyTimeline(list(
  list(date = "2022", content = "Planning"),
  list(date = "2023", content = "Development"),
  list(date = "2024", content = "Launch 🚀")
))
```

## Current Features

- Accepts a list of timeline events (each with date, content)
- Renders structured HTML using JavaScript
- Works inside R Markdown and Shiny

## Known Issues
- CSS styling from daisyUI is incomplete
- Tailwind/daisyUI classes are purged or missing without full build step
- Visual output does not yet match daisyUI demo components

## Next Steps (if resumed)
- Integrate precompiled Tailwind + daisyUI CSS
- Support alternate layouts (left/right sides)
- Optional icons or status indicators
- Parameterise colors, spacing, or responsiveness
