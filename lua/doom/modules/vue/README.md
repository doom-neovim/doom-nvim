# Vue 

This doom module provides support for vue 3 projects using the `volar` language server.

## Notes

It creates 3 instances of the volar language server to avoid blocking user input for completions while performing diagnostics in the background.
This is the same way that `coc-volar` and the `Volar` extension for VSCode do it.

## Troubleshooting

### Only works in projects with typescript@^4.X.X
Volar depends on `tsserverlibrary.js` (provided by the `typescript` npm package).  
While other `coc-volar` will install it's own `typescript` npm package, this implementation will use the same typescript version from your project's `node_modules`.
Please make sure your projects are using `typescript@^4.X.X`.


