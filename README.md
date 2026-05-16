# Standard Errors

Standard Errors is a small standard for user-facing failure messages.

This repo is the home of the Standard Errors specification website. It uses Hugo, versioned content, a small header, a short welcome section, and the specification as the main page.

## Repo Layout

- `content/v0.1.0/`: the current draft specification.
- `themes/standard-errors/`: Hugo templates and bundled CSS.

## Development

- **Check tools**: `make deps`
- **Lint templates**: `make lint`
- **Test build**: `make test`
- **Build**: `make build`
- **Preview locally**: `make run`

## Deployment

CI runs a strict Hugo build for pushes and pull requests. The Pages workflow builds `public/` and deploys it with GitHub Pages on pushes to `main`.

## License

[Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/).
